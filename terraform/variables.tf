variable "region" {
  type    = string
  default = "sa-east-1"
}

variable "vpc_name" {
  type    = string
  default = "fastapi-test"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

# Instância no free tier da AWS
variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "Free tier instance type"
}
