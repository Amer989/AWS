terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
    }
  }
  required_version = ">= 1.0.0"
}

provider "aws" {
  region = "us-east-1"  # Change to your preferred region
}

# Create a Service Control Policy (SCP) for restricting AWS regions
resource "aws_organizations_policy" "restrict_regions" {
  name        = "restrict-aws-regions"
  description = "Restricts AWS service usage to specified regions only"
  content     = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyAllOutsideAllowedRegions",
      "Effect": "Deny",
      "NotAction": [
        "a4b:*",
        "acm:*",
        "aws-portal:*",
        "budgets:*",
        "ce:*",
        "chime:*",
        "cloudfront:*",
        "config:*",
        "cur:*",
        "directconnect:*",
        "ec2:DescribeRegions",
        "ec2:DescribeTransitGateways",
        "ec2:DescribeVpnGateways",
        "fms:*",
        "globalaccelerator:*",
        "health:*",
        "iam:*",
        "importexport:*",
        "kms:*",
        "mobileanalytics:*",
        "networkmanager:*",
        "organizations:*",
        "pricing:*",
        "route53:*",
        "route53domains:*",
        "s3:GetAccountPublicAccessBlock",
        "s3:ListAllMyBuckets",
        "s3:PutAccountPublicAccessBlock",
        "shield:*",
        "sts:*",
        "support:*",
        "trustedadvisor:*",
        "waf-regional:*",
        "waf:*",
        "wafv2:*",
        "wellarchitected:*"
      ],
      "Resource": "*",
      "Condition": {
        "StringNotEquals": {
          "aws:RequestedRegion": [
            "us-east-1",
            "us-east-2",
            "us-west-2",
            "eu-west-1"
          ]
        }
      }
    }
  ]
}
POLICY
}

# Attach the SCP to an AWS Organization or Organizational Unit
resource "aws_organizations_policy_attachment" "region_attach_to_org" {
  policy_id = aws_organizations_policy.restrict_regions.id
  target_id = "r-exampleroot"  # Replace with your organization's root ID
}
