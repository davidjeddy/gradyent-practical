provider "aws" {
  region = local.region

  default_tags {
    tags = {
      app        = "gradyent_practical"
      deployment = var.deployment_id
      env        = local.env
      owner      = "david_j_eddy"
      terraform  = "true"
    }
  }
}
