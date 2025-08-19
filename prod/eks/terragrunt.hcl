terraform {
    source = "git::git@github.com:yagen1111/infrastructure-modules.git//prod/eks?ref=main"
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
    eks_version = "1.32"
    subnet_ids = dependency.vpc.outputs.private_subnets
    eks_name = "eks"
    enable_ebs_csi_driver = true
    ebs_csi_driver_policy_attachment = true

    node_group = {
        general = {
            capacity_type = "ON_DEMAND"
            instance_types = ["t3.large"]
            scaling_config = {
                desired_size = 2
                max_size = 10
                min_size = 1
            }
        }
}
}
dependency "vpc" {
    config_path = "../vpc"
    # this is good for run terragrunt plan on all modules simultaneously
    mock_outputs = {
        private_subnets = ["subnet-1234", "subnet-5678"]
    }
}
