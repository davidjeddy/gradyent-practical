data "aws_route53_zone" "this" {
  name         = var.root_domain
  private_zone = false
}

data "aws_lb" "web_app" {
  arn = var.web_app_elb_arn
}
