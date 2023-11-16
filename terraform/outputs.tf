output "vpc_name" {
  description = "VPC Name"
  value       = local.vpc_name
}

output "availability_zones" {
  description = "Availability Zones"
  value       = local.availability_zones
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "Public Subnets"
  value = local.public_subnets
}

output "public_subnets_ids" {
  description = "Public Subnets IDs"
  value = module.vpc.public_subnets
}

output "private_subnets" {
  description = "Private Subnets"
  value = local.private_subnets
}

output "private_subnets_ids" {
  description = "Public Subnets IDs"
  value = module.vpc.private_subnets
}

output "control_plane_subnets" {
  description = "Private Subnets for EKS Control Plane"
  value = local.control_plane_subnets
}

output "control_plane_subnets_ids" {
  description = "Private Subnets IDs for EKS Control Plane"
  value = module.vpc.intra_subnets
}

output "eks_cluster_name" {
  description = "EKS Cluster Name"
  value = local.eks_cluster_name
}

output "aws_ecr_docker_registry" {
  value = join("\n", [for item in var.aws_ecr_docker_registry: item])
}

output "karpenter_irsa_role_arn" {
  value = var.karpenter_enabled ? module.karpenter[0].irsa_arn : null
}

output "karpenter_role_name" {
  value = var.karpenter_enabled ? basename(module.karpenter[0].role_arn) : null
}
