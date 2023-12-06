variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "ec2_ami" {
  description = "AMI for EC2 instance"
}

variable "ec2_instance_type" {
  description = "Instance type for EC2 instance"
}

variable "private_subnet_id" {
  description = "ID of the private subnet"
  type = list(string)
}

variable "ec2_key_name" {
  description = "Name of the EC2 key pair"
  type = string
}

variable "vpc_id" {
  description = "ID of the VPC"
}

variable "rds_allocated_storage" {
  description = "Allocated storage for RDS instance"
}

variable "rds_engine" {
  description = "Database engine for RDS instance"
}

variable "rds_instance_class" {
  description = "Instance class for RDS instance"
}

variable "rds_identifier" {
  description = "Identifier for RDS instance"
}

variable "rds_username" {
  description = "Username for RDS instance"
}

variable "rds_password" {
  description = "Password for RDS instance"
}

variable "rds_subnet_group_name" {
  description = "Name of the DB subnet group for RDS instance"
}
variable "instance_count" {
  description = "Number of instances to provision."
  type        = number
}
variable "resource_tags" {
  description = "Tags to set for all resources"
  type        = map(string)
  default     = {
    project     = "my-project",
    environment = "dev"
  }
}
variable "db_subnet_group_description" {
  description = "Description of the DB subnet group"
  type        = string
}
variable "Name" {
  description = "Name for EC2 instance"
  type        = string
}
variable "public_subnet_id" {
  description = "ID of the public subnet"
  type = list(string)
}
variable "ami_username" {
  description = "IAM username"
  type        = any
}