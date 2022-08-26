terraform {

  cloud {
    organization = var.organization_name

    workspaces {
      name = var.workspace_name
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
