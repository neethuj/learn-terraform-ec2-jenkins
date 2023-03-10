# VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.vpc_tag
  }
}

# Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = var.public_subnet_tag
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.igw_tag
  }
}

# Route Table with IGW route
resource "aws_route_table" "igw_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = var.igw_rt_tag
  }
}

# Route Table Subnet Association
resource "aws_route_table_association" "igw_rt_subnet_associ" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.igw_rt.id
}

# Security Group
resource "aws_security_group" "jenkins_security_group" {
  name_prefix = var.security_group_name
  description = "Jenkins EC2 instance"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allow SSH from my Public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allows Access to the Jenkins Server"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allows Access to the Jenkins Server"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = var.security_group_name
  }
}

# IAM Policy
resource "aws_iam_policy" "ec2_policy" {
  name        = var.ec2_policy_name
  path        = "/"
  description = "Policy for s3 Read and Get"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:Get*",
          "s3:List*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

# IAM Role
resource "aws_iam_role" "ec2_role" {
  name = var.ec2_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

# Attach policy to role
resource "aws_iam_policy_attachment" "ec2_role_policy_attach" {
  name       = "ec2-role-attachment"
  roles      = [aws_iam_role.ec2_role.name]
  policy_arn = aws_iam_policy.ec2_policy.arn
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = var.ec2_instance_profile_name
  role = aws_iam_role.ec2_role.name
}

# S3 Bucket
resource "aws_s3_bucket" "jenkins_backend_bucket" {
  bucket = var.bucket_name

  tags = {
    Name = var.bucket_name
  }
}

resource "aws_s3_bucket_acl" "jenkinsbucketacl" {
  bucket = var.bucket_name
  acl    = "private"
}

# Place holder template for future improvements
data "template_file" "init" {
  template = file("./user-data.tpl")
  vars = {
    jenkins-port = "8080"
  }
}

# EC2 Instance
resource "aws_instance" "ec2_instance" {
  ami                  = var.ami
  instance_type        = var.instance_type
  key_name             = var.ssh_key_name
  security_groups      = [aws_security_group.jenkins_security_group.id]
  subnet_id            = aws_subnet.public_subnet.id
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  user_data            = var.ec2_user_data
  # user-data            = "${data.template_file.init.rendered}"
  tags = {
    Name = var.ec2_tag
  }
}