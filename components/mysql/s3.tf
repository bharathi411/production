terraform {
  backend "s3" {
    bucket  = "chqbok-devops"
    key     = "chqbook-infra/prod/mysql"
    region  = "ap-south-1"
  }
}

data "terraform_remote_state" "core_prod_vpc" {
  backend = "s3"

  config {
    bucket  = "chqbok-devops"
    key     = "chqbook-infra/prod/base-infra"
    region  = "ap-south-1"
  }
}

data "terraform_remote_state" "frontend" {
  backend = "s3"

  config {
    bucket = "chqbok-devops"
    key    = "chqbook-infra/prod/frontend"
    region = "ap-south-1"
  }
}