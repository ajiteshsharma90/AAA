provider "aws" {
  region  = "ap-south-1"
  access_key = "AKIA2Q3P5PTKEKLEC44R"
  secret_key = "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"
}

terraform {
  required_providers {
    aws = {
      version = "~> 4.13.0"
      source = "hashicorp/aws"
    }
  }
  required_version = "~> 1.1.7"
}
