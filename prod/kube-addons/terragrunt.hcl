terraform {
  source = "git@github.com:yagen1111/infrastructure-modules.git//kube-addon?ref=addons-v0.1"
}

include "root" {
  path = find_in_parent_folders()
}
include "env"{
    path = find_in_parent_folders("env.hcl")
    expose = true
}

inputs = {
  env = include.env.locals.env
  cluster_autoscaler_helm_version = "9.28.0"
  eks_name = dependency.eks.outputs.eks_name
  openid_provider_arn = dependency.eks.outputs.openid_connect_provider_arn
  enable_cluster_autoscaler      = true
  enable_ebs_csi_driver = true
  ebs_csi_driver_helm_version = "2.35.1"
}

dependency "eks" {
    config_path = "../eks"
    # This allows you to plan all modules simultaneously without errors
    mock_outputs = {
        eks_name = "prod-eks"
        openid_connect_provider_arn = "arn:aws:iam::123456789012:oidc-provider"
    }
}

generate "helm_provider" {
  path = "helm_provider.tf"
  if_exists = "overwrite"
  contents = <<EOF
data "aws_eks_cluster" "eks" {
  name = var.eks_name
}
data "aws_eks_cluster_auth" "eks" {
  name = var.eks_name
}

provider "helm" {
  kubernetes = {
    host                   = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}
EOF
}

