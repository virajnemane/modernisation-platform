terraform {
  required_version = ">= 1.0.1"
  required_providers {
    aws = {
      version = ">= 4.0.0, < 5.0.0"
      source  = "hashicorp/aws"
    }
    pagerduty = {
      source = "pagerduty/pagerduty"
    }
  }
}
