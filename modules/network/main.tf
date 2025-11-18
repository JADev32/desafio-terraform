locals {
  public_subnet_count  = length(var.public_subnet_cidrs)
  private_subnet_count = length(var.private_subnet_cidrs)
}

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    var.tags,
    { Name = "${var.name}-vpc" }
  )
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    var.tags,
    { Name = "${var.name}-igw" }
  )
}

resource "aws_subnet" "public" {
  count = local.public_subnet_count

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-public-${count.index + 1}"
      Tier = "public"
    }
  )
}

resource "aws_subnet" "private" {
  count = local.private_subnet_count

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-private-${count.index + 1}"
      Tier = "private"
    }
  )
}

# EIP para el NAT
resource "aws_eip" "nat" {
  domain = "vpc"  # <- esta es la forma nueva

  tags = merge(
    var.tags,
    { Name = "${var.name}-nat-eip" }
  )
}


# 1 solo NAT, en la primera pública (igual que en tu doc)
resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
    var.tags,
    { Name = "${var.name}-nat-1" }
  )

  depends_on = [aws_internet_gateway.this]
}

# Route table pública
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(
    var.tags,
    { Name = "${var.name}-rtb-public" }
  )
}

resource "aws_route_table_association" "public" {
  count = local.public_subnet_count

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Route tables privadas, ambas salen por el mismo NAT
resource "aws_route_table" "private" {
  count = local.private_subnet_count

  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }

  tags = merge(
    var.tags,
    { Name = "${var.name}-rtb-private-${count.index + 1}" }
  )
}

resource "aws_route_table_association" "private" {
  count = local.private_subnet_count

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
