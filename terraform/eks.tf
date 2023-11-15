module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.19.1"

  cluster_name    = local.eks_cluster_name
  cluster_version = "1.28"

  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

  eks_managed_node_group_defaults = {
    iam_role_additional_policies = local.ecr_policy_arns
  }

  eks_managed_node_groups = {
    one = {
      name = format("%s-one", var.prefix_name)
      use_name_prefix = true

      min_size     = var.eks_cluster_size.min_size
      max_size     = var.eks_cluster_size.max_size
      desired_size = var.eks_cluster_size.desired_size

      instance_types = var.eks_instance_types
      capacity_type  = var.eks_managed_node_group_capacity_type
    }
  }

  manage_aws_auth_configmap = true
  aws_auth_roles = local.aws_auth_roles
  aws_auth_users = local.aws_auth_users
  aws_auth_accounts = var.aws_auth_accounts

  tags = merge(var.tags, 
    var.karpenter_enabled ? {
      "karpenter.sh/discovery" = local.eks_cluster_name
    }: null
  )
}