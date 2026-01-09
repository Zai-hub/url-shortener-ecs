data "aws_availability_zones" "available" {
}

# VPC
resource "aws_vpc" "main" {
  #change to = var.vpc_cidr
    cidr_block = "172.17.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true
  
  tags = {
    Name = "url-shortener-ecs-vpc"
  }
}

# IGW
resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id

  tags = {
    Name = "url-shortener-ecs-igw"
  }
}

# Public Subnet
resource "aws_subnet" "public" {
    count                   = var.az_count
    cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, var.az_count + count.index)
    availability_zone       = data.aws_availability_zones.available.names[count.index]
    vpc_id                  = aws_vpc.main.id
    map_public_ip_on_launch = true

  tags = {
    Name = "url-shortener-ecs-public"
  }
}

# Private Subnet
resource "aws_subnet" "private" {
    count             = var.az_count
    cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
    availability_zone = data.aws_availability_zones.available.names[count.index]
    vpc_id            = aws_vpc.main.id
  
  tags = {
    Name = "url-shortener-ecs-private"
  }
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "url-shortener-ecs-public-rt"
  }
}

# Public route to IGW
resource "aws_route" "internet_access" {
    route_table_id         = aws_route_table.public.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = aws_internet_gateway.main.id
}

# Private Route Table
resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id

    tags = {
      Name = "url-shortener-ecs-private-rt"
    }
}

# Public RT Association
resource "aws_route_table_association" "public" {
  count          = var.az_count
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Route Table Association
resource "aws_route_table_association" "private" {
    count          = var.az_count
    subnet_id      = aws_subnet.private[count.index].id
    route_table_id = aws_route_table.private.id
}