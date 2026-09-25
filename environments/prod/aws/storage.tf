data "aws_caller_identity" "current" {}

resource "aws_kms_key" "data" {
  description             = "Encrypts production data at rest"
  enable_key_rotation     = true
  deletion_window_in_days = 30

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "AccountAdministration"
      Effect    = "Allow"
      Principal = { AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root" }
      Action    = "kms:*"
      Resource  = "*"
    }]
  })
}

resource "aws_s3_bucket" "payments_data" {
  bucket = "example-corp-prod-payments-data"
}

resource "aws_s3_bucket_versioning" "payments_data" {
  bucket = aws_s3_bucket.payments_data.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "payments_data" {
  bucket = aws_s3_bucket.payments_data.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.data.arn
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "payments_data" {
  bucket                  = aws_s3_bucket.payments_data.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_logging" "payments_data" {
  bucket        = aws_s3_bucket.payments_data.id
  target_bucket = aws_s3_bucket.audit_logs.id
  target_prefix = "s3/payments-data/"
}
