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

resource "aws_subnet" "us-east-2b-public" {
    vpc_id = var.vpc_id

    cidr_block = var.ocp_public_subnet_cidr_b
    availability_zone = "us-east-2b"

    tags = {
        Name = "OCP Public Subnet AZ B"
    }
}

resource "aws_subnet" "us-east-2c-public" {
    vpc_id = var.vpc_id

    cidr_block = var.ocp_public_subnet_cidr_c
    availability_zone = "us-east-2c"

    tags = {
        Name = "OCP Public Subnet AZ C"
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

resource "aws_route_table" "us-east-2b-public" {
    vpc_id = var.vpc_id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = var.aws_internet_gateway_id
    }

    tags = {
        Name = "OCP Public Subnet AZ B"
    }
}

resource "aws_route_table" "us-east-2c-public" {
    vpc_id = var.vpc_id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = var.aws_internet_gateway_id
    }

    tags = {
        Name = "OCP Public Subnet AZ C"
    }
}


resource "aws_route_table_association" "us-east-2a-public" {
    subnet_id = aws_subnet.us-east-2a-public.id
    route_table_id = aws_route_table.us-east-2a-public.id
}

resource "aws_route_table_association" "us-east-2b-public" {
    subnet_id = aws_subnet.us-east-2b-public.id
    route_table_id = aws_route_table.us-east-2b-public.id
}

resource "aws_route_table_association" "us-east-2c-public" {
    subnet_id = aws_subnet.us-east-2c-public.id
    route_table_id = aws_route_table.us-east-2c-public.id
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

resource "aws_subnet" "us-east-2b-private" {
    vpc_id = var.vpc_id

    cidr_block = var.ocp_private_subnet_cidr_b
    availability_zone = "us-east-2b"

    tags = {
        Name = "OCP Private Subnet AZ B"
    }
}

resource "aws_eip" "natgw_b_eip" {
  vpc = true
}

resource "aws_nat_gateway" "natgw_b" {
  allocation_id = aws_eip.natgw_b_eip.id
  subnet_id     = aws_subnet.us-east-2b-public.id

  tags = {
    Name = "gw NAT zone b"
  }
}

resource "aws_subnet" "us-east-2c-private" {
    vpc_id = var.vpc_id

    cidr_block = var.ocp_private_subnet_cidr_c
    availability_zone = "us-east-2c"

    tags = {
        Name = "OCP Private Subnet AZ C"
    }
}

resource "aws_eip" "natgw_c_eip" {
  vpc = true
}

resource "aws_nat_gateway" "natgw_c" {
  allocation_id = aws_eip.natgw_c_eip.id
  subnet_id     = aws_subnet.us-east-2c-public.id

  tags = {
    Name = "gw NAT zone c"
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

resource "aws_route_table" "us-east-2b-private" {
    vpc_id = var.vpc_id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.natgw_b.id
    }

    tags = {
        Name = "OCP Private Subnet AZ B"
    }
}

resource "aws_route_table" "us-east-2c-private" {
    vpc_id = var.vpc_id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.natgw_c.id
    }

    tags = {
        Name = "OCP Private Subnet AZ C"
    }
}

resource "aws_route_table_association" "us-east-2a-private" {
    subnet_id = aws_subnet.us-east-2a-private.id
    route_table_id = aws_route_table.us-east-2a-private.id
}

resource "aws_route_table_association" "us-east-2b-private" {
    subnet_id = aws_subnet.us-east-2b-private.id
    route_table_id = aws_route_table.us-east-2b-private.id
}

resource "aws_route_table_association" "us-east-2c-private" {
    subnet_id = aws_subnet.us-east-2c-private.id
    route_table_id = aws_route_table.us-east-2c-private.id
}

/*
  Update NAT instance with OCP rules
*/
resource "aws_security_group" "nat" {
    name = "vpc_ocp_nat"
    description = "Allow traffic to pass from the private subnet to the internet"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [var.ocp_private_subnet_cidr_a, var.ocp_private_subnet_cidr_b, var.ocp_private_subnet_cidr_c]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = [var.ocp_private_subnet_cidr_a, var.ocp_private_subnet_cidr_b, var.ocp_private_subnet_cidr_c]
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
        cidr_blocks = [var.ocp_private_subnet_cidr_a, var.ocp_private_subnet_cidr_b, var.ocp_private_subnet_cidr_c]
    }

    egress {
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        cidr_blocks = [var.ocp_private_subnet_cidr_a, var.ocp_private_subnet_cidr_b, var.ocp_private_subnet_cidr_c]
    }

    vpc_id = var.vpc_id

    tags = {
        Name = "OCPNATSG"
    }
}