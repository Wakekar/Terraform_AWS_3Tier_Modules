output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "app_subnet_ids" {
  value = aws_subnet.app[*].id
}

output "database_subnet_ids" {
  value = aws_subnet.database[*].id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.main.id
}

output "public_route_table_id" {
  value = aws_route_table.public.id
}

output "app_route_table_ids" {
  value = aws_route_table.app[*].id
}

output "database_route_table_id" {
  value = aws_route_table.database.id
}
