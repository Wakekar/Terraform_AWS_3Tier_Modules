variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "name" {
  type    = string
  default = "terraform-test"
}

variable "ami_id" {
  type    = string
  default = "ami-01a00762f46d584a1"
}

variable "instance_type" {
  type    = string
  default = "t2.large"
}

variable "key_name" {
  type    = string
  default = "DevOps-Ubuntu"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "availability_zones" {
  type = list(string)

  default = [
    "ap-south-1a",
    "ap-south-1b",
    "ap-south-1c"
  ]
}

variable "public_subnet_cidrs" {
  type = list(string)

  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24"
  ]
}

variable "app_subnet_cidrs" {
  type = list(string)

  default = [
    "10.0.11.0/24",
    "10.0.12.0/24",
    "10.0.13.0/24"
  ]
}

variable "database_subnet_cidrs" {
  type = list(string)

  default = [
    "10.0.21.0/24",
    "10.0.22.0/24",
    "10.0.23.0/24"
  ]
}

variable "tags" {
  type = map(string)

  default = {
    Project     = "Terraform-Test"
    Environment = "test"
    ManagedBy   = "Terraform"
  }
}

