// Here you can save the TFstate into a S3 bucket for example to allow use of the model in a different environment and by other people.
// Its allow you to use in a pipeline for example.
// Also you can save the TFstate into a local file

// https://www.terraform.io/language/settings/backends/s3
# terraform {
#   backend "s3" {
#     bucket = "mybucket"
#     key    = "path/to/my/key"
#     region = "us-east-1"
#   }
# }
