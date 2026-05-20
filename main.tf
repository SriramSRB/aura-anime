provider "aws" {
    region = "ap-south-1"
}

resource "aws_vpc" "aura-anime_vpc" {
    cidr_block = "10.0.0.0/16"
    tags       = { Name = "aura-anime-vpc" }
}

resource "aws_subnet" "aura-anime_subnet" {
    vpc_id                  = aws_vpc.aura-anime_vpc.id
    cidr_block              = "10.0.0.0/21"
    map_public_ip_on_launch = true
    availability_zone       = "ap-south-1a"
    tags                    = { Name = "aura-anime-subnet" } 
}

resource "aws_internet_gateway" "aura-anime_igw" {
    vpc_id = aws_vpc.aura-anime_vpc.id
}

resource "aws_route_table" "aura-anime_rt" {
    vpc_id = aws_vpc.aura-anime_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.aura-anime_igw.id
    }
}

resource "aws_route_table_association" "aura-anime_association" {
    subnet_id      = aws_subnet.aura-anime_subnet.id
    route_table_id = aws_route_table.aura-anime_rt.id
}

resource "aws_security_group" "aura-anime_sg" {
    vpc_id = aws_vpc.aura-anime_vpc.id

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 30080
        to_port     = 30080
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_kay_pair" "aura-anime_key" {
    key_name   = "aura-anime-key"
    public_key = file("f:/file/devops/aura-anime-1/aura-anime-key.pub")
}

resource "aws_instance" "aura-anime-server" {
    ami                    = "ami-05d2d839d4f73aafb"
    instance_type          = "m7i-flex.large"
    vpc_security_group_ids = [aws_security_group.aura-anime_sg.id]
    subnet_id              = aws_subnet.aura-anime_subnet.id
    key_name               = aws_kay_pair.aura-anime_key.key_name

    root_block_device {
        root_size = 16
        root_type = "gp3"
    }

    tags = { Name = "aura-anime-server" }
}