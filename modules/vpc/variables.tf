variable "name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "availability_zones" {
  type = list(string)

  validation {
    condition     = length(var.availability_zones) >= 2
    error_message = "At least two availability zones are required."
  }
}

variable "public_subnet_cidrs" {
  type = list(string)

  validation {
    condition     = length(var.public_subnet_cidrs) == length(var.availability_zones)
    error_message = "Public subnet CIDRs must match the number of availability zones."
  }
}

variable "app_subnet_cidrs" {
  type = list(string)

  validation {
    condition     = length(var.app_subnet_cidrs) == length(var.availability_zones)
    error_message = "App subnet CIDRs must match the number of availability zones."
  }
}

variable "database_subnet_cidrs" {
  type = list(string)

  validation {
    condition     = length(var.database_subnet_cidrs) == length(var.availability_zones)
    error_message = "Database subnet CIDRs must match the number of availability zones."
  }
}

variable "tags" {
  type    = map(string)
  default = {}
}
