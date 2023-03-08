# Creates outputs
output "vpc_id" {
  description = "id of the vpc"
  value       = aws_vpc.vpc.id
}

output "public_subnet_id" {
  description = "id of the public subnet"
  value       = aws_subnet.public_subnet.id
}