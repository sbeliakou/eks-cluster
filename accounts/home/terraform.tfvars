region            = "eu-west-1"
vpc_cidr          = "10.223.0.0/16"
single_nat_gateway= true

eks_cluster_size  = {
  min_size        = 1
  max_size        = 5
  desired_size    = 1
}

eks_instance_types = ["t3.small"]
eks_managed_node_group_capacity_type = "SPOT"
karpenter_enabled = true

aws_ecr_docker_registry = [ 
  "leather",
  "feather",
  "neither",
  "weather"
]

tags = {
  Charge_Code = "12345"
  Service_Owner = "backoffice"
  Technical_Owner = "Siarhei Beliakou"
  Orchestration = "Terraform"
}