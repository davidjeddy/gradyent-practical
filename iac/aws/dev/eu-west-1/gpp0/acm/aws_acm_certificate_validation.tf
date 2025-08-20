resource "aws_acm_certificate_validation" "this" {
  certificate_arn = aws_acm_certificate.this.arn

  validation_record_fqdns = [
    for record in aws_route53_record.acm : record.fqdn
  ]

  timeouts {
    create = "5m"
  }
}