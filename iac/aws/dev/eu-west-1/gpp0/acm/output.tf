output "https_dns" {
  value = join(".", [var.web_app_sub_domain, var.root_domain])
}
