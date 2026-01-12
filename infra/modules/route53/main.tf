resource "aws_route53_zone" "main" {
  name = var.domain_name

  tags = {
    Name = "${var.project_name}-hosted-zone"
  }
}

# A record pointing to ALB (add after ALB is created)
resource "aws_route53_record" "app" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.subdomain
  type    = "A"

  alias {
    name = var.alb_dns_name
    zone_id = var.alb_zone_id
    evaluate_target_health = true
  }
}