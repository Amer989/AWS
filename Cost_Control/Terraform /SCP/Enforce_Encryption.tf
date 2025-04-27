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

# Create a Service Control Policy (SCP) for enforcing encryption
resource "aws_organizations_policy" "enforce_encryption" {
  name        = "enforce-encryption"
  description = "Enforces encryption for various AWS services"
  content     = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyUnencryptedEBSVolume",
      "Effect": "Deny",
      "Action": "ec2:CreateVolume",
      "Resource": "*",
      "Condition": {
        "Bool": {
          "ec2:Encrypted": "false"
        }
      }
    },
    {
      "Sid": "DenyUnencryptedEBSSnapshot",
      "Effect": "Deny",
      "Action": "ec2:CreateSnapshot",
      "Resource": "*",
      "Condition": {
        "Bool": {
          "ec2:Encrypted": "false"
        }
      }
    },
    {
      "Sid": "DenyUnencryptedRDSInstance",
      "Effect": "Deny",
      "Action": [
        "rds:CreateDBInstance",
        "rds:CreateDBCluster"
      ],
      "Resource": "*",
      "Condition": {
        "Bool": {
          "rds:StorageEncrypted": "false"
        }
      }
    },
    {
      "Sid": "DenyS3BucketWithoutSSE",
      "Effect": "Deny",
      "Action": "s3:CreateBucket",
      "Resource": "*",
      "Condition": {
        "Null": {
          "s3:x-amz-server-side-encryption": "true"
        }
      }
    },
    {
      "Sid": "DenyS3ObjectWithoutSSE",
      "Effect": "Deny",
      "Action": "s3:PutObject",
      "Resource": "*",
      "Condition": {
        "Null": {
          "s3:x-amz-server-side-encryption": "true"
        }
      }
    },
    {
      "Sid": "DenyLambdaWithoutKMSKey",
      "Effect": "Deny",
      "Action": "lambda:CreateFunction",
      "Resource": "*",
      "Condition": {
        "Null": {
          "lambda:KMSKeyArn": "true"
        }
      }
    }
  ]
}
POLICY
}

# Attach the SCP to an AWS Organization or Organizational Unit
resource "aws_organizations_policy_attachment" "encryption_attach_to_org" {
  policy_id = aws_organizations_policy.enforce_encryption.id
  target_id = "r-exampleroot"  # Replace with your organization's root ID
}
