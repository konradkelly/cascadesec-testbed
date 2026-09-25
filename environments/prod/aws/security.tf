resource "aws_security_group" "payments_api" {
  name        = "prod-payments-api"
  description = "Payments API tasks"
  vpc_id      = aws_vpc.prod.id

  ingress {
    description = "HTTPS from inside the VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    description = "HTTPS to VPC endpoints inside the VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
}

resource "aws_security_group" "payments_db" {
  name        = "prod-payments-db"
  description = "Payments database"
  vpc_id      = aws_vpc.prod.id

  ingress {
    description     = "Postgres from the payments API only"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.payments_api.id]
  }
}
