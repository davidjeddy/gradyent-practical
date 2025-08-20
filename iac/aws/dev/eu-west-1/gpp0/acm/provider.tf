provider "aws" {
  region = local.region

  default_tags {
    tags = {
      app       = "shared"
      deployment= var.deployment_id
      env       = local.env
      owner     = "david_j_eddy"
      terraform = "true"
    }
  }
}
