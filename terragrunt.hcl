remote_state {
  backend = "s3"

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = "my-terraform-state-bucket-yagen"
    key    = "${path_relative_to_include()}/terraform.tfstate"
<<<<<<< HEAD
    region = "${local.aws_region}"
=======
    region = "us-east-1"
>>>>>>> 95a8bc319c2315d8885f813c226b2a5dccb77e37
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
<<<<<<< HEAD
=======
inputs = {
  project_name = "devops-infra"
  environment  = "dev"
  aws_region   = "us-east-1"
}
>>>>>>> 95a8bc319c2315d8885f813c226b2a5dccb77e37

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
<<<<<<< HEAD
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

=======
  region  = "us-east-1"
}
EOF
}
>>>>>>> 95a8bc319c2315d8885f813c226b2a5dccb77e37
