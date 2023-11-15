resource "aws_ecr_repository" "repository" {
  for_each = toset(var.aws_ecr_docker_registry)
  name     = each.key
  tags     = var.tags
}

resource "aws_iam_policy" "ecr_access" {
  for_each = toset(var.aws_ecr_docker_registry)
  name  = format("%s-ecr-access-policy-%s", local.eks_cluster_name, each.key)

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart",
        ]
        Effect   = "Allow"
        Resource = aws_ecr_repository.repository[each.key].arn
      },
      {
        Effect   = "Allow",
        Action   = "ecr:GetAuthorizationToken",
        Resource = "*"
      },
    ]
  })
}