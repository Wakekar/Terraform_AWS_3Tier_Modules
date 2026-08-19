variable "name" {
  description = "Name prefix for NAT resources"
  type        = string
}

variable "public_subnet_id" {
  description = "Public subnet ID where NAT Gateway will be created"
  type        = string
}

variable "private_route_table_ids" {
  description = "Application private route table IDs"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to NAT resources"
  type        = map(string)
  default     = {}
}
