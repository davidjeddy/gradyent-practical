resource "aws_route53_record" "acm" {
  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.this.zone_id
}

resource "aws_route53_record" "web_app" {
  name    = join(".", [var.web_app_sub_domain, var.root_domain])
  type    = "A"
  zone_id = data.aws_route53_zone.this.zone_id

  alias {
    name                   = data.aws_lb.web_app.dns_name
    zone_id                = data.aws_lb.web_app.zone_id
    evaluate_target_health = true
  }
}
