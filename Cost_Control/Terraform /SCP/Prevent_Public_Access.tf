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

# Create a Service Control Policy (SCP) for preventing public access to resources
resource "aws_organizations_policy" "prevent_public_access" {
  name        = "prevent-public-access"
  description = "Prevents public access to various AWS resources"
  content     = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyPublicS3BucketACL",
      "Effect": "Deny",
      "Action": [
        "s3:PutBucketAcl"
      ],
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": [
            "public-read",
            "public-read-write",
            "authenticated-read"
          ]
        }
      }
    },
    {
      "Sid": "DenyPublicS3ObjectACL",
      "Effect": "Deny",
      "Action": [
        "s3:PutObjectAcl"
      ],
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": [
            "public-read",
            "public-read-write",
            "authenticated-read"
          ]
        }
      }
    },
    {
      "Sid": "DenyPublicS3BucketPolicy",
      "Effect": "Deny",
      "Action": [
        "s3:PutBucketPolicy"
      ],
      "Resource": "*",
      "Condition": {
        "StringLike": {
          "s3:PutBucketPolicy:Resource": [
            "*"
          ]
        },
        "ForAnyValue:StringLike": {
          "aws:PrincipalArn": [
            "arn:aws:iam::*:anonymous",
            "arn:aws:iam::*:user/*",
            "arn:aws:iam::*:role/*"
          ]
        }
      }
    },
    {
      "Sid": "DenyPublicSecurityGroups",
      "Effect": "Deny",
      "Action": [
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:ModifySecurityGroupRules",
        "ec2:ReplaceNetworkAclEntry"
      ],
      "Resource": "*",
      "Condition": {
        "ForAnyValue:IpAddress": {
          "aws:SourceIp": [
            "0.0.0.0/0",
            "::/0"
          ]
        }
      }
    },
    {
      "Sid": "DenyPublicRDSInstances",
      "Effect": "Deny",
      "Action": [
        "rds:CreateDBInstance",
        "rds:ModifyDBInstance"
      ],
      "Resource": "*",
      "Condition": {
        "Bool": {
          "rds:PubliclyAccessible": "true"
        }
      }
    },
    {
      "Sid": "DenyPublicECRRepositories",
      "Effect": "Deny",
      "Action": [
        "ecr:SetRepositoryPolicy"
      ],
      "Resource": "*",
      "Condition": {
        "StringLike": {
          "ecr:SetRepositoryPolicy:Resource": [
            "*"
          ]
        },
        "ForAnyValue:StringLike": {
          "aws:PrincipalArn": [
            "arn:aws:iam::*:anonymous"
          ]
        }
      }
    }
  ]
}
POLICY
}

# Attach the SCP to an AWS Organization or Organizational Unit
resource "aws_organizations_policy_attachment" "public_access_attach_to_org" {
  policy_id = aws_organizations_policy.prevent_public_access.id
  target_id = "r-exampleroot"  # Replace with your organization's root ID
}
