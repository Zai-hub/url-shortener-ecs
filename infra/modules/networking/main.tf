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

# Private RT Association
resource "aws_route_table_association" "private" {
    count          = var.az_count
    subnet_id      = aws_subnet.private[count.index].id
    route_table_id = aws_route_table.private.id
}

# VPC Endpoints

# S3 Endpoint
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.private.id]

  tags = {
    Name = "url-shortener-s3-endpoint"
  }
}

# DynamoDB Endpoint
resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.aws_region}.dynamodb"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.private.id]

  tags = {
    Name = "url-shortener-dynamodb-endpoint"
  }
}

# ECR Endpoint
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.aws_region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private[*].id
  security_group_ids  = [var.vpc_endpoints_sg_id]
  private_dns_enabled = true

  tags = {
    Name = "url-shortener-ecr-api-endpoint"
  }
}

# ECR Docker Endpoint
resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.aws_region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private[*].id
  security_group_ids  = [var.vpc_endpoints_sg_id]
  private_dns_enabled = true

  tags = {
    Name = "url-shortener-ecr-docker-endpoint"
  }
}

# CloudWatch Endpoint
resource "aws_vpc_endpoint" "logs" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.aws_region}.logs"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private[*].id
  security_group_ids  = [var.vpc_endpoints_sg_id]
  private_dns_enabled = true

  tags = {
    Name = "url-shortener-cloudwatch-endpoint"
  }
}

# ECS Endpoint
resource "aws_vpc_endpoint" "ecs" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.aws_region}.ecs"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private[*].id
  security_group_ids  = [var.vpc_endpoints_sg_id]
  private_dns_enabled = true

  tags = {
    Name = "url-shortener-ecs-endpoint"
  }
}