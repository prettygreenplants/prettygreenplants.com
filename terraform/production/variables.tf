variable "aws_region" {
  type    = string
  default = "ap-southeast-1"
}

variable "context" {
  type        = string
  default     = "production"
}

variable "private_key" {
  type        = string
  default     = "file(~/.ssh/prettygreenplants.pem)"
}

variable "public_key" {
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCk/nazrwyl2ZKRBQV4QopcR4x/kXnCJx52Uu1e814Qpcz/jYFnU4fNM5dcDh0e07MdCCmuG2LagmB7z8Bl1xRhV5+CexQuYp/cjSmbNVngVshxRRyJ/2KiI73Xl0mGOMaGLkwCDsNwW6tcumRlJMG5yWvGfSQVPSlsnlhX4KiISiAo09MBqlnGzQU73zsUxmv0+zBECVp7gsF30Pi9vrm9gLaGTs1vipc1sdynHcJb5rZqDjoZP3mZW8/OAe7uU8HDkHnLhZNypTZXUhtIkYmXITDjbGC/QYF1vUW6Qn/yJLDLU99FNQzzoS9dWmRsS8Hp19Tc7zYUEC7FkoKGQAsb info@prettygreenplants.com"
}