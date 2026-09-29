# Encryption key for the reporting service's exports.
resource "aws_kms_key" "reports" {
  description             = "Reporting service exports"
  deletion_window_in_days = 30
}
