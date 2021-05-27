terraform {
  extra_arguments "custom_vars" {
    commands = [
      "apply",
      "plan",
      "import",
      "push",
      "refresh",
      "destroy"
    ]

  }
}

# Configure Terragrunt to automatically store tfstate files in an S3 bucket
remote_state {
  backend = "s3"

  config = {
    encrypt        = true
    bucket         = "tgtf-state"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "terraform-locks"
    profile        = "devops-pr"

    s3_bucket_tags = {
      name         = "Terraform State File"
      ResourceName = "emaly-test"
      Owner        = "emaly"
    }

    dynamodb_table_tags = {
      name         = "Terraform Lock Table"
      ResourceName = "emaly-test"
      Owner        = "emaly"
    }
  }
}

inputs = {
  profile        = "devops-pr"
  region         = "eu-west-2"
  lambda_handler = "lambda.lambda_handler"
}
