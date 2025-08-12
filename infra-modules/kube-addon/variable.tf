variable "env" {
  description = "The environment for the deployment"
  type        = string
}

variable "cluster_autoscaler_helm_version" {
  description = "The Helm chart version for the cluster autoscaler"
  type        = string
}
 
variable "eks_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "enable_cluster_autoscaler" {
  description = "to deploy the cluster autoscaler ?"
  type        = bool
  default     = true
}
variable "openid_provider_arn" {
  description = "The ARN of the OpenID provider"
  type        = string
}