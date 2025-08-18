locals {
  delimiter = ""
  env = "dev"
  name = join(local.delimiter, [var.environment, var.application, var.component, var.deployment_id])
  region - "eu-west-1"
}
