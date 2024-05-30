terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.10.0"
    }
  }
}

provider "aws" {
  region     = var.region
  access_key = var.access-key
  secret_key = var.secret-key
}