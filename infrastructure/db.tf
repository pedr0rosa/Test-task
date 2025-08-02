resource "aws_db_instance" "db_postgres" {
    identifier = "db-postgres"
    db_name = "postgres"
    allocated_storage = 10
    engine = "postgres"
    engine_version = "17.4"
    instance_class = "db.t3.micro"
    username = var.db_user
    password = var.db_password
    skip_final_snapshot = true
    multi_az = true
    publicly_accessible = false
    storage_encrypted = true
    vpc_security_group_ids = [aws_security_group.postgres_sg.id]
    db_subnet_group_name = aws_db_subnet_group.db_subnet_group.id
    tags = {
        Name = "db_postgres"
    }
}

    
resource "aws_db_subnet_group" "db_subnet_group" {
    name = "postgres-subnet-group"
    subnet_ids = [aws_subnet.db_subnet_a.id, aws_subnet.db_subnet_b.id]
    tags = {
        Name = "postgres-subnet-group"
    }
}

resource "aws_security_group" "postgres_sg"{
    name = "postgres-sg"
    vpc_id = aws_vpc.vpc_task.id
    ingress {
        from_port = 5432 #port used by postgres
        to_port = 5432
        protocol = "tcp"
        #check SSL parameters! it was created a certificate by default.
        #self = true
        cidr_blocks = ["0.0.0.0/0"]
        security_groups = [aws_security_group.ec2_private_sg.id]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "postgres-sg"
    }

}

resource "aws_subnet" "db_subnet_a" {
    vpc_id = aws_vpc.vpc_task.id
    availability_zone = "eu-west-2a"
    cidr_block = "10.16.8.0/24"
    tags = {
        Name = "db_subnet_a"
    }
}

resource "aws_subnet" "db_subnet_b" {
    vpc_id = aws_vpc.vpc_task.id
    availability_zone = "eu-west-2b"
    cidr_block = "10.16.9.0/24"
    tags = {
        Name = "db_subnet_b"
    }
}


resource "aws_route_table_association" "rta_private_subneta_db" {
    subnet_id = aws_subnet.db_subnet_a.id
    route_table_id = aws_route_table.db_private_rt.id
}

resource "aws_route_table_association" "rta_private_subnetb_db" {
    subnet_id = aws_subnet.db_subnet_b.id
    route_table_id = aws_route_table.db_private_rt.id
}
