remote_state {
    backend = "s3"
    generate = {
        path = "state.tf"
        if_exists = "overwrite"
    }
    config = {
        bucket         = "my-terraform-state-bucket-yagen"
        key            = "${path_relative_to_include()}/terraform.tfstate"
        region        = "us-east-1"
        encrypt       = true
        dynamodb_table = "terraform-lock-table"
    }
}
generate "provider" {
    path = "provider.tf"
    if_exists = "overwrite"

    contents = <<EOF
provider "aws" {
    region = "us-east-1"

}
EOF
}