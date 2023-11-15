# eks-cluster

## Description

The project is dedicated to building a fully functional and easily configurable Proof of Concept (POC) for an Amazon Elastic Kubernetes Service (EKS) cluster, facilitated by Terragrunt/Terraform on AWS. This POC is designed to be ready for immediate use and showcases seamless configuration of various cluster components.

Key Features and Components of the Cluster:

1. **Custom VPC:**
   - A meticulously crafted Virtual Private Cloud (VPC) ensures a secure and isolated network environment, ready for immediate use and easily configurable to adapt to specific requirements.

2. **Worker Nodes (t3.small) on SPOT:**
   - Employing cost-effective resources, the cluster features worker nodes of type `t3.small` on Spot instances, providing both efficiency and cost-effectiveness. These nodes are easily configurable to meet changing workload demands.

3. **Nginx Ingress Controller:**
   - Integration of an Nginx Ingress Controller simplifies external access to services. The configuration is straightforward, allowing for easy adaptation to various traffic routing scenarios.

4. **Metrics Server:**
   - Inclusion of a Metrics Server facilitates the gathering and exposure of resource utilization data, contributing to effective monitoring and optimization. This feature is easily configurable to align with specific performance assessment needs.

5. **ECR Registries and IAM Role:**
   - Establishment of Amazon Elastic Container Registry (ECR) Registries, along with an Identity and Access Management (IAM) role, ensures secure image management. These configurations are adaptable and can be easily adjusted to meet evolving security and access requirements.

6. **Configurable External Access with IAM (aws-auth):**
   - A key feature is the ability to configure external access to the cluster using IAM (aws-auth). This enables fine-grained control over access permissions, making the cluster adaptable to varying user roles and security protocols.

## Simplified Diagram

![](/docs/images/infra.png)

## Costs Estimation

### With the single NAT Gateway

```
$ infracost breakdown  --terraform-var-file ../accounts/home/terraform.tfvars --path .
Evaluating Terraform directory at .
  ✔ Downloading Terraform modules 
  ✔ Evaluating Terraform directory 
  ✔ Retrieving cloud prices to calculate costs 

Project: eks-cluster/terraform

 Name                                                                                  Monthly Qty  Unit                    Monthly Cost 
                                                                                                                                         
 aws_ecr_repository.repository["feather"]                                                                                                
 └─ Storage                                                                                   Monthly cost depends on usage: $0.10 per GB             
                                                                                                                                         
 aws_ecr_repository.repository["leather"]                                                                                                
 └─ Storage                                                                                   Monthly cost depends on usage: $0.10 per GB             
                                                                                                                                         
 aws_ecr_repository.repository["neither"]                                                                                                
 └─ Storage                                                                                   Monthly cost depends on usage: $0.10 per GB             
                                                                                                                                         
 aws_ecr_repository.repository["weather"]                                                                                                
 └─ Storage                                                                                   Monthly cost depends on usage: $0.10 per GB             
                                                                                                                                         
 module.eks.aws_cloudwatch_log_group.this[0]                                                                                             
 ├─ Data ingested                                                                             Monthly cost depends on usage: $0.57 per GB             
 ├─ Archival Storage                                                                          Monthly cost depends on usage: $0.03 per GB             
 └─ Insights queries data scanned                                                           Monthly cost depends on usage: $0.0057 per GB           
                                                                                                                                         
 module.eks.aws_eks_cluster.this[0]                                                                                                      
 └─ EKS cluster                                                                                 730  hours                         $73.00 
                                                                                                                                         
 module.eks.module.eks_managed_node_group["one"].aws_eks_node_group.this[0]                                                              
 └─ module.eks.module.eks_managed_node_group["one"].aws_launch_template.this[0]                                                          
    ├─ Instance usage (Linux/UNIX, on-demand, t3.small)                                        730  hours                          $16.64 
    └─ EC2 detailed monitoring                                                                   7  metrics                         $2.10 
                                                                                                                                         
 module.eks.module.kms.aws_kms_key.this[0]                                                                                               
 ├─ Customer master key                                                                          1  months                          $1.00 
 ├─ Requests                                                                        Monthly cost depends on usage: $0.03 per 10k requests   
 ├─ ECC GenerateDataKeyPair requests                                                Monthly cost depends on usage: $0.10 per 10k requests   
 └─ RSA GenerateDataKeyPair requests                                                Monthly cost depends on usage: $0.10 per 10k requests   
                                                                                                                                         
 module.karpenter[0].aws_sqs_queue.this[0]                                                                                               
 └─ Requests                                                                         Monthly cost depends on usage: $0.40 per 1M requests    
                                                                                                                                         
 module.vpc.aws_nat_gateway.this[0]                                                                                                      
 ├─ NAT gateway                                                                                730  hours                          $35.04 
 └─ Data processed                                                                           Monthly cost depends on usage: $0.048 per GB            
                                                                                                                                         
 OVERALL TOTAL                                                                                                                    $127.78 
──────────────────────────────────
93 cloud resources were detected:
∙ 10 were estimated, 8 of which include usage-based costs, see https://infracost.io/usage-file
∙ 83 were free, rerun with --show-skipped to see details

┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━┓
┃ Project                                            ┃ Monthly cost ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╋━━━━━━━━━━━━━━┫
┃ sbeliakou/eks-cluster/terraform                    ┃ $128         ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┻━━━━━━━━━━━━━━┛
```

### With NAT Gateway in each AZ

```
...

Infracost estimate: Monthly cost will increase by $70 ↑
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━┓
┃ Project                                            ┃ Cost change ┃ New monthly cost ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╋━━━━━━━━━━━━━╋━━━━━━━━━━━━━━━━━━┫
┃ sbeliakou/eks-cluster/terraform                    ┃ +$70 (+55%) ┃ $198             ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┻━━━━━━━━━━━━━┻━━━━━━━━━━━━━━━━━━┛
```