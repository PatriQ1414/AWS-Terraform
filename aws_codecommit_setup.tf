terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket"
    key            = "global/s3/terraform.tfstate"
    region         = var.region
    dynamodb_table = "terraform-state-locking"
    encrypt        = true

  }

}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-state-locking"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
} 

resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-state-bucket"

  lifecycle {
    prevent_destroy = true
  }


  tags = { 
  Name = "Terrafrom state bucket"

}

###############################
# Optional
##############################
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.bucket

  rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
    mfa_delete = "Disabled"
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

