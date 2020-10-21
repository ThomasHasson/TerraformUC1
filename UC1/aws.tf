
provider "aws" {
  region     = var.AWS_REGION
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY
}

# VPC, gateway, and routing for VPC
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route" "route" {
  route_table_id         = aws_vpc.vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gateway.id
}

# Subnet + Security groups
resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.vpc.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
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


# Load balancer
module "elb_http" {
  source  = "terraform-aws-modules/elb/aws"
  version = "~> 2.0"

  name = "elb"

  subnets         = [aws_subnet.main.id]
  security_groups = [aws_default_security_group.default.id]
  internal        = false

  listener = [
    {
      instance_port     = "80"
      instance_protocol = "HTTP"
      lb_port           = "80"
      lb_protocol       = "HTTP"
    },
    {
      instance_port     = "8080"
      instance_protocol = "http"
      lb_port           = "8080"
      lb_protocol       = "http"
    },
  ]

  health_check = {
    target              = "HTTP:80/"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
  }

  // ELB attachments
  number_of_instances = 3
  instances           = aws_instance.webserver.*.id
}
