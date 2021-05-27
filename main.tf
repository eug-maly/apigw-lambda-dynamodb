provider "aws" {
  region  = var.region
  profile = var.profile

  default_tags {
    tags = {
      name         = "CreatedByTF"
      ResourceName = "emaly-test"
      Owner        = "emaly"
    }
  }
}

terraform {
  backend "s3" {}
}
