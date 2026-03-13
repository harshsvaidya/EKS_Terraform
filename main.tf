provider "aws" {
  region = "ap-south-1"
}

# IAM Role for temporary lab access
resource "aws_iam_role" "lab_role" {
  name = "terraform-lab-s3-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Policy allowing S3 bucket creation
resource "aws_iam_policy" "s3_lab_policy" {
  name = "terraform-s3-lab-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:CreateBucket",
          "s3:ListAllMyBuckets",
          "s3:PutBucketVersioning",
          "s3:DeleteBucket"
        ]
        Resource = "*"
      }
    ]
  })
}

# Attach policy to role
resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.lab_role.name
  policy_arn = aws_iam_policy.s3_lab_policy.arn
}