data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "main" {
  key_name   = var.key_name
  public_key = file("${path.root}/../../terraform-key.pub")

  tags = var.tags
}

resource "aws_instance" "public" {
  ami                     = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.main.key_name
  vpc_security_group_ids = [var.public_security_group_id]
  subnet_id              = var.public_subnet_id

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Public EC2 Instance</h1>" > /var/www/html/index.html
              EOF

  tags = merge(var.tags, {
    Name = "terraform-test-public-ec2"
  })
}

resource "aws_instance" "private" {
  ami                     = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.main.key_name
  vpc_security_group_ids = [var.private_security_group_id]
  subnet_id              = var.private_subnet_id

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              echo "<h1>Private EC2 Instance</h1>" > /tmp/index.html
              EOF

  tags = merge(var.tags, {
    Name = "terraform-test-private-ec2"
  })
}