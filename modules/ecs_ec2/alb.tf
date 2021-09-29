# Load balancer config
resource "aws_lb" "lb" {
  name               = "${var.app_name}-alb"
  subnets            = data.aws_subnet_ids.default.ids
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id]

}

resource "aws_lb_listener" "http_forward" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_lb_target_group" "tg" {
  name        = "${var.app_name}-alb-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.default.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "120"
    protocol            = "HTTP"
    matcher             = "200-299"
    timeout             = "20"
    path                = "/"
    unhealthy_threshold = "3"
  }
}