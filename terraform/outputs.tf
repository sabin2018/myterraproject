output "ec2_instance_id" {
  value = aws_instance.example_instance.id
}

output "rds_username" {
  value = aws_db_instance.example_rds.username
}
output "rds_endpoint" {
  value       = aws_db_instance.example_rds.endpoint
  description = "The endpoint of the RDS instance"
}

output "rds_port" {
  value       = aws_db_instance.example_rds.port
  description = "The port of the RDS instance"
}
output "instance_name" {
  value       = aws_instance.example_instance.tags.Name
  description = "The name (if available) of the EC2 instance"
}
output "EIP" {
  value       = aws_eip.example_eip.public_ip
  description = "The public IP address of the EC2 instance" 
}
output "public_dns" {
   value       = "ec2-${replace(aws_eip.example_eip.public_ip, ".", "-")}.compute-1.amazonaws.com"
  description = "The public DNS name (if available) of the EC2 instance"
  
}
output "ssh_instructions" {
  value = <<EOT

Follow the following instructions to SSH into your EC2 instance:

1. Open an SSH client.

2. Locate your private key file. The key used to launch this instance is ${var.ec2_key_name}.pem

3. Run this command, if necessary, to ensure your key is not publicly viewable.
 chmod 400 ${var.ec2_key_name}.pem

4. Connect to your instance using its Public DNS:
 ${replace(aws_eip.example_eip.public_ip, ".", "-")}.compute-1.amazonaws.com

5. Run the following command, substituting the path to your private key file for KEY_PATH:
 ssh -i "${var.ec2_key_name}.pem" ${var.ami_username}@ec2-${replace(aws_eip.example_eip.public_ip, ".", "-")}.compute-1.amazonaws.com
EOT
description = "SSH instructions for accessing the instance"
}


