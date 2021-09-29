data "aws_region" "current" {
}

# Grab the most recent ECS AMI for the EC2 launch config
data "aws_ssm_parameter" "target_ami" {
  name = var.arch == "arm64" ? "/aws/service/ecs/optimized-ami/amazon-linux-2/arm64/recommended" : "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended"
}

# Using default VPC + subnets (default subnets are public)
data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

# Cloudwatch
resource "aws_cloudwatch_log_group" "testapp" {
  name = "${var.app_name}-log-group"
}

# ECR repo
resource "aws_ecr_repository" "repo" {
  name = var.app_name
}

#ECS definitions
resource "aws_ecs_cluster" "dev" {
  name = "${var.app_name}-dev-cluster"
}

data "template_file" "app" {
  template = file("${path.module}/templates/service.json.tpl")
  vars = {
    aws_ecr_repository = aws_ecr_repository.repo.repository_url
    tag                = var.image_tag
    region             = data.aws_region.current.name
    port               = var.image_port
    name               = var.app_name
  }
}

resource "aws_ecs_task_definition" "ecs_task" {
  family                   = var.app_name
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions    = data.template_file.app.rendered

  # Don't create task definition till image is in ECR
  depends_on = [null_resource.push]
}

resource "aws_ecs_service" "ecs_service" {
  name            = "${var.app_name}-service"
  cluster         = aws_ecs_cluster.dev.id
  task_definition = aws_ecs_task_definition.ecs_task.arn
  desired_count   = 1

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = data.aws_subnet_ids.default.ids
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.tg.arn
    container_name   = var.app_name
    container_port   = var.image_port
  }

  depends_on = [aws_lb_listener.http_forward, aws_iam_role_policy_attachment.ecs_task_execution_role]

}

# Null resource to build docker image
resource "null_resource" "push" {
  triggers = {
    # Trigger a push when sha1 of files in the project directory change.
    dir_sha1 = sha1(join("", [for f in fileset("${path.module}/../../project", "*"): filesha1("${path.module}/../../project/${f}")]))
  }
  provisioner "local-exec" {
    command     = "${path.module}/scripts/ecr-push.sh ${aws_ecr_repository.repo.repository_url} ${var.image_tag} ${var.source_path}"
    interpreter = ["bash", "-c"]
  }
}
