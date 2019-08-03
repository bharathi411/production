terraform {
  backend "s3" {
    bucket  = "chqbok-devops"
    key     = "chqbook-infra/prod/base-infra"
    region  = "ap-south-1"
  }
}
