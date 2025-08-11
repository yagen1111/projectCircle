terraform {
  source = "tfr:///terraform-aws-modules/vpc/aws//.?version=5.1.1"
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
  name                                 = "${include.env.locals.env}-${include.env.locals.project}-vpc"
  cidr                                 = include.env.locals.vpc_cidr
  azs                                  = include.env.locals.availability_zone
  private_subnets                      = [for k, v in include.env.locals.availability_zone : cidrsubnet(include.env.locals.vpc_cidr, 4, k)]
  public_subnets                       = [for k, v in include.env.locals.availability_zone : cidrsubnet(include.env.locals.vpc_cidr, 8, k + 48)]

  
  enable_nat_gateway                   = include.env.locals.vpc_nat_gateway
  single_nat_gateway                   = include.env.locals.vpc_single_nat_gateway
  tags                                 = include.env.locals.tags
}

include "env" {
  path           = find_in_parent_folders("env.hcl")
  expose         = true
  merge_strategy = "no_merge"
}
