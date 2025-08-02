variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-2"
}

variable "instance_type" {
  description = "AWS instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_dir" {
  default = "./../keys"
}


variable "ami" {
  description = "AWS AMI"
  type        = string
  default     = "ami-0532f1280ac457a8f"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.16.0.0/16"
}

variable "subnet_cidr_public_a" {
  description = "Subnet CIDR block"
  type        = string
  default     = "10.16.1.0/24"
}

variable "subnet_cidr_public_b" {
  description = "Subnet CIDR block"
  type        = string
  default     = "10.16.2.0/24"
}

variable "subnet_cidr_pri_private" {
  description = "Subnet CIDR block"
  type        = string
  default     = "10.16.3.0/24"
}

variable "subnet_cidr_sec_private" {
  description = "Subnet CIDR block"
  type        = string
  default     = "10.16.4.0/24"
}


####### TO IMPROVE - NOT Secure or follows the best practices #####

variable "db_user" {
  description = "Database user"
  type        = string
  default     = "postgres"
}

variable "db_password" {
  description = "Database password"
  type        = string
  default     = "password123"
}
