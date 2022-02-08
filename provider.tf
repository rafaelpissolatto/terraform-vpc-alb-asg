# Specify the provider and access details
provider "aws" {
  region = var.aws_region

  //key     = var.aws_access_key
  //secret  = var.aws_secret_key
  // or
  //profile = var.aws_profile
}
