remote_state {
  backend     = "s3"
  generate    = {
    path      = "state.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    key             = "${path_relative_to_include()}/terraform.tfstate"
    bucket          = "<PROJECT_NAME>-state"
    region          = "<AWS_REGION>"
    encrypt         = true
    dynamodb_table  = "<PROJECT_NAME>-lock-table"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  region  = "<AWS_REGION>"
}
EOF
}