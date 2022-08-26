
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = var.context
    }
  }
}

resource "aws_iam_account_alias" "alias" {
  account_alias = "pgp2022"
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.app_server.id
  allocation_id = aws_eip.pgp2022.id
}

resource "aws_instance" "app_server" {
  ami           = "ami-02ee763250491e04a"
  instance_type = "t2.micro"
  key_name= "keypair-pgp2022"
  vpc_security_group_ids = [aws_security_group.main.id]

  connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu"
      private_key = var.private_key
      timeout     = "4m"
   }

  tags = {
    Name = "ec2-pgp2022"
  }
}

resource "aws_eip" "pgp2022" {
  vpc = true

  tags = {
    Name = "eip-pgp2022"
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "keypair-pgp2022"
  public_key = var.public_key
}

resource "aws_security_group" "main" {
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
 ingress                = [
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
}