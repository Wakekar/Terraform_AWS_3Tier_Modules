output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "app_subnet_ids" {
  value = module.vpc.app_subnet_ids
}

output "database_subnet_ids" {
  value = module.vpc.database_subnet_ids
}

#nat gateway use karaycha asel ter sarva hash remove kar
#output "nat_gateway_id" {
# value = module.nat.nat_gateway_id
#}

output "security_group_id" {
  value = aws_security_group.test_ec2.id
}

output "ec2_id" {
  value = aws_instance.test_ec2_1.id
}

output "ec2_public_ip" {
  value = aws_instance.test_ec2_1.public_ip
}


