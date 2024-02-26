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

resource "aws_instance" "web" {
  ami           = data.aws_ami.app_ami.id
  instance_type = var.instance_type 

  vpc_security_groups_ids = [aws_security_group.blog.vpc.id]
  }

  tags = {
    Name = "HelloWorld"
  }
}

data "aws_vpc" "Default" {
  Default = true

}

resource "aws_security_group" "blog"{

  name = "blog"
  description - "Allow HTTP and HTTPS in. Allow all out"

  vpc_id = data.aws_vpc.Default.id


}

resource "aws_security_group_rule" "blog_http_in"{

  type = "ingress"
  from_port = 80
  to_port = 80
  protocal = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  aws_security_group_id = aws_security_group_id

}

resource "aws_security_group_rule" "blog_http_in"{

  type = "ingress"
  from_port = 443
  to_port = 443
  protocal = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  aws_security_group_id = aws_security_group.blog.id

}

resource "aws_security_group_rule" "blog_http_everything_out"{

  type = "egress"
  from_port = 0
  to_port = 0
  protocal = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  aws_security_group_id = aws_security_group_id

}