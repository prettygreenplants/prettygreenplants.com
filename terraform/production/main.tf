# System
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = var.context
    }
  }
}

# Constants
resource "aws_iam_account_alias" "alias" {
  account_alias = "pgp2022"
}

resource "aws_key_pair" "keypair" {
  key_name   = "keypair-prettygreenplants"
  public_key = var.public_key
}

resource "aws_security_group" "sg" {
  egress = [
    {
      cidr_blocks      = [ "0.0.0.0/0", ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]
  ingress = [
    {
      cidr_blocks      = [ "0.0.0.0/0", ]
      description      = ""
      from_port        = 22
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 22
    }
  ]

  tags = {
    Name = "sg-inbound"
  }
}

resource "aws_instance" "hosting-server" {
  ami                    = "ami-055147723b7bca09a"
  instance_type          = "t2.micro"
  key_name               = "keypair-prettygreenplants"
  vpc_security_group_ids = [
    aws_security_group.sg.id
  ]

  root_block_device {
    volume_size = 30
  }

  connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu"
      private_key = var.private_key
      timeout     = "4m"
   }

  tags = {
    Name = "hosting-server"
  }
}


resource "aws_eip" "elastic-ip" {
  vpc = true

  tags = {
    Name = "public-ip"
  }
}

resource "aws_eip_association" "elastic-ip-association" {
  instance_id   = aws_instance.hosting-server.id
  allocation_id = aws_eip.elastic-ip.id
}

resource "aws_s3_bucket" "bucket-backup" {
  bucket = "pgp2022-website-backup"

  tags = {
    Name        = "backup"
    Environment = var.context
  }
}

resource "aws_s3_bucket_public_access_block" "bucket-backup-access" {
  bucket = aws_s3_bucket.bucket-backup.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}