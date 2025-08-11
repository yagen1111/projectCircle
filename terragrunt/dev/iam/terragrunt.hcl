terraform {
  source = "tfr:///terraform-aws-modules/iam/aws//modules/iam-user//.?version=5.30.0"
}

include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path           = find_in_parent_folders("env.hcl")
  expose         = true
  merge_strategy = "no_merge"
}

inputs = {
  name = "eks-admin-${include.env.locals.env}"
  
  create_iam_user_login_profile = false
  create_iam_access_key         = true
  
  policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ]
  
  tags = include.env.locals.tags
}
