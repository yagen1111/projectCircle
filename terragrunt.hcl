remote_state {
  backend = "s3"

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = "my-terraform-state-bucket-yagen"
    key    = "${path_relative_to_include()}/terraform.tfstate"
    region = "${local.aws_region}"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
inputs = {
  project_name = "devops-infra"
  environment  = "dev"
  aws_region   = "us-east-1"
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  region = "${local.aws_region}"
  
  default_tags {
    tags = {
      Project     = "${local.project_name}"
      Environment = "${local.environment}"
    }
  }
}
EOF
}

locals {
  aws_region   = "us-east-1"
  project_name = "devops-infra" 
  environment  = "dev"
}
