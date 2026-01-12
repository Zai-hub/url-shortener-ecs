resource "aws_lb" "main" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = false

  tags = {
    Name = "${var.project_name}-alb"
}
}


# Blue target group
resource "aws_lb_target_group" "blue" {
  name        = "${var.project_name}-blue-tg"
  target_type = "ip"
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    enabled = true
    path = "/healthz"
    protocol = "HTTP"
    matcher = "200"
    interval = 30
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 5
  }

  deregistration_delay = 30

  tags = {
    Name = "${var.project_name}-blue-tg"
  }
}


# Green target group
resource "aws_lb_target_group" "green" {
  name        = "${var.project_name}-green-tg"
  target_type = "ip"
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    enabled = true
    path = "/healthz"
    protocol = "HTTP"
    matcher = "200"
    interval = 30
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 5
  }

  deregistration_delay = 30

  tags = {
    Name = "${var.project_name}-green-tg"
  }
}


# HTTP Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  tags = {
    Name = "${var.project_name}-http-listener"
  }
}


# HTTPS Listener
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.main.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn = var.acm_certificate_arn

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.blue.arn
  }

  tags = {
    Name = "${var.project_name}-https-listener"
  }
} 