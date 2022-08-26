variable "aws_region" {
  type    = string
  default = "ap-southeast-1"
}

variable "organization_name" {
  type    = string
  default = "prettygreenplants"
}

variable "workspace_name" {
  type    = string
  default = "prettygreenplants_com"
}

variable "instance_name" {
  type        = string
  default     = "PrettyGreenPlants_Host_Server"
}

variable "context" {
  type        = string
  default     = "production"
}

variable "AWS_ACCESS_KEY_ID" {
  description = "Access Key ID"
  type        = string
  default     = ""
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "Secret Access Key"
  type        = string
  default     = ""
}
