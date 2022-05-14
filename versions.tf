terraform {
  required_version = "1.1.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.13"
    }

    null = {
      source  = "hashicorp/null"
      version = "3.1.1"
    }
  }
}