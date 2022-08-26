terraform {

  cloud {
    organization = "prettygreenplants"

    workspaces {
      name = "prettygreenplants_com"
    }
  }

  required_providers {
    aws = {
      source  = "registry.terraform.io/hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}
