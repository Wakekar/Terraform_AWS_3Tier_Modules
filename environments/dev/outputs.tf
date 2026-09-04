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

output "instance_profile_name" {
  value = module.iam.instance_profile_name
}

output "nat_gateway_id" {
  value = module.nat.nat_gateway_id
}

output "nat_gateway_public_ip" {
  value = module.nat.nat_gateway_public_ip
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "alb_arn" {
  value = module.alb.alb_arn
}

output "target_group_arn" {
  value = module.alb.target_group_arn
}

output "autoscaling_group_name" {
  value = module.compute.autoscaling_group_name
}

output "database_endpoint" {
  value = module.database.db_endpoint
}

output "database_address" {
  value = module.database.db_address
}

output "database_port" {
  value = module.database.db_port
}


output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS cluster API endpoint"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_version" {
  description = "EKS Kubernetes version"
  value       = module.eks.cluster_version
}

output "eks_node_group_name" {
  description = "EKS managed node group name"
  value       = module.eks.node_group_name
}

output "eks_oidc_issuer" {
  description = "EKS OIDC issuer"
  value       = module.eks.oidc_issuer
}




