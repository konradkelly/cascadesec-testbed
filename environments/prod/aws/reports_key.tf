# Reports: the ledger's monthly reports are stored under their own key.
# Retained for seven years; see the records policy.

resource "aws_kms_key" "reports" {
  description             = "Encrypts ledger monthly reports"
  deletion_window_in_days = 30
  enable_key_rotation     = true

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
