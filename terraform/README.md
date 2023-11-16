## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.21.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.5.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.21.0 |
| <a name="provider_aws.virginia"></a> [aws.virginia](#provider\_aws.virginia) | 5.21.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.11.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | 19.19.1 |
| <a name="module_karpenter"></a> [karpenter](#module\_karpenter) | terraform-aws-modules/eks/aws//modules/karpenter | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 5.1.2 |

## Resources

| Name | Type |
|------|------|
| [aws_ecr_repository.repository](https://registry.terraform.io/providers/hashicorp/aws/5.21.0/docs/resources/ecr_repository) | resource |
| [aws_iam_policy.ecr_access](https://registry.terraform.io/providers/hashicorp/aws/5.21.0/docs/resources/iam_policy) | resource |
| [helm_release.karpenter](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.karpenter_nodes](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.metrics_server](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.nginx-ingress](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [aws_availability_zones.default](https://registry.terraform.io/providers/hashicorp/aws/5.21.0/docs/data-sources/availability_zones) | data source |
| [aws_ecrpublic_authorization_token.virginia](https://registry.terraform.io/providers/hashicorp/aws/5.21.0/docs/data-sources/ecrpublic_authorization_token) | data source |
| [aws_eks_cluster.default](https://registry.terraform.io/providers/hashicorp/aws/5.21.0/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.default](https://registry.terraform.io/providers/hashicorp/aws/5.21.0/docs/data-sources/eks_cluster_auth) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_auth"></a> [aws\_auth](#input\_aws\_auth) | Configure the aws-auth ConfigMap in Kubernetes | <pre>list(object({<br>    userarn  = string<br>    username = string<br>    groups   = list(string)<br>    rolearn  = string<br>  }))</pre> | `[]` | no |
| <a name="input_aws_auth_accounts"></a> [aws\_auth\_accounts](#input\_aws\_auth\_accounts) | AWS accounts that should have access to the EKS cluster | `list(string)` | `[]` | no |
| <a name="input_aws_ecr_docker_registry"></a> [aws\_ecr\_docker\_registry](#input\_aws\_ecr\_docker\_registry) | AWS ECR Docker Registry | `list(string)` | n/a | yes |
| <a name="input_eks_cluster_size"></a> [eks\_cluster\_size](#input\_eks\_cluster\_size) | EKS Node Group Size | `map(number)` | n/a | yes |
| <a name="input_eks_instance_types"></a> [eks\_instance\_types](#input\_eks\_instance\_types) | EKS Worker Node Instance Type | `list(string)` | <pre>[<br>  "t3.small"<br>]</pre> | no |
| <a name="input_eks_managed_node_group_capacity_type"></a> [eks\_managed\_node\_group\_capacity\_type](#input\_eks\_managed\_node\_group\_capacity\_type) | The capacity type of the managed node group. Specify whether you want to use regular ('ON\_DENAND') instances or 'SPOT' instances for your nodes in the EKS cluster's managed node group. | `string` | `"ON_DEMAND"` | no |
| <a name="input_karpenter_enabled"></a> [karpenter\_enabled](#input\_karpenter\_enabled) | n/a | `bool` | `false` | no |
| <a name="input_karpenter_nodepool_cpu_limits"></a> [karpenter\_nodepool\_cpu\_limits](#input\_karpenter\_nodepool\_cpu\_limits) | n/a | `number` | `1000` | no |
| <a name="input_karpenter_nodepool_expireafter_h"></a> [karpenter\_nodepool\_expireafter\_h](#input\_karpenter\_nodepool\_expireafter\_h) | n/a | `number` | `1` | no |
| <a name="input_nginx_ingress_enabled"></a> [nginx\_ingress\_enabled](#input\_nginx\_ingress\_enabled) | n/a | `bool` | `true` | no |
| <a name="input_prefix_name"></a> [prefix\_name](#input\_prefix\_name) | Prefix Name | `string` | `"cassius"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | n/a | yes |
| <a name="input_single_nat_gateway"></a> [single\_nat\_gateway](#input\_single\_nat\_gateway) | n/a | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map` | n/a | yes |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR range for VPC | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_availability_zones"></a> [availability\_zones](#output\_availability\_zones) | Availability Zones |
| <a name="output_aws_ecr_docker_registry"></a> [aws\_ecr\_docker\_registry](#output\_aws\_ecr\_docker\_registry) | ECR Registry created by the stack |
| <a name="output_control_plane_subnets"></a> [control\_plane\_subnets](#output\_control\_plane\_subnets) | Private Subnets for EKS Control Plane |
| <a name="output_control_plane_subnets_ids"></a> [control\_plane\_subnets\_ids](#output\_control\_plane\_subnets\_ids) | Private Subnets IDs for EKS Control Plane |
| <a name="output_eks_cluster_name"></a> [eks\_cluster\_name](#output\_eks\_cluster\_name) | EKS Cluster Name |
| <a name="output_karpenter_irsa_role_arn"></a> [karpenter\_irsa\_role\_arn](#output\_karpenter\_irsa\_role\_arn) | Karpenter IRSA Role ARN |
| <a name="output_karpenter_role_name"></a> [karpenter\_role\_name](#output\_karpenter\_role\_name) | Karpenter Role Name |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | Private Subnets |
| <a name="output_private_subnets_ids"></a> [private\_subnets\_ids](#output\_private\_subnets\_ids) | Public Subnets IDs |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | Public Subnets |
| <a name="output_public_subnets_ids"></a> [public\_subnets\_ids](#output\_public\_subnets\_ids) | Public Subnets IDs |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | VPC ID |
| <a name="output_vpc_name"></a> [vpc\_name](#output\_vpc\_name) | VPC Name |
