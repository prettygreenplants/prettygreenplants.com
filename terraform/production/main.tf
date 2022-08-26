provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = var.context
    }
  }
}

resource "aws_instance" "app_server" {
  ami           = "ami-02ee763250491e04a"
  instance_type = "t2.micro"

  tags = {
    Name = var.instance_name
  }
}
