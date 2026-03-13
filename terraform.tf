provider "aws" {
  region = "ap-south-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical
# Amazon Linux : 137112412989
}

resource "aws_instance" "app_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  tags = {
    Name = "learn-terraform"
  }
}
# S3 Bucket using Terraform Module
module "s3_bucket" {

  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.0"

  bucket = "harsh-terraform-s3-bucket-001"
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = true
  }

  tags = {
    Name        = "terraform-s3-bucket"
    Environment = "dev"
  }
}
