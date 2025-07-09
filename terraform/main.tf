data "aws_availability_zones" "available" {
  state = "available"
}

# ------------------------------
# Network resources
# ------------------------------

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name      = "fastapi_vpc"
    App       = "fastapi"
    Terraform = "true"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.100.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
  tags = {
    Name      = "fastapi_public_subnet"
    App       = "fastapi"
    Terraform = "true"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name      = "fastapi_igw"
    App       = "fastapi"
    Terraform = "true"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name      = "fastapi_route_table"
    App       = "fastapi"
    Terraform = "true"
  }
}

resource "aws_route_table_association" "public" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public.id
}

# ------------------------------
# Security group
# ------------------------------

resource "aws_security_group" "server_sg" {
  name        = "fastapi_sg"
  description = "Allow ingress HTTP/SSH traffic"
  vpc_id      = aws_vpc.vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "fastapi_sg"
    App       = "fastapi"
    Terraform = "true"
  }
}

# ------------------------------
# IAM Role, Instance profile
# ------------------------------

resource "aws_iam_role" "ec2" {
  name = "ec2-role"

  # Política de confiança que permite que o serviço EC2 assuma esta role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name      = "ec2_role"
    App       = "fastapi"
    Terraform = "true"
  }
}

resource "aws_iam_role_policy_attachment" "ecr_read_only_attachment" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_instance_profile" "ec2" {
  name = "ec2"
  role = aws_iam_role.ec2.name
}

# ------------------------------
# Key Pair
# ------------------------------

resource "aws_key_pair" "key" {
  key_name   = "fastapi-instance-key"
  public_key = file("~/.ssh/study-key.pub")
}

# ------------------------------
# Compute resources
# ------------------------------


data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-kernel-6.1-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "server" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.server_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2.name
  key_name               = aws_key_pair.key.key_name
  user_data              = file("${path.module}/user-data.sh")

  tags = {
    Name      = "fastapi_server"
    App       = "fastapi"
    Terraform = "true"
  }
}


# ------------------------------
# Compute resources
# ------------------------------

resource "aws_ecr_repository" "repository" {
  name                 = "fastapi"
  image_tag_mutability = "MUTABLE"

  tags = {
    Name      = "fastapi_ecr"
    App       = "fastapi"
    Terraform = "true"
  }
}
