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

# Create a Service Control Policy (SCP)
resource "aws_organizations_policy" "restrict_large_ec2" {
  name        = "restrict-large-ec2-instances"
  description = "Prevents the creation of large EC2 instances"
  content     = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyLargeEC2Instances",
      "Effect": "Deny",
      "Action": [
        "ec2:RunInstances"
      ],
      "Resource": [
        "arn:aws:ec2:*:*:instance/*"
      ],
      "Condition": {
        "ForAnyValue:StringLike": {
          "ec2:InstanceType": [
            "*.8xlarge",
            "*.9xlarge",
            "*.10xlarge",
            "*.12xlarge",
            "*.16xlarge",
            "*.18xlarge",
            "*.24xlarge",
            "*.32xlarge",
            "*.metal",
            "*.large",
            "*.xlarge",
            "*.2xlarge",
            "*.4xlarge"
          ]
        }
      }
    }
  ]
}
POLICY
}

# To attach to the entire organization:
resource "aws_organizations_policy_attachment" "attach_to_org" {
  policy_id = aws_organizations_policy.restrict_large_ec2.id
  target_id = "r-exampleroot"  # Replace with your organization's root ID
}

