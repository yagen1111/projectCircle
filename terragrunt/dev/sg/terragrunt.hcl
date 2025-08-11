terraform {
  source = "tfr:///terraform-aws-modules/security-group/aws//.?version=5.1.1"
}

include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path           = find_in_parent_folders("env.hcl")
  expose         = true
}

inputs = {
  name = "${include.env.locals.env}-${include.env.locals.project}-sg"
  description = "Security group for EKS cluster"
  
  vpc_id = dependency.vpc.outputs.vpc_id
  
  # Ingress rules for EKS cluster
  ingress_with_cidr_blocks = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "HTTPS API server access"
      cidr_blocks = include.env.locals.vpc_cidr
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "HTTP from VPC"
      cidr_blocks = include.env.locals.vpc_cidr
    },
    {
      from_port   = 22      
      to_port     = 22
      protocol    = "tcp"
      description = "SSH access to nodes"
      cidr_blocks = include.env.locals.vpc_cidr
    }
  ]
  
  # Allow communication between cluster components
  ingress_with_self = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      description = "All TCP traffic within security group"
    },
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "udp"
      description = "All UDP traffic within security group"
    }
  ]
  
  # Egress rules - allow all outbound
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "All outbound traffic"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  
  tags = include.env.locals.tags
}

dependency "vpc" {
  config_path = "${get_original_terragrunt_dir()}/../vpc"
  mock_outputs = {
    vpc_id = "vpc-00000000"
  }
}