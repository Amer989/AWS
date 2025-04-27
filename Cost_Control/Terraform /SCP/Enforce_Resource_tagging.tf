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

# Create a Service Control Policy (SCP) for enforcing resource tagging
resource "aws_organizations_policy" "enforce_tagging" {
  name        = "enforce-resource-tagging"
  description = "Prevents resources from being created without required tags"
  content     = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "EnforceTaggingOnResourceCreation",
      "Effect": "Deny",
      "Action": [
        "ec2:RunInstances",
        "ec2:CreateVolume",
        "ec2:CreateSnapshot",
        "rds:CreateDBInstance",
        "rds:CreateDBCluster",
        "s3:CreateBucket",
        "dynamodb:CreateTable",
        "lambda:CreateFunction",
        "eks:CreateCluster",
        "elasticloadbalancing:CreateLoadBalancer",
        "elasticloadbalancing:CreateLoadBalancerListeners",
        "cloudformation:CreateStack",
        "autoscaling:CreateAutoScalingGroup",
        "ecs:CreateCluster",
        "elasticache:CreateCacheCluster",
        "es:CreateElasticsearchDomain",
        "ec2:CreateVpc",
        "ec2:CreateSubnet",
        "ec2:CreateSecurityGroup",
        "emr:CreateCluster"
      ],
      "Resource": "*",
      "Condition": {
        "Null": {
          "aws:RequestTag/Environment": "true",
          "aws:RequestTag/Owner": "true",
          "aws:RequestTag/Project": "true",
          "aws:RequestTag/CostCenter": "true"
        }
      }
    },
    {
      "Sid": "EnforceTaggingOnResourceTagging",
      "Effect": "Deny",
      "Action": [
        "ec2:CreateTags"
      ],
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "ec2:CreateAction": [
            "RunInstances",
            "CreateVolume",
            "CreateSnapshot"
          ]
        },
        "Null": {
          "aws:RequestTag/Environment": "true",
          "aws:RequestTag/Owner": "true",
          "aws:RequestTag/Project": "true",
          "aws:RequestTag/CostCenter": "true"
        }
      }
    }
  ]
}
POLICY
}

# Attach the SCP to an AWS Organization or Organizational Unit
# Uncomment and modify the below resource as needed

# To attach to the entire organization:
resource "aws_organizations_policy_attachment" "tagging_attach_to_org" {
  policy_id = aws_organizations_policy.enforce_tagging.id
  target_id = "r-exampleroot"  # Replace with your organization's root ID
}
