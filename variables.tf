variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-east-1"
}

variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "the vpc cdir range"
}

variable "public_subnet_a" {
  default     = "10.0.0.0/24"
  description = "Public subnet AZ A"
}

variable "public_subnet_b" {
  default     = "10.0.4.0/24"
  description = "Public subnet AZ B"
}

variable "public_subnet_c" {
  default     = "10.0.8.0/24"
  description = "Public subnet AZ C"
}

variable "private_subnet_a" {
  default     = "10.0.1.0/24"
  description = "Private subnet AZ A"
}

variable "private_subnet_b" {
  default     = "10.0.5.0/24"
  description = "Private subnet AZ B"
}

variable "private_subnet_c" {
  default     = "10.0.9.0/24"
  description = "Private subnet AZ C"
}
