## Autoscaling groups and launch configuration
## TODO Add scaling policy

resource "aws_autoscaling_group" "ecs_asg" {
  name                      = "${var.app_name}-asg"
  vpc_zone_identifier       = data.aws_subnet_ids.default.ids
  launch_configuration      = aws_launch_configuration.ecs_launch_config.name
  desired_capacity          = 1
  min_size                  = 1
  max_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
}

resource "aws_launch_configuration" "ecs_launch_config" {
  name_prefix          = var.app_name
  image_id             = jsondecode(data.aws_ssm_parameter.target_ami.value).image_id
  iam_instance_profile = aws_iam_instance_profile.ecs_agent.name
  security_groups      = [aws_security_group.ecs_tasks.id]
  user_data            = "#!/bin/bash\necho ECS_CLUSTER='${var.app_name}-dev-cluster' >> /etc/ecs/ecs.config" #Required for ECS cluster discovery
  instance_type        = var.arch == "arm64" ? "t4g.micro" : "t3.micro"
}