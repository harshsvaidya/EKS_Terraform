provider "aws" {
  region = "ap-south-1"
}

# IAM Role that will be assumed temporarily
resource "aws_iam_role" "lab_role" {
  name = "terraform-lab-s3-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::695090996331:user/Harsh"
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

# Attach S3 policy to the role
resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.lab_role.name
  policy_arn = aws_iam_policy.s3_lab_policy.arn
}

# Policy allowing user Harsh to assume the role
resource "aws_iam_policy" "assume_role_policy" {
  name = "allow-harsh-assume-role"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Resource = aws_iam_role.lab_role.arn
      }
    ]
  })
}

# Attach assume-role permission to user Harsh
resource "aws_iam_user_policy_attachment" "attach_to_harsh" {
  user       = "Harsh"
  policy_arn = aws_iam_policy.assume_role_policy.arn
}