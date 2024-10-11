data "aws_ami" "app_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["bitnami-tomcat-*-x86_64-hvm-ebs-nami"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["979382823631"] # Bitnami
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_instance" "Blog" {
  ami           = data.aws_ami.app_ami.id
  instance_type = var.instance_type

#Security group to use for VPC in AWS
vpc_security_groups_ids = [aws_security_group.Blog.id]


  tags = {
    Name = "Learning Terraform"
  }
}

# New security group
resource "aws_security_group" "Blog" {
name = "Blog"
Description = " Allow http and https in. Allow everything out"

vpc_id = data.aws_vpc.default.id

}

# Rule for new Secruty group IN
resource "aws_security_group_rule" "Blog_http_in" {
  type = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

# Points to New Security Group
security_group_id = aws_security_group.Blog.id

}

# Rule for new Secruty group OUT
resource "aws_security_group_rule" "Blog_http_out" {
  type = "egress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

# Points to New Security Group
security_group_id = aws_security_group.Blog.id

}

# Rule for new Secruty group IN
resource "aws_security_group_rule" "Blog_http_everything" {
  type = "ingress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

# Points to New Security Group
security_group_id = aws_security_group.Blog.id

}