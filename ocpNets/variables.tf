variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_key_path" {}
variable "aws_key_name" {}

variable "aws_region" {
    description = "EC2 Region for the VPC"
    default = "us-east-2"
}

variable "vpc_id" {
    description = "ID of the Corporate VPC"
    default = "vpc-0e552b6b62d287500"
}

variable "aws_internet_gateway_id" {
    description = "ID of the Corporate Internet Gateway"
    default = "igw-0ebed824e266a9617"
}

variable "ocp_public_subnet_cidr_a" {
    description = "CIDR for the OCP Public Subnet"
    default = "10.0.16.0/20"
}

variable "ocp_public_subnet_cidr_b" {
    description = "CIDR for the OCP Public Subnet"
    default = "10.0.32.0/20"
}

variable "ocp_public_subnet_cidr_c" {
    description = "CIDR for the OCP Public Subnet"
    default = "10.0.48.0/20"
}

variable "ocp_private_subnet_cidr_a" {
    description = "CIDR for the OCP Private Subnet"
    default = "10.0.128.0/20"
}

variable "ocp_private_subnet_cidr_b" {
    description = "CIDR for the OCP Private Subnet"
    default = "10.0.144.0/20"
}

variable "ocp_private_subnet_cidr_c" {
    description = "CIDR for the OCP Private Subnet"
    default = "10.0.160.0/20"
}