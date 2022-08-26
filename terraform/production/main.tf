
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
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCk/nazrwyl2ZKRBQV4QopcR4x/kXnCJx52Uu1e814Qpcz/jYFnU4fNM5dcDh0e07MdCCmuG2LagmB7z8Bl1xRhV5+CexQuYp/cjSmbNVngVshxRRyJ/2KiI73Xl0mGOMaGLkwCDsNwW6tcumRlJMG5yWvGfSQVPSlsnlhX4KiISiAo09MBqlnGzQU73zsUxmv0+zBECVp7gsF30Pi9vrm9gLaGTs1vipc1sdynHcJb5rZqDjoZP3mZW8/OAe7uU8HDkHnLhZNypTZXUhtIkYmXITDjbGC/QYF1vUW6Qn/yJLDLU99FNQzzoS9dWmRsS8Hp19Tc7zYUEC7FkoKGQAsb pgp2022"
}