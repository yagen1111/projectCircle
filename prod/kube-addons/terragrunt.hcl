terraform {
  source = "git::git@github.com:yagen1111/infrastructure-modules.git//prod/kube-addon?ref=main"
}

include "root" {
  path = find_in_parent_folders()
}
include "env"{
    path = find_in_parent_folders("env.hcl")
    expose = true
}

dependency "eks" {
    config_path = "../eks"
    mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
    mock_outputs = {
        eks_name = "prod-eks"
        openid_connect_provider_arn = "arn:aws:iam::123456789012:oidc-provider"
    }   
}
dependency "vpc" {
  config_path = "../vpc"
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
  mock_outputs = {
    vpc_id = "vpc-12345"
  }
}

inputs = {
  env = include.env.locals.env
  region = include.env.locals.region 
  cluster_autoscaler_helm_version = "9.28.0"
  eks_name = dependency.eks.outputs.eks_name
  vpc_id = dependency.vpc.outputs.vpc_id
  openid_provider_arn = dependency.eks.outputs.openid_connect_provider_arn
  enable_cluster_autoscaler      = true
  enable_ebs_csi_driver = true
  ebs_csi_driver_helm_version = "2.35.1"
  enable_aws_load_balancer_controller = true
  enable_ingress_nginx = true
  ssl_certificate_arn = "arn:aws:acm:us-east-1:559050211440:certificate/3ed66a3d-b1de-478e-8d29-da9562384a71"
  enable_external_secrets = true
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

