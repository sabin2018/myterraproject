terraform {
  /* Uncomment this block to use Terraform Cloud for this tutorial
  cloud {
    organization = "organization-name"
    workspaces {
      name = "learn-terraform-checks"
    }
  }
  */
  #  backend "local" {
  #    path = "terraform.tfstate"
  #  }
  backend "s3" {
    bucket         = "test-tfstate-s3bucket"
    key            = "key/.terraform/terraform.tfstate.d"
    region         = "us-east-1"
    encrypt        = true
}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.4.0"
    }
  }

  required_version = ">= 1.6"
}