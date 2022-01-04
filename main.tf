provider "aws" {
  region = var.region
}

////////////////////////
// VPC
////////////////////////
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.environment}-VPC"
  }
}

////////////////////////
// SUBNETS
////////////////////////
resource "aws_subnet" "subnet-1-a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "${var.region}a"

  tags = {
    Name    = "${var.environment}-subnet-1-a"
    Network = "public"
  }
  depends_on = [aws_internet_gateway.main]
}

resource "aws_subnet" "subnet-2-a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.region}a"

  tags = {
    Name    = "${var.environment}-subnet-2-a"
    Network = "private"
  }
  depends_on = [aws_internet_gateway.main]
}

resource "aws_subnet" "subnet-1-b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "${var.region}b"

  tags = {
    Name    = "${var.environment}-subnet-1-b"
    Network = "public"
  }
  depends_on = [aws_internet_gateway.main]
}

resource "aws_subnet" "subnet-2-b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "${var.region}b"

  tags = {
    Name    = "${var.environment}-subnet-2-b"
    Network = "private"
  }
  depends_on = [aws_internet_gateway.main]
}

////////////////////////
// IGW
////////////////////////
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.environment}-igw"
  }
}

////////////////////////
// EIP
////////////////////////
resource "aws_eip" "nat_1_a" {
  vpc      = true
  depends_on = [aws_internet_gateway.main]
}

resource "aws_eip" "nat_1_b" {
  vpc      = true
  depends_on = [aws_internet_gateway.main]
}

////////////////////////
// NAT GATEWAY
////////////////////////
resource "aws_nat_gateway" "nat_1_a" {
  allocation_id = aws_eip.nat_1_a.id
  subnet_id     = aws_subnet.subnet-1-a.id

  tags = {
    Name = "${var.environment}-nat-1-a"
  }
  depends_on = [aws_internet_gateway.main]
}

resource "aws_nat_gateway" "nat_1_b" {
  allocation_id = aws_eip.nat_1_b.id
  subnet_id     = aws_subnet.subnet-1-b.id

  tags = {
    Name = "${var.environment}-nat-1-b"
  }
  depends_on = [aws_internet_gateway.main]
}