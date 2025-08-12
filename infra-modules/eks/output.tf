output "eks_name" {
  value = aws_eks_cluster.eks.name
}
output "openid_connect_provider_arn" {
  value = aws_iam_openid_connect_provider.connect[0].arn
}