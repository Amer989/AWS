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

# Create a Service Control Policy (SCP) to prevent deletion of critical resources
resource "aws_organizations_policy" "prevent_resource_deletion" {
  name        = "prevent-critical-resource-deletion"
  description = "Prevents deletion of critical resources without proper approval"
  content     = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyDeletionOfProductionResources",
      "Effect": "Deny",
      "Action": [
        "ec2:TerminateInstances",
        "ec2:DeleteVolume",
        "ec2:DeleteSnapshot",
        "rds:DeleteDBInstance",
        "rds:DeleteDBCluster",
        "rds:DeleteDBSnapshot",
        "rds:DeleteDBClusterSnapshot",
        "dynamodb:DeleteTable",
        "dynamodb:DeleteBackup",
        "s3:DeleteBucket",
        "lambda:DeleteFunction",
        "eks:DeleteCluster",
        "ecs:DeleteCluster",
        "elasticache:DeleteCacheCluster",
        "es:DeleteElasticsearchDomain",
        "redshift:DeleteCluster"
      ],
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "aws:ResourceTag/Environment": "Production"
        },
        "Null": {
          "aws:ResourceTag/AllowDeletion": "true"
        }
      }
    },
    {
      "Sid": "DenyDeletionOfTaggedResources",
      "Effect": "Deny",
      "Action": [
        "ec2:TerminateInstances",
        "ec2:DeleteVolume",
        "ec2:DeleteSnapshot",
        "rds:DeleteDBInstance",
        "rds:DeleteDBCluster",
        "rds:DeleteDBSnapshot",
        "rds:DeleteDBClusterSnapshot",
        "dynamodb:DeleteTable",
        "dynamodb:DeleteBackup",
        "s3:DeleteBucket",
        "lambda:DeleteFunction",
        "eks:DeleteCluster",
        "ecs:DeleteCluster",
        "elasticache:DeleteCacheCluster",
        "es:DeleteElasticsearchDomain",
        "redshift:DeleteCluster"
      ],
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "aws:ResourceTag/DeletionProtection": "true"
        }
      }
    },
    {
      "Sid": "DenyRemovingDeletionProtectionTag",
      "Effect": "Deny",
      "Action": [
        "ec2:DeleteTags",
        "rds:RemoveTagsFromResource",
        "dynamodb:TagResource",
        "s3:PutBucketTagging",
        "lambda:TagResource",
        "lambda:UntagResource",
        "eks:TagResource",
        "eks:UntagResource",
        "ecs:TagResource",
        "ecs:UntagResource",
        "elasticache:RemoveTagsFromResource",
        "es:RemoveTags",
        "redshift:DeleteTags"
      ],
      "Resource": "*",
      "Condition": {
        "ForAnyValue:StringEquals": {
          "aws:TagKeys": [
            "DeletionProtection",
            "Environment"
          ]
        },
        "StringEquals": {
          "aws:ResourceTag/Environment": "Production"
        },
        "Null": {
          "aws:ResourceTag/AllowTagModification": "true"
        }
      }
    },
    {
      "Sid": "DenyVPCDeletion",
      "Effect": "Deny",
      "Action": [
        "ec2:DeleteVpc",
        "ec2:DeleteSubnet",
        "ec2:DeleteInternetGateway",
        "ec2:DeleteRouteTable",
        "ec2:DeleteNatGateway",
        "ec2:DeleteTransitGateway"
      ],
      "Resource": "*",
      "Condition": {
        "Null": {
          "aws:ResourceTag/AllowDeletion": "true"
        }
      }
    },
    {
      "Sid": "DenySecurityControlsDeletion",
      "Effect": "Deny",
      "Action": [
        "guardduty:DeleteDetector",
        "guardduty:DisassociateFromMasterAccount",
        "securityhub:DisableSecurityHub",
        "securityhub:DisassociateFromMasterAccount",
        "macie2:DisableMacie",
        "access-analyzer:DeleteAnalyzer",
        "inspector2:DisableInspector"
      ],
      "Resource": "*",
      "Condition": {
        "Null": {
          "aws:RequestTag/SecurityApproval": "true"
        }
      }
    }
  ]
}
POLICY
}

# Attach the SCP to an AWS Organization or Organizational Unit
resource "aws_organizations_policy_attachment" "resource_deletion_attach_to_org" {
  policy_id = aws_organizations_policy.prevent_resource_deletion.id
  target_id = "r-exampleroot"  # Replace with your organization's root ID
}
