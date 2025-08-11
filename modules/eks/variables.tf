variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
}

variable "domain_name" {
  description = "Domain name for applications"
  type        = string
}

variable "auto_update_nameservers" {
  description = "Automatically update domain nameservers"
  type        = bool
}

# ============================================
# NETWORKING CONFIGURATION
# ============================================
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

# ============================================
# SECURITY CONFIGURATION
# ============================================
variable "ssh_key_name" {
  description = "Name of the AWS key pair for EC2 instances"
  type        = string
}

variable "allowed_ssh_cidrs" {
  description = "CIDR blocks allowed for SSH access"
  type        = list(string)
}

variable "allowed_http_cidrs" {
  description = "CIDR blocks allowed for HTTP access"
  type        = list(string)
}

variable "allowed_https_cidrs" {
  description = "CIDR blocks allowed for HTTPS access"
  type        = list(string)
}

# ============================================
# EC2 INSTANCE CONFIGURATION
# ============================================

variable "jenkins_ami" {
  description = "AMI ID for Jenkins EC2 instance"
  type        = string
}

variable "gitlab_ami" {
  description = "AMI ID for GitLab EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type for application EC2 instances"
  type        = string
}

# ============================================
# EKS CONFIGURATION
# ============================================
variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "node_instance_type" {
  description = "EC2 instance type for EKS nodes"
  type        = string
}

variable "node_desired_capacity" {
  description = "Desired number of nodes in the EKS node group"
  type        = number
}

variable "node_min_capacity" {
  description = "Minimum number of nodes in the EKS node group"
  type        = number
}

variable "node_max_capacity" {
  description = "Maximum number of nodes in the EKS node group"
  type        = number
}

# ============================================
# APPLICATION CONFIGURATION
# ============================================
variable "jenkins_port" {
  description = "Port for Jenkins application"
  type        = number
}

variable "gitlab_port" {
  description = "Port for GitLab application"
  type        = number
}

variable "weather_app_nodeport" {
  description = "NodePort for weather application"
  type        = number
}

# ============================================
# LOAD BALANCER CONFIGURATION
# ============================================
variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
}

variable "jenkins_health_check" {
  description = "Health check configuration for Jenkins target group"
  type = object({
    enabled             = bool
    healthy_threshold   = number
    interval            = number
    matcher             = string
    path                = string
    timeout             = number
    unhealthy_threshold = number
  })
}

variable "gitlab_health_check" {
  description = "Health check configuration for GitLab target group"
  type = object({
    enabled             = bool
    healthy_threshold   = number
    interval            = number
    matcher             = string
    path                = string
    timeout             = number
    unhealthy_threshold = number
  })
}

variable "weatherapp_health_check" {
  description = "Health check configuration for weather app target group"
  type = object({
    enabled             = bool
    healthy_threshold   = number
    interval            = number
    matcher             = string
    path                = string
    timeout             = number
    unhealthy_threshold = number
  })
}

# ============================================
# TAGGING STRATEGY
# ============================================
variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
}
