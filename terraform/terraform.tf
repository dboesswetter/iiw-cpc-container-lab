terraform {
  required_providers {
    aws = {
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
#  profile = "learnerlab"
}
