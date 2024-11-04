variable "number_of_azs" {
  description = "Number of AZs to be used"
  default     = 1
  type        = number
}

variable "region" {
  description = "AWS region for deployment"
  default     = "eu-central-1"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for launch template"
  default     = "m5.large"
  type        = string
}

variable "db_instance_type" {
  description = "DB instance type"
  default     = "db.c6gd.medium"
  type        = string
}

variable "db_username" {
  description = "Database username"
  default     = "admin"
  type        = string
}

variable "wordpress_version" {
  description = "Version of WordPress to install"
  default     = "latest"
  type        = string
}
