terraform {
  required_version = ">= 1.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "example-corp-terraform-state"
    key            = "prod/aws/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "example-corp-terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Environment = "prod"
      ManagedBy   = "terraform"
      Owner       = "platform-team"
    }
  }
}
