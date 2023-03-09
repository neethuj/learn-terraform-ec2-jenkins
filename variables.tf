# This file references the resources and sets the necessary variables.
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "vpc_tag" {
  description = "Tag for the VPC"
  default     = "my-terraform-vpc"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the subnet"
  default     = "10.0.0.0/24"
}

variable "public_subnet_tag" {
  description = "Tag for the subnet"
  default     = "my-public-subnet"
}

variable "igw_tag" {
  description = "Tag for the igw"
  default     = "my-igw"
}

variable "igw_rt_tag" {
  description = "Tag for the InternetGW RT"
  default     = "my-igw-rt"
}

variable "security_group_name" {
  description = "Tag for the security group"
  default     = "jenkins-security-group"
}