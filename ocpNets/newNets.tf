/*
  Public Subnet
*/
resource "aws_subnet" "us-east-2a-public" {
    vpc_id = var.vpc_id

    cidr_block = var.ocp_public_subnet_cidr_a
    availability_zone = "us-east-2a"

    tags = {
        Name = "OCP Public Subnet AZ A"
    }
}

resource "aws_route_table" "us-east-2a-public" {
    vpc_id = var.vpc_id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = var.aws_internet_gateway_id
    }

    tags = {
        Name = "OCP Public Subnet AZ A"
    }
}

resource "aws_route_table_association" "us-east-2a-public" {
    subnet_id = aws_subnet.us-east-2a-public.id
    route_table_id = aws_route_table.us-east-2a-public.id
}

/*
  Private Subnet
  We need to create a NAT-Gateway for each private subnet
*/
resource "aws_subnet" "us-east-2a-private" {
    vpc_id = var.vpc_id

    cidr_block = var.ocp_private_subnet_cidr_a
    availability_zone = "us-east-2a"

    tags = {
        Name = "OCP Private Subnet AZ A"
    }
}

resource "aws_eip" "natgw_a_eip" {
  vpc = true
}

resource "aws_nat_gateway" "natgw_a" {
  allocation_id = aws_eip.natgw_a_eip.id
  subnet_id     = aws_subnet.us-east-2a-public.id

  tags = {
    Name = "gw NAT zone a"
  }
}

resource "aws_route_table" "us-east-2a-private" {
    vpc_id = var.vpc_id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.natgw_a.id
    }

    tags = {
        Name = "OCP Private Subnet AZ A"
    }
}

resource "aws_route_table_association" "us-east-2a-private" {
    subnet_id = aws_subnet.us-east-2a-private.id
    route_table_id = aws_route_table.us-east-2a-private.id
}

/*
  Update NAT instance with OCP rules
*/
resource "aws_security_group" "nat" {
    name = "vpc_ocp_nat"
    description = "Allow traffic to pass from the private subnet to the internet and allow incoming"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [var.ocp_private_subnet_cidr_a]

    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = [var.ocp_private_subnet_cidr_a]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 1024
        to_port = 65535
        protocol = "tcp"
        cidr_blocks = [var.ocp_private_subnet_cidr_a]
    }

    egress {
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        cidr_blocks = [var.ocp_private_subnet_cidr_a]
    }

    vpc_id = var.vpc_id

    tags = {
        Name = "OCPNATSG"
    }
}