resource "aws_acm_certificate" "this" {
  domain_name               = join(".", [var.web_app_sub_domain, var.root_domain])
  subject_alternative_names = [
    join(".", ["*", var.web_app_sub_domain, var.root_domain])
 ]

  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}