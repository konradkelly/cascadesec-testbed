# Ledger service: its own key, database and an admin bastion.

resource "aws_kms_key" "ledger" {
  description             = "Encrypts ledger data"
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

resource "aws_db_instance" "ledger" {
  identifier     = "prod-ledger"
  engine         = "postgres"
  engine_version = "16.4"
  instance_class = "db.r6g.large"

  allocated_storage = 50
  storage_encrypted = false

  db_name  = "ledger"
  username = "ledger_admin"
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.payments.name
  vpc_security_group_ids = [aws_security_group.ledger_admin.id]
  publicly_accessible    = true

  backup_retention_period = 7
  deletion_protection     = true
}

resource "aws_security_group" "ledger_admin" {
  name        = "prod-ledger-admin"
  description = "Ledger admin access"
  vpc_id      = aws_vpc.prod.id

  ingress {
    description = "SSH for the ledger on-call"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
