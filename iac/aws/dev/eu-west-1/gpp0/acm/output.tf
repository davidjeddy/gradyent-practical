output "https_dns" {
  value = join(".", [var.web_app_sub_domain, var.root_domain])
}

output "acm_tls_arn" {
  value = aws_acm_certificate.this.arn
}
