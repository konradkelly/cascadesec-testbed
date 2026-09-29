# Encryption key for the reporting service's exports.
# Owned by the reporting team.
resource "aws_kms_key" "reports" {
  description             = "Reporting service exports"
  deletion_window_in_days = 30
}

resource "aws_kms_alias" "reports" {
  name          = "alias/reports"
  target_key_id = aws_kms_key.reports.key_id
}
