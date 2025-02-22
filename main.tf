provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "web_sg" {
  name_prefix = "web-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0" # Ubuntu 20.04 AMI
  instance_type = "t2.micro"
  security_groups = [aws_security_group.web_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y nginx
              echo "Deployed via Terraform" > /var/www/html/index.html
              systemctl restart nginx
              EOF
}

output "ec2_public_ip" {
  value = aws_instance.web.public_ip
}