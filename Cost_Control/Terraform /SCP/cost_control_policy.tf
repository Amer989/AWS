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

# Create a Service Control Policy (SCP) for cost control
resource "aws_organizations_policy" "cost_control" {
  name        = "cost-control-policy"
  description = "Restricts usage of expensive services and resources"
  content     = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyExpensiveEC2InstanceTypes",
      "Effect": "Deny",
      "Action": [
        "ec2:RunInstances"
      ],
      "Resource": "arn:aws:ec2:*:*:instance/*",
      "Condition": {
        "ForAnyValue:StringLike": {
          "ec2:InstanceType": [
            "p3.*",
            "p4.*",
            "x1.*",
            "x2.*",
            "g4.*",
            "g5.*",
            "inf1.*",
            "dl1.*",
            "z1d.*",
            "f1.*",
            "h1.*"
          ]
        }
      }
    },
    {
      "Sid": "DenyExpensiveRDSInstanceTypes",
      "Effect": "Deny",
      "Action": [
        "rds:CreateDBInstance"
      ],
      "Resource": "*",
      "Condition": {
        "ForAnyValue:StringLike": {
          "rds:DatabaseClass": [
            "db.r5.12xlarge",
            "db.r5.24xlarge",
            "db.r5b.12xlarge",
            "db.r5b.24xlarge",
            "db.r6g.12xlarge",
            "db.r6g.16xlarge",
            "db.x1.*",
            "db.x2.*",
            "db.z1d.12xlarge"
          ]
        }
      }
    },
    {
      "Sid": "DenyExpensiveServices",
      "Effect": "Deny",
      "Action": [
        "sagemaker:Create*",
        "mlflow:Create*",
        "bedrock:*",
        "eks:CreateCluster",
        "ecr-public:*",
        "redshift:*",
        "mwaa:*",
        "comprehend:*"
      ],
      "Resource": "*"
    },
    {
      "Sid": "DenyExpensiveEBSVolumeTypes",
      "Effect": "Deny",
      "Action": [
        "ec2:CreateVolume"
      ],
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "ec2:VolumeType": "io2"
        },
        "NumericGreaterThan": {
          "ec2:VolumeSize": "1000"
        }
      }
    },
    {
      "Sid": "LimitEBSVolumeSize",
      "Effect": "Deny",
      "Action": [
        "ec2:CreateVolume"
      ],
      "Resource": "*",
      "Condition": {
        "NumericGreaterThan": {
          "ec2:VolumeSize": "5000"
        }
      }
    },
    {
      "Sid": "DenyUnlimitedElasticIPAllocation",
      "Effect": "Deny",
      "Action": [
        "ec2:AllocateAddress"
      ],
      "Resource": "*",
      "Condition": {
        "NumericGreaterThan": {
          "ec2:ElasticIpCount": "5"
        }
      }
    }
  ]
}
POLICY
}

# Attach the SCP to an AWS Organization or Organizational Unit
resource "aws_organizations_policy_attachment" "cost_control_attach_to_org" {
  policy_id = aws_organizations_policy.cost_control.id
  target_id = "r-exampleroot"  # Replace with your organization's root ID
}
