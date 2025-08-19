terraform {
  source = "git@github.com:yagen1111/infrastructure-modules.git//dev/argocd?ref=main"
}

include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path = find_in_parent_folders("env.hcl")
  expose = true
}

inputs = {
  env = include.env.locals.env
  eks_name = dependency.eks.outputs.eks_name
}

dependency "eks" {
  config_path = "../eks"
  mock_outputs = {
    eks_name = "dev-eks"
  }
}

generate "k8s_helm_providers" {
  path = "k8s_helm_providers.tf"
  if_exists = "overwrite"
  contents = <<EOF
data "aws_eks_cluster" "eks" {
  name = var.eks_name
}

data "aws_eks_cluster_auth" "eks" {
  name = var.eks_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}
EOF
}