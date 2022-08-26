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

provider "aws" {
  region = "ap-southeast-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_instance" "app_server" {
  ami           = "ami-0c19b15b5c2b52789"
  instance_type = "t2.micro"

  tags = {
    Name = var.instance_name
  }
}
