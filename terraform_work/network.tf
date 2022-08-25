resource "aws_vpc" "ecs_cluster_vpc" {
  tags = {
    "Name" = "ecs_cluster_vpc"
    "Project" = "no-jam"
  }
  cidr_block = "10.0.0.0/16"
}
resource "aws_subnet" "ecs_subnet" {
  vpc_id = aws_vpc.ecs_cluster_vpc
  count = length(data.aws_availbility_zones.available.names)
  cidr_block = "10.30.${10 + count.index}.0/24"
  availability_zone = data.aws_availbility_zones.available.names[count.index]
  tags = {
    "Name" = "ecs_subnet_${1 + count.index}"
    "Project" = "no-jam"
  }
}

resource "aws_internet_gateway" "ecs_igw" {
  vpc_id = aws_vpc.ecs_cluster_vpc
  tags = {
    "Name" = "ecs_igw"
    "Project" = "no-jam"
  }
}

resource "aws_eip" "nat_gw" {
  vpc = true
  depends_on = [
    "aws_internet_gateway.ecs_igw"
  ]
}

resource "aws_nat_gateway" "ecs_ngw" {
  allocation_id = aws_eip.nat_gw
  subnet_id = aws_subnet.ecs_subnet
}

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.ecs_cluster_vpc
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ecs_igw.id
  }
  tags = {
    "Name" = "ecs-route-table"
    "Project" = "no-jam"
  }  
}
