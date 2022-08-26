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
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
}

resource "aws_instance" "app_server" {
  ami           = "ami-02ee763250491e04a"
  instance_type = "t2.micro"

  tags = {
    Name = var.instance_name
  }
}
