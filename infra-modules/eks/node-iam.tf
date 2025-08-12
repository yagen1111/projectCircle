resource "aws_iam_role" "nodes" {
    name = "${var.env}-${var.eks_name}-eks-node"
# to prevent conflicts with multi environment
    assume_role_policy = jsonencode({
      Statement = [
        { 
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "ec2.amazonaws.com"
          }
          
        }
      ]
      Version = "2012-10-17"
    })
}

resource "aws_iam_role_policy_attachment" "nodes" {
  for_each = var.node_iam_policies
  role       = aws_iam_role.nodes.name
  policy_arn = each.value
}
