variable "prefix_name" {
  description = "Prefix Name"
  default = "cassius"
}

variable "vpc_cidr" {
  description = "CIDR range for VPC"
}

variable "single_nat_gateway" {
  description = "To use the single NAT Gateway or 1 per AZ"
  default = true
}

variable "region" {
  description = "AWS region"
  type = string
}

variable "tags" {
  type = map
  description = "A map of tags to add to all resources"
}

variable "aws_ecr_docker_registry" {
  type = list(string)
  description = "AWS ECR Docker Registry"
}

variable "eks_cluster_size" {
  type = map(number)
  description = "EKS Node Group Size"
}

variable "eks_managed_node_group_capacity_type" {
  type = string
  description = "The capacity type of the managed node group. Specify whether you want to use regular ('ON_DENAND') instances or 'SPOT' instances for your nodes in the EKS cluster's managed node group."
  default = "ON_DEMAND"
}

variable "eks_instance_types" {
  type = list(string)
  description = "EKS Worker Node Instance Type"
  default = ["t3.small"]
}

# Controls the mappings between AWS IAM (Identity and Access Management) roles and 
# Kubernetes RBAC (Role-Based Access Control) roles, allowing AWS users and roles 
# to interact with the EKS cluster.
variable "aws_auth" {
  description = "Configure the aws-auth ConfigMap in Kubernetes"
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
    rolearn  = string
  }))
  default = []
}

# This variable is a way to manage and control access to your EKS cluster, 
# ensuring that users and roles from specified AWS accounts can interact with 
# the Kubernetes cluster with the appropriate RBAC permissions. 
# It's a key component of setting up secure and controlled access to your EKS cluster
variable "aws_auth_accounts" {
  type = list(string)
  description = "AWS accounts that should have access to the EKS cluster"
  default = []  
}

variable "karpenter_enabled" {
  description = "To install Karpenter or not"
  type = bool
  default = false
}

variable "karpenter_nodepool_cpu_limits" {
  description = "Karpenter Node Group max CPU Capacity. Limit prevents Karpenter from creating new instances once the limit is exceeded."
  type = number
  default = 1000
}

variable "karpenter_nodepool_expireafter_h" {
  description = "The amount of time a Node can live on the cluster before being removed"
  type = number
  default = 1
}

variable "nginx_ingress_enabled" {
  type = bool
  default = true
}