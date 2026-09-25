resource "aws_db_subnet_group" "payments" {
  name       = "prod-payments"
  subnet_ids = [aws_subnet.private_a.id, aws_subnet.private_b.id]
}

resource "aws_db_instance" "payments" {
  identifier     = "prod-payments"
  engine         = "postgres"
  engine_version = "16.4"
  instance_class = "db.r6g.large"

  allocated_storage = 100
  storage_encrypted = true
  kms_key_id        = aws_kms_key.data.arn

  db_name  = "payments"
  username = "payments_admin"
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.payments.name
  vpc_security_group_ids = [aws_security_group.payments_db.id]
  publicly_accessible    = false

  multi_az                            = true
  backup_retention_period             = 14
  deletion_protection                 = true
  auto_minor_version_upgrade          = true
  iam_database_authentication_enabled = true
  performance_insights_enabled        = true
  performance_insights_kms_key_id     = aws_kms_key.data.arn
  copy_tags_to_snapshot               = true
  enabled_cloudwatch_logs_exports     = ["postgresql"]
}
