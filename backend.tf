terraform {
  backend "s3" {
    bucket = "neethusterraformbackend"
    key    = "terraform/state/ec2-jenkins"
    region = "us-east-1"
  }
}

