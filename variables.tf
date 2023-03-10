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

variable "ec2_policy_name" {
  description = "Name of the ec2 policy"
  default     = "ec2-s3read-policy"
}

variable "ec2_role_name" {
  description = "Name of the ec2 role"
  default     = "ec2-s3read-role"
}

variable "ec2_instance_profile_name" {
  description = "Name of the ec2 instance profile"
  default     = "ec2-instance-profile"
}

variable "bucket_name" {
  description = "Name of the jenkins backend bucket"
  default     = "neethus-jenkins-backend"
}

variable "ami" {
  description = "AMI ID for the EC2 instance"
  default     = "ami-005f9685cb30f234b"
}

variable "instance_type" {
  description = "Type of the EC2 instance"
  default     = "t2.micro"
}

variable "ssh_key_name" {
  description = "Name of the SSH key pair"
  default     = "my-jenkins-ssh-key"
}

variable "ec2_user_data" {
  description = "User data script for EC2 instances"
  type        = string
  default     = <<EOF
#!/bin/bash
# Install Jenkins and Java
sudo wget -O /etc/yum.repos.d/jenkins.repo  https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum -y upgrade
# Add required dependencies for the jenkins package
sudo amazon-linux-extras install -y java-openjdk11
sudo yum install -y jenkins
sudo systemctl daemon-reload

# Start Jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins

# Firewall Rules
if [[ $(firewall-cmd --state) = 'running' ]]; then
    YOURPORT=8080
    PERM="--permanent"
    SERV="$PERM --service=jenkins"

    firewall-cmd $PERM --new-service=jenkins
    firewall-cmd $SERV --set-short="Jenkins ports"
    firewall-cmd $SERV --set-description="Jenkins port exceptions"
    firewall-cmd $SERV --add-port=$YOURPORT/tcp
    firewall-cmd $PERM --add-service=jenkins
    firewall-cmd --zone=public --add-service=http --permanent
    firewall-cmd --reload
fi
EOF
}

variable "ec2_tag" {
  description = "Tag for the EC2 instance"
  default     = "jenkins-server"
}