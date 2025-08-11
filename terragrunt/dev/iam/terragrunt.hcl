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
<<<<<<< HEAD
=======

# Output the user ARN for use in other configurations
outputs = {
  user_arn = {
    description = "ARN of the IAM user"
    value       = module.iam_user.iam_user_arn
  }
}
>>>>>>> 95a8bc319c2315d8885f813c226b2a5dccb77e37
