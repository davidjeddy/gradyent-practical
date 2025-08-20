terraform {
  required_version = "1.6.2" # Pinned here so we can convert to OpenTofu with minimal changes

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.9.0"
    }
  }
}