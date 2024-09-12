terraform {
  backend "s3" {
    bucket = "dive-bucket"
    key    = "terraform/backend_ex6"
    region = "us-west-2"
  }
}