locals {
  env     = "dev"
  project = "project_circle"

  # EKS vars
  eks_cluster_name                    = "${local.env}-${local.project}-cluster"
  eks_cluster_version                 = "1.29"
  eks_create_aws_auth_configmap       = false
  eks_manage_aws_auth_configmap       = true
  
  # VPC variables
  vpc_cidr                             = "192.168.0.0/16"
  vpc_nat_gateway                      = true
  vpc_single_nat_gateway               = true
  availability_zone                    = ["us-east-1a", "us-east-1b"]
  tags = {
    Name            = "${local.env}-${local.project}"
    Environment     = "${local.env}"
  }
}
