variable "region" {
  description = "AWS region for the production environment."
  type        = string
  default     = "us-west-2"
}

variable "vpc_cidr" {
  description = "CIDR block of the production VPC."
  type        = string
  default     = "10.40.0.0/16"
}

variable "office_cidr" {
  description = "The corporate VPN's egress range; the only network allowed to reach admin endpoints."
  type        = string
  default     = "203.0.113.0/24"
}

variable "db_password" {
  description = "Master password for the payments database. Supplied from the secrets pipeline, never committed."
  type        = string
  sensitive   = true
}
