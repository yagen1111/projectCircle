terraform {
required_version = ">= 1.0"
required_providers {
aws = {
    source  = "hashicorp/aws"
    version = ">= 5.0"
}
kubernetes = {
    source  = "hashicorp/kubernetes"
    version = ">= 2.20"
}
time = {
    source  = "hashicorp/time"
    version = ">= 0.9"
}
}
}

provider "aws" {
region = var.aws_region
}

provider "kubernetes" {
host                   = module.eks.cluster_endpoint
cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

exec {
api_version = "client.authentication.k8s.io/v1beta1"
command     = "aws"
args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
}
}

# ============================================
# CORE INFRASTRUCTURE
# ============================================

# VPC and Networking
module "infra" {
source = "./modules/infra"

region               = var.aws_region
vpc_cidr             = var.vpc_cidr
azs                  = var.availability_zones
public_subnet_cidrs  = var.public_subnet_cidrs
private_subnet_cidrs = var.private_subnet_cidrs
project_name         = var.project_name
environment          = var.environment
common_tags          = var.common_tags
}

# IAM Roles and Policies
module "iam" {
source = "./modules/iam"

project_name     = var.project_name
environment      = var.environment
eks_cluster_name = var.eks_cluster_name
common_tags      = var.common_tags
}

# EKS Cluster
module "eks" {
source = "./modules/eks"

cluster_name     = var.eks_cluster_name
cluster_role_arn = module.iam.eks_cluster_role_arn
node_role_arn    = module.iam.eks_node_role_arn
vpc_id           = module.infra.vpc_id
subnet_ids       = module.infra.private_subnet_ids
ec2_ssh_key      = var.ssh_key_name
desired_size     = var.node_desired_capacity
max_size         = var.node_max_capacity
min_size         = var.node_min_capacity
instance_types   = [var.node_instance_type]
project_name     = var.project_name
environment      = var.environment
common_tags      = var.common_tags
}

# Security Groups
module "security_groups" {
source = "./modules/sg"

vpc_id               = module.infra.vpc_id
project_name         = var.project_name
environment          = var.environment
common_tags          = var.common_tags
allowed_http_cidrs   = var.allowed_http_cidrs
allowed_https_cidrs  = var.allowed_https_cidrs
allowed_ssh_cidrs    = var.allowed_ssh_cidrs
weather_app_nodeport = var.weather_app_nodeport
}

# Application Load Balancer
module "alb" {
source = "./modules/alb"

name               = var.alb_name
vpc_id             = module.infra.vpc_id
public_subnet_ids  = module.infra.public_subnet_ids
security_group_ids = [module.security_groups.alb_sg_id]
domain_name        = var.domain_name
project_name       = var.project_name
environment        = var.environment
common_tags        = var.common_tags
}

# DNS Management
module "dns" {
source = "./modules/dns"

domain_name             = var.domain_name
alb_dns_name            = module.alb.lb_dns_name
alb_zone_id             = module.alb.lb_zone_id
auto_update_nameservers = var.auto_update_nameservers
environment             = var.environment
common_tags             = var.common_tags
}
