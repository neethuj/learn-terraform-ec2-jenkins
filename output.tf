# Creates outputs
output "vpc_id" {
  description = "id of the vpc"
  value       = aws_vpc.vpc.id
}

output "public_subnet_id" {
  description = "id of the public subnet"
  value       = aws_subnet.public_subnet.id
}

output "igw_id" {
  description = "id of the internet gw"
  value       = aws_internet_gateway.igw.id
}

output "igw_rt_id" {
  description = "id of the internet gw rt"
  value       = aws_route_table.igw_rt.id
}

output "security_group_id" {
  description = "id of the jenkins SG"
  value       = aws_security_group.jenkins_security_group.id
}