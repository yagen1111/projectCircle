terraform {
  source = "git::git@github.com:yagen1111/infrastructure-modules.git//prod/vpc?ref=main"
}
include "root"{
  path = find_in_parent_folders()
}

include "env" {
  path = find_in_parent_folders("env.hcl")
  expose = true
  #Dont combine configurations - replace completely instead of merging
  merge_strategy = "no_merge"
}

inputs = {
    env = include.env.locals.env
    vpc_cidr_block = "10.100.0.0/16"
    azs = ["us-east-1a", "us-east-1b"]
    public_subnets = ["10.100.0.0/19", "10.100.32.0/19"]
    private_subnets = ["10.100.64.0/19", "10.100.96.0/19"]

    private_subnets_tags = {
        "kubernetes.io/role/internal-elb" = "1"
        "kubernetes.io/cluster/prod-eks" = "1"
    }

    public_subnets_tags = {
      "kubernetes.io/role/elb" = "1"
      "kubernetes.io/cluster/prod-eks" = "1"
    }
}

