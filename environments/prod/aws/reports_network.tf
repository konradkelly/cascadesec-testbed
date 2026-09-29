# Bastion access for the reporting service's operators.
resource "aws_security_group" "reports_bastion" {
  name        = "reports-bastion"
  description = "SSH to the reporting bastion"
  vpc_id      = aws_vpc.prod.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "RDP"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
