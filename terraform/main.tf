provider "aws" {
  region = var.aws_region
}
# Create EC2 Key Pair
resource "tls_private_key" "generated_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "example_keypair" {
  key_name   = var.ec2_key_name
  public_key = tls_private_key.generated_key.public_key_openssh
}
resource "local_file" "ec2_private_key" {
  filename = "${aws_key_pair.example_keypair.key_name}.pem"
  content  = tls_private_key.generated_key.private_key_pem
}
# Create RDS Subnet Group
resource "aws_db_subnet_group" "example_db_subnet_group" {
  name        = var.rds_subnet_group_name
  description = var.db_subnet_group_description
  subnet_ids = var.private_subnet_id # Assuming you have a private subnet

  tags = var.resource_tags
}
# EC2 Instance
resource "aws_instance" "example_instance" {
  ami           = var.ec2_ami
  instance_type = var.ec2_instance_type
  subnet_id     = var.public_subnet_id[0]
  key_name      = var.ec2_key_name
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.example_test_profile1.name
  vpc_security_group_ids = [aws_security_group.instance_sg.id]
  tags = {
    Name = var.Name
    project = var.resource_tags["project"]
    environment = var.resource_tags["environment"]
  }
    # other instance configurations...

  metadata_options {
    http_endpoint = "enabled"
    http_tokens = "required"
  }
}
resource "aws_eip" "example_eip" {
  instance = aws_instance.example_instance.id
  vpc      = true
  tags = {
    project = var.resource_tags["project"]
    environment = var.resource_tags["environment"]
  }
}
# RDS Instance
resource "aws_db_instance" "example_rds" {
  allocated_storage    = var.rds_allocated_storage
  engine               = var.rds_engine
  instance_class       = var.rds_instance_class
  identifier           = var.rds_identifier
  username             = var.rds_username
  password             = var.rds_password
  publicly_accessible  = false
  multi_az             = true
  db_subnet_group_name = var.rds_subnet_group_name
  final_snapshot_identifier = var.rds_identifier
  skip_final_snapshot = true
  tags = var.resource_tags
  vpc_security_group_ids = [aws_security_group.rds_sg.id]  # Associate the security group with the RDS instance
  depends_on = [aws_instance.example_instance, aws_db_subnet_group.example_db_subnet_group] # Make RDS depend on the EC2 instance
}

# Security Group for EC2 Instance
resource "aws_security_group" "instance_sg" {
  name        = "example_instance_sg"
  description = "Security group for the EC2 instance"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Open SSH to all for now, make it more restrictive in production
  }
    ingress {
    from_port   = 3306  # Assuming MySQL
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Open to all; make it more restrictive in production
  }
  # Egress rule to allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # All protocols
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic
  }
  tags = var.resource_tags  # Apply the tags to the security group
}
resource "aws_iam_role" "example_test_role" {
  name = "example_test_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecr_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.example_test_role.name
}

resource "aws_iam_role_policy_attachment" "ssm_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
  role       = aws_iam_role.example_test_role.name
}

resource "aws_iam_role_policy_attachment" "ssm_managed_instance_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.example_test_role.name
}

resource "aws_iam_role_policy_attachment" "cloudwatch_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.example_test_role.name
}
resource "aws_iam_instance_profile" "example_test_profile1" {
  name = "example_instance_profile"
  role = aws_iam_role.example_test_role.name
}
resource "aws_security_group" "rds_sg" {
  name = "rds_sg"
  description = "Security group for the RDS instance"
  vpc_id = var.vpc_id
}
resource "aws_security_group_rule" "rds_sg_rule" {
  type = "ingress"
  from_port = 3306
  to_port = 3306
  protocol = "tcp"
  security_group_id = aws_security_group.rds_sg.id
  source_security_group_id = aws_security_group.instance_sg.id
}
resource "aws_security_group_rule" "rds_sg_rule2" {
  type = "ingress"
  from_port = 3306
  to_port = 3306
  protocol = "tcp"
  security_group_id = "sg-0f38e03761b521d94"
  source_security_group_id = aws_security_group.rds_sg.id
}