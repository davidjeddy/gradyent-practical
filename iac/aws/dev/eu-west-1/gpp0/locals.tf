locals {
  application = "graydent"
  delimiter = "-"
  env = "dev"
  name = join(local.delimiter, [local.env, local.application, var.deployment_id])
  region = "eu-west-1"
}
