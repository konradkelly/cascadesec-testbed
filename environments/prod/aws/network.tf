resource "aws_vpc" "prod" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "prod"
  }
}

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.prod.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 4, 0)
  availability_zone = "${var.region}a"

  tags = {
    Name = "prod-private-a"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.prod.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 4, 1)
  availability_zone = "${var.region}b"

  tags = {
    Name = "prod-private-b"
  }
}

# The default security group denies everything; nothing should use it.
resource "aws_default_security_group" "prod" {
  vpc_id = aws_vpc.prod.id
}

resource "aws_flow_log" "prod" {
  vpc_id          = aws_vpc.prod.id
  traffic_type    = "ALL"
  iam_role_arn    = aws_iam_role.flow_logs.arn
  log_destination = aws_cloudwatch_log_group.flow_logs.arn
}

resource "aws_cloudwatch_log_group" "flow_logs" {
  name              = "/prod/vpc/flow-logs"
  retention_in_days = 365
  kms_key_id        = aws_kms_key.data.arn
}

resource "aws_iam_role" "flow_logs" {
  name = "prod-vpc-flow-logs"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "vpc-flow-logs.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}
