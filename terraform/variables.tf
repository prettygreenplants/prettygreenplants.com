variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "PrettyGreenPlants_Host_Server"
}

variable "access_key" {
  description = "Access Key ID"
  type        = string
  default     = ""
}

variable "secret_key" {
  description = "Secret Access Key"
  type        = string
  default     = ""
}