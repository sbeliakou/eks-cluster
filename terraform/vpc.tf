module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = local.vpc_name
  cidr = var.vpc_cidr

  azs             = local.availability_zones
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets
  intra_subnets   = local.control_plane_subnets

  enable_nat_gateway = true
  single_nat_gateway = var.single_nat_gateway
  enable_vpn_gateway = false

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = merge(
    {
      "kubernetes.io/role/internal-elb" = 1
    },
    var.karpenter_enabled ? {
      "karpenter.sh/discovery" = local.eks_cluster_name
    } : {}
  )

  tags = var.tags
}