module "karpenter" {
  count = var.karpenter_enabled ? 1 : 0
  source = "terraform-aws-modules/eks/aws//modules/karpenter"
  cluster_name = module.eks.cluster_name

  irsa_oidc_provider_arn          = module.eks.oidc_provider_arn
  irsa_namespace_service_accounts = ["karpenter:karpenter"]

  create_iam_role = false
  iam_role_arn    = module.eks.eks_managed_node_groups["one"].iam_role_arn
  enable_karpenter_instance_profile_creation = true

  iam_role_additional_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  tags = var.tags
}

resource "helm_release" "karpenter" {
  count = var.karpenter_enabled ? 1 : 0

  name       = "karpenter"
  repository = "oci://public.ecr.aws/karpenter"
  repository_username = data.aws_ecrpublic_authorization_token.virginia.user_name
  repository_password = data.aws_ecrpublic_authorization_token.virginia.password
  chart      = "karpenter"
  namespace  = "karpenter"
  create_namespace = true
  version = "v0.32.1"
  wait = true

  values = [
    <<-EOT
    settings:
      clusterName: ${module.eks.cluster_name}
      clusterEndpoint: ${module.eks.cluster_endpoint}
      interruptionQueueName: ${module.karpenter[0].queue_name}
    serviceAccount:
      annotations:
        eks.amazonaws.com/role-arn: ${module.karpenter[0].irsa_arn} 
    EOT
  ]

  lifecycle {
    ignore_changes = [repository_password]
  }
}

resource "helm_release" "karpenter_nodes" {
  name       = "karpenter-nodes"
  chart      = "karpenter-nodes"
  repository = "./helm-charts/"

  set {
    name = "eksNodeGroupIAMRole"
    value = basename(module.karpenter[0].role_arn)
  }

  set {
    name = "clusterName"
    value = local.eks_cluster_name
  }

  set {
    name = "limits.cpu"
    value = "100"
  }

  set {
    name = "limits.memory"
    value = "20Gi"
  }

  set {
    name = "disruption.expireAfter"
    value = "4h"
  }
}