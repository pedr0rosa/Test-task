resource "aws_instance" "Bastion_host" {
    ami = var.ami
    instance_type = var.instance_type
    availability_zone = "eu-west-2a"
    subnet_id = aws_subnet.public_subnet_a.id 
    vpc_security_group_ids = [aws_security_group.bastion_sg.id]
    key_name = local.keys.bastion_key.key_name
    associate_public_ip_address = true

    tags = {
        Name = "Bastion_host"
    }
}

resource "aws_instance" "ec2_primary" {
    ami = var.ami
    instance_type = var.instance_type
    availability_zone = "eu-west-2a"
    subnet_id = aws_subnet.private_subnet_a.id 
    vpc_security_group_ids = [aws_security_group.ec2_private_sg.id]
    key_name = local.keys.ec2_key1.key_name
    associate_public_ip_address = false
    user_data = <<-EOF
    #!/bin/bash
    yum update -y
    sudo dnf install -y postgresql17
    echo "<h1>Hello, World from $(hostname -f)</h1>" > /var/www/html/index.html
    EOF

    tags = {
        Name = "ec2_primary_az1"
    }
}
resource "aws_instance" "ec2_secondary" {
    ami = var.ami
    instance_type = var.instance_type
    associate_public_ip_address = false
    availability_zone = "eu-west-2b"
    subnet_id = aws_subnet.private_subnet_b.id
    vpc_security_group_ids = [aws_security_group.ec2_private_sg.id]
    key_name = local.keys.ec2_key2.key_name
    user_data = <<-EOF
    #!/bin/bash
    yum update -y
    sudo dnf install -y postgresql17
    echo "<h1>Hello, World from $(hostname -f)</h1>" > /var/www/html/index.html
    EOF

    tags = {
        Name = "ec2_secondary_az2"
    }
}

resource "aws_security_group" "ec2_private_sg" {
    name = "ec2_private_sg"
    vpc_id = aws_vpc.vpc_task.id
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        security_groups = [aws_security_group.bastion_sg.id]
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups = [aws_security_group.alb_sg.id]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "ec2_private_sg"
    }

}

resource "aws_security_group" "bastion_sg" {
    name = "bastion_sg"
    vpc_id = aws_vpc.vpc_task.id
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "bastion_sg"
    }
}
