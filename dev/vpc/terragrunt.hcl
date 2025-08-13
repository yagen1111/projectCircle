terraform {
  source = "git::git@github.com:yagen1111/infrastructure-modules.git//vpc?ref=main"
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
    azs = ["us-east-1a", "us-east-1b"]
    public_subnets = ["192.168.0.0/19", "192.168.32.0/19"]
    private_subnets = ["192.168.64.0/19", "192.168.96.0/19"]

    private_subnets_tags = {
        "kubernetes.io/role/internal" = "1"
        "kubernetes.io/cluster/dev-project_circle" = "1"
    }

    public_subnets_tags = {
      "kubernetes.io/role/elb" = "1"
      "kubernetes.io/cluster/dev-project_circle" = "1"
    }
}

