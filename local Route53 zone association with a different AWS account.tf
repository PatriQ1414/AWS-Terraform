#This is assuming the second/mamangement asccount has been set up
#Following script is run on the account hosting the Local Route53 zone

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region     = "eu-west-1"
  access_key = var.accesskey
  secret_key = var.secretkey
}

provider "aws" {
  alias      = "alternate"
  access_key = var.second_aws_account_accesskey  #Access key for second AWS account with appropriate privileges
  secret_key = var.second_aws_account_secretkey  #Secret key for second AWS account with appropriate privileges

}


resource "aws_vpc" "main" {
  cidr_block           = local.main_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    {
      Name = format("%s-%s-%s-%s", local.name, local.product, local.environment, local.vpc)
    },
    local.tags
  )
}

resource "aws_route53_zone" "private" {
  name = local.private_domain

  vpc {
    vpc_id = aws_vpc.main.id
  }

  lifecycle {
    ignore_changes = [vpc]
  }
}

resource "aws_route53_vpc_association_authorization" "private" {
  vpc_id  = var.second_account_vpc_id
  zone_id = aws_route53_zone.private.id
}

resource "aws_route53_zone_association" "private" {
  provider = aws.alternate

  vpc_id  = aws_route53_vpc_association_authorization.private.vpc_id
  zone_id = aws_route53_vpc_association_authorization.private.zone_id
}
