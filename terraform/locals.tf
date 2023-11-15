locals {
  vpc_name = format("%s-eks-vpc", var.prefix_name)
  availability_zones = slice(data.aws_availability_zones.default.names, 0, 3)
  private_subnets = [for k, v in local.availability_zones : cidrsubnet(var.vpc_cidr, 4, k)]
  public_subnets  = [for k, v in local.availability_zones : cidrsubnet(var.vpc_cidr, 8, k + 48)]
  control_plane_subnets = [for k, v in local.availability_zones : cidrsubnet(var.vpc_cidr, 8, k + 52)]

  eks_cluster_name = format("%s-eks-cluster", var.prefix_name)
  aws_ecr_docker_registry_enable = length(var.aws_ecr_docker_registry) > 0 ? true : false

  ecr_policy_arns = {
    for key, policy in aws_iam_policy.ecr_access : key => policy.arn
  }

  aws_auth_roles = concat([
    {
      rolearn  = module.eks.cluster_iam_role_arn
      username = "system:node:{{EC2PrivateDNSName}}"
      groups = [ "system:bootstrappers", "system:nodes"]
    },
    var.karpenter_enabled ? {
        rolearn  = module.karpenter[0].role_arn
        username = "system:node:{{EC2PrivateDNSName}}"
        groups   = ["system:bootstrappers", "system:nodes"]
    } : null,
  ], [
    for user in var.aws_auth :
    user.rolearn != null ? {
      rolearn  = user.rolearn
      username = user.username
      groups   = user.groups
    } : null
    if user.rolearn != null
  ])

  aws_auth_users = [
    for user in var.aws_auth :
    user.userarn != null ? {
      userarn  = user.userarn
      username = user.username
      groups   = user.groups
    } : null
    if user.userarn != null
  ]
}

