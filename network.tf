/*
#Add VPC
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
resource "aws_vpc" "guide-tfe-es-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    "name" = "guide-tfe-es-vpc"
  }
}

#AWS Subnet for TFE
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
resource "aws_subnet" "guide-tfe-es-sub" {
  vpc_id                  = aws_vpc.guide-tfe-es-vpc.id
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.az1
  tags = {
    "name" = "guide-tfe-es-pub-sub"
  }
}

#AWS Subnet for db
resource "aws_subnet" "guide-tfe-es-sub-db-1a" {
  vpc_id            = aws_vpc.guide-tfe-es-vpc.id
  availability_zone = var.az1
  cidr_block        = var.db_subnet_cidr_az1
  tags = {
    "name" = "guide-tfe-es-pub-sub"
  }
}

resource "aws_subnet" "guide-tfe-es-sub-db-1b" {
  vpc_id            = aws_vpc.guide-tfe-es-vpc.id
  availability_zone = var.az2
  cidr_block        = var.db_subnet_cidr_az2
  tags = {
    "name" = "guide-tfe-es-pub-sub"
  }
}

#AWS IGW
resource "aws_internet_gateway" "guide-tfe-es-igw" {
  vpc_id = aws_vpc.guide-tfe-es-vpc.id

  tags = {
    Name = "guide-tfe-es-igw"
  }
}

#AWS RT
resource "aws_route_table" "guide-tfe-es-pub-rt" {
  vpc_id = aws_vpc.guide-tfe-es-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.guide-tfe-es-igw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.guide-tfe-es-igw.id
  }

  tags = {
    Name = "guide-tfe-es-pub-rt"
  }
}


resource "aws_route_table" "guide-tfe-es-pri-rt" {
  vpc_id = aws_vpc.guide-tfe-es-vpc.id

  tags = {
    Name = "guide-tfe-es-pri-rt"
  }
}

resource "aws_route_table_association" "guide-tfe-es-pub-rt-asc" {
  subnet_id      = aws_subnet.guide-tfe-es-sub.id
  route_table_id = aws_route_table.guide-tfe-es-pub-rt.id
}

resource "aws_eip" "bar" {
  vpc = true

  instance                  = aws_instance.guide-tfe-es-ec2.id
  associate_with_private_ip = aws_instance.guide-tfe-es-ec2.private_ip
}
*/

data "aws_availability_zones" "azs" {
  state = "available"
}

resource "aws_vpc" "guide-tfe-es-vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    "name" = "fawaz-tfe-es-vpc"
  }
}

resource "aws_subnet" "fawaz-tfe-es-pub-sub" {
  count             = 3
  availability_zone = data.aws_availability_zones.azs.names[count.index]
  vpc_id            = aws_vpc.guide-tfe-es-vpc.id
  map_public_ip_on_launch = true
  cidr_block        = cidrsubnet(var.vpc_cidr, 4, count.index)
  tags = {
    "name" = "fawaz-tfe-es-pub-sub"
  }
}

resource "aws_subnet" "fawaz-tfe-es-pri-sub" {
  count             = 3
  availability_zone = data.aws_availability_zones.azs.names[count.index]
  vpc_id            = aws_vpc.guide-tfe-es-vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 4, 3 + count.index)
  tags = {
    "name" = "fawaz-tfe-es-pri-sub"
  }
}

resource "aws_internet_gateway" "fawaz-tfe-es-igw" {
  vpc_id = aws_vpc.guide-tfe-es-vpc.id

  tags = {
    Name = "fawaz-tfe-es-igw"
  }
}

resource "aws_route_table" "fawaz-tfe-es-pub-rt" {
  vpc_id = aws_vpc.guide-tfe-es-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.fawaz-tfe-es-igw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.fawaz-tfe-es-igw.id
  }

  tags = {
    Name = "fawaz-tfe-es-pub-rt"
  }
}

resource "aws_route_table" "fawaz-tfe-es-pri-rt" {
  vpc_id = aws_vpc.guide-tfe-es-vpc.id

  tags = {
    Name = "fawaz-tfe-es-pri-rt"
  }
}

resource "aws_route_table_association" "fawaz-tfe-es-pub-rt-asc" {
  count          = 3
  subnet_id      = element(aws_subnet.fawaz-tfe-es-pub-sub[*].id, count.index)
  route_table_id = aws_route_table.fawaz-tfe-es-pub-rt.id
}

resource "aws_route_table_association" "fawaz-tfe-es-pri-rt-asc" {
  count          = 3
  subnet_id      = element(aws_subnet.fawaz-tfe-es-pri-sub[*].id, count.index)
  route_table_id = aws_route_table.fawaz-tfe-es-pri-rt.id
}

