data "aws_availability_zones" "default" {
  state = "available"
}

data "aws_eks_cluster" "default" {
  name = local.eks_cluster_name
  depends_on = [module.eks.cluster_name]
}

data "aws_eks_cluster_auth" "default" {
  name = local.eks_cluster_name
  depends_on = [module.eks.cluster_name]
}

data "aws_ecrpublic_authorization_token" "virginia" {
  provider = aws.virginia
}
