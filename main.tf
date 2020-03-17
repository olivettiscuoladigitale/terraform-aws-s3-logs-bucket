resource "aws_s3_bucket" "logs" {
  bucket = var.bucket_name
  acl    = "private"

  lifecycle_rule {
    id      = "AllLogs"
    enabled = true

    prefix = "/"

    transition {
      days          = var.standard_ia_transition_days
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = var.glacier_transition_days
      storage_class = "GLACIER"
    }

    expiration {
      days = var.expiration
    }
  }

  policy = var.policy

  tags = var.tags
}

resource "aws_s3_bucket_public_access_block" "default" {
  bucket = aws_s3_bucket.logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
