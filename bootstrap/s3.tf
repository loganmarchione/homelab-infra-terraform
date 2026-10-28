################################################################################
### S3
################################################################################

########################################
### Terraform state bucket
########################################

# Create a bucket for Terraform state
resource "aws_s3_bucket" "terraform_state" {
  bucket = "loganmarchione-terraform-state"

  lifecycle {
    prevent_destroy = true
  }
}

# Disable ACLs (bucket policy and IAM are the only access controls)
resource "aws_s3_bucket_ownership_controls" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# Enable bucket versioning
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Bucket encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Make sure the bucket is not public
resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    id = "30d_move_to_S3_IA_and_1y_delete_old_objects"
    # expire (delete) objects older than 1 year
    noncurrent_version_expiration {
      newer_noncurrent_versions = 10
      noncurrent_days           = 365
    }
    status = "Enabled"
    # transition to STANDARD_ID after 30 days
    noncurrent_version_transition {
      newer_noncurrent_versions = 10
      noncurrent_days           = 30
      storage_class             = "STANDARD_IA"
    }
  }
}

# Deny any request that doesn't use TLS
resource "aws_s3_bucket_policy" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "RestrictToTLSRequestsOnly",
    "Statement" : [
      {
        "Sid" : "RestrictToTLSRequestsOnly",
        "Action" : "s3:*",
        "Effect" : "Deny",
        "Resource" : [
          aws_s3_bucket.terraform_state.arn,
          "${aws_s3_bucket.terraform_state.arn}/*"
        ],
        "Condition" : {
          "Bool" : {
            "aws:SecureTransport": "false"
          }
        },
        "Principal" : "*",
      }
    ]
  })
}
