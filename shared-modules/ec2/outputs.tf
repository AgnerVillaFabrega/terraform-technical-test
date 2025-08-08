output "public_ec2_id" {
  description = "ID of the public EC2 instance"
  value       = aws_instance.public.id
}

output "private_ec2_id" {
  description = "ID of the private EC2 instance"
  value       = aws_instance.private.id
}

output "public_ec2_public_ip" {
  description = "Public IP of the public EC2 instance"
  value       = aws_instance.public.public_ip
}

output "private_ec2_private_ip" {
  description = "Private IP of the private EC2 instance"
  value       = aws_instance.private.private_ip
}