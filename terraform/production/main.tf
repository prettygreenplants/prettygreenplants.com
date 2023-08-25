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
  account_alias = "pgp2023"
}

resource "aws_key_pair" "keypair" {
  key_name   = "keypair-prettygreenplants"
  public_key = var.public_key
}

resource "aws_security_group" "sg-inbound" {
  name        = "inbound"
  description = "Allow inbound traffic"

  tags = {
    Name = "sg-inbound"
  }
}

resource "aws_security_group_rule" "allow-outbound-traffic" {
  type              = "egress"
  security_group_id = aws_security_group.sg-inbound.id
  description       = "Allow outbound traffic"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [ "0.0.0.0/0", ]
  ipv6_cidr_blocks  = []
  prefix_list_ids   = []
}

resource "aws_security_group_rule" "allow-inbound-ssh" {
  type              = "ingress"
  security_group_id = aws_security_group.sg-inbound.id
  description      = "Allow SSH in from anywhere"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [ "0.0.0.0/0", ]
  ipv6_cidr_blocks  = []
  prefix_list_ids   = []
}

resource "aws_security_group_rule" "allow-inbound-http" {
  type              = "ingress"
  security_group_id = aws_security_group.sg-inbound.id
  description      = "Allow HTTP in from anywhere"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = [ "0.0.0.0/0", ]
  ipv6_cidr_blocks  = []
  prefix_list_ids   = []
}

resource "aws_security_group_rule" "allow-inbound-https" {
  type              = "ingress"
  security_group_id = aws_security_group.sg-inbound.id
  description      = "Allow HTTPS in from anywhere"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [ "0.0.0.0/0", ]
  ipv6_cidr_blocks  = []
  prefix_list_ids   = []
}

resource "aws_instance" "hosting-server" {
  ami                    = "ami-055147723b7bca09a"
  instance_type          = "t2.micro"
  key_name               = "keypair-prettygreenplants"
  vpc_security_group_ids = [
    aws_security_group.sg-inbound.id
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
  bucket = "pgp2023-website-backup"

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