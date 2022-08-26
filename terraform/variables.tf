variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "PrettyGreenPlants_Host_Server"
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