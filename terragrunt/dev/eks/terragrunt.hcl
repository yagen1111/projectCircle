terraform {
  source = "tfr:///terraform-aws-modules/eks/aws//.?version=21.0.8"
}

include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path           = find_in_parent_folders("env.hcl")
  expose         = true
}

inputs = {
<<<<<<< HEAD
  name                                  = include.env.locals.eks_cluster_name
  cluster_version                       = include.env.locals.eks_cluster_version
=======
  cluster_version                       = include.env.locals.eks_cluster_version
  cluster_name                          = include.env.locals.eks_cluster_name
  
>>>>>>> 95a8bc319c2315d8885f813c226b2a5dccb77e37
  vpc_id                                = dependency.vpc.outputs.vpc_id
  subnet_ids                            = dependency.vpc.outputs.private_subnets
  
  create_aws_auth_configmap             = include.env.locals.eks_create_aws_auth_configmap
  manage_aws_auth_configmap             = include.env.locals.eks_manage_aws_auth_configmap
  
  aws_auth_users = [
    {
      userarn  = dependency.iam.outputs.user_arn
      username = "eks-admin-${include.env.locals.env}"
      groups   = ["system:masters"]
    }
  ]
}

dependency "vpc" {
  config_path = "${get_original_terragrunt_dir()}/../vpc"
  mock_outputs = {
    vpc_id = "vpc-00000000"
    private_subnets = [
      "subnet-00000000",
      "subnet-00000001",
      "subnet-00000002",
    ]
  }
}

dependency "iam" {
  config_path = "${get_original_terragrunt_dir()}/../iam"
  mock_outputs = {
    user_arn = "arn:aws:iam::123456789012:user/eks-admin-dev"
  }
}

<<<<<<< HEAD


=======
generate "provider-local" {
  path      = "provider-local.tf"
  if_exists = "overwrite"
  contents  = file("../../../provider-config/eks/eks.tf")
}

tags = {
  Name            = "${local.env}-${local.project}"
  Environment     = "${local.env}"
  ManagedBy       = "terragrunt"
  Project         = local.project
}
>>>>>>> 95a8bc319c2315d8885f813c226b2a5dccb77e37
