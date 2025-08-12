remote_state {
    backend = "local"
    generate = {
        path = "backend.tf"
        if_exists = "overwrite"
    }
    config = {
        path = "${get_terragrunt_dir()}/terraform.tfstate"
    }
}
generate "provider" {
    path = "provider.tf"
    if_exists = "overwrite_terragrunt"

    contents = <<EOF
provider "aws" {
    region = "us-east-1"
}

EOF
}