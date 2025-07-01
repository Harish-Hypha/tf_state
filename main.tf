provider "aws" {
  region  = "ap-south-1"
  profile = "hypha"
}

resource "aws_s3_bucket" "tf-state-s3" {
  bucket = "hypha-tf-state-101"
  region = "ap-south-1"
  tags = {
    Name = "tf state mgmt"
    Env  = "Dev"
  }
}


resource "aws_s3_bucket_versioning" "tf-state-s3-versioning" {
  bucket = aws_s3_bucket.tf-state-s3.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "tfstate_lock" {
  name         = "terraform-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    Name = "Terraform Lock"
    Env  = "Dev"
  }
}
terraform {
  backend "s3" {
    bucket         = "hypha-tf-state-101"
    key            = "dev/terraform.tfstate"
    region         = "ap-south-1"
    use_lockfile = false
    dynamodb_table = "terraform-state-lock"

  }
}