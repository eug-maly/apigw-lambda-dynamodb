variable "stage_name" {
  description = "The stage name(production/staging/etc..)"
  default     = "production"
}

variable "region" {
  description = "The AWS region, e.g., eu-west-1"
}

variable "profile" {
  description = "The AWS profile name"
}

variable "prefix" {
  description = "Preix to be used in resources name"
  default     = "apigw"
}

variable "lambda_package" {
  description = "The package file name"
  default     = "scripts/lambda.zip"
}

variable "lambda_handler" {
  description = "The handler name of the lambda function"
}
