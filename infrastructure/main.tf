resource "aws_vpc" "vpc_task" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = {
        Name = "vpc_task"
    }
}

############################################
#rever security groups
############## Security Group ##############
resource "aws_security_group" "vpc_sg" {
    name = "vpc_sg"
    vpc_id = aws_vpc.vpc_task.id
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}



############## Public subnets ##################
resource "aws_subnet" "public_subnet_a" {
    vpc_id = aws_vpc.vpc_task.id
    availability_zone = "eu-west-2a"
    cidr_block = "10.16.1.0/24"
    tags = {
        Name = "public_subnet_a"
    }
}

resource "aws_subnet" "public_subnet_b" {
    vpc_id = aws_vpc.vpc_task.id
    availability_zone = "eu-west-2b"
    cidr_block = "10.16.2.0/24"
    map_public_ip_on_launch = true
    tags = {
        Name = "public_subnet_b"
    }
}

resource "aws_subnet" "public_subnet_c" {
    vpc_id = aws_vpc.vpc_task.id
    availability_zone = "eu-west-2c"
    cidr_block = "10.16.3.0/24"
    tags = {
        Name = "public_subnet_c"
    }
}

############## Private subnets ##################

resource "aws_subnet" "private_subnet_a" {
    vpc_id = aws_vpc.vpc_task.id
    availability_zone = "eu-west-2a"
    cidr_block = "10.16.5.0/24"
    tags = {
        Name = "private_subnet_a"
    }
}

resource "aws_subnet" "private_subnet_b" {
    vpc_id = aws_vpc.vpc_task.id
    availability_zone = "eu-west-2b"
    cidr_block = "10.16.6.0/24"
    tags = {
        Name = "private_subnet_b"
    }
}

resource "aws_subnet" "private_subnet_c" {
    vpc_id = aws_vpc.vpc_task.id
    availability_zone = "eu-west-2c"
    cidr_block = "10.16.7.0/24"
    map_public_ip_on_launch = false
    tags = {
        Name = "private_subnet_c"
    }
}

############## Internet Gateway ##################

resource "aws_internet_gateway" "my_igw" {
    vpc_id = aws_vpc.vpc_task.id
    tags = {
        Name = "my_igw"
    }
}

############## Route Tables ##################

resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.vpc_task.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my_igw.id
    }
    tags = {
        Name = "public_route_table"
    }
}

resource "aws_route_table" "private_route_table" {
    vpc_id = aws_vpc.vpc_task.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat_gateway.id
    }

    tags = {
        Name = "private_route_table"
    }
}

resource "aws_route_table" "db_private_rt" {
    vpc_id = aws_vpc.vpc_task.id

    tags = {
        Name = "db_private_route_table"
    }
}
############## Route Tables Associations - Public ##################


resource "aws_route_table_association" "rta_public_subnet_a" {
    subnet_id = aws_subnet.public_subnet_a.id
    route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "rta_public_subnet_b" {
    subnet_id = aws_subnet.public_subnet_b.id
    route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "rta_public_subnet_c" {
    subnet_id = aws_subnet.public_subnet_c.id
    route_table_id = aws_route_table.public_route_table.id
}

############## Route Tables Associations - Private ##################

resource "aws_route_table_association" "rta_private_subnet_a" {
    subnet_id = aws_subnet.private_subnet_a.id
    route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "rta_private_subnet_b" {
    subnet_id = aws_subnet.private_subnet_b.id
    route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "rta_private_subnet_c" {
    subnet_id = aws_subnet.private_subnet_c.id
    route_table_id = aws_route_table.private_route_table.id
}

############ TO IMPROVE!!!!! ################
########### Generate the key pair for EC2s ############
# all necessary keys
locals {
  keys = {
    ec2_key1 = {
      key_name = "ec2-key1-pair"
      filename = "ec2-key1-pair.pem"
      pub_file = "ec2-key1-public.pub"
    },
    ec2_key2 = {
      key_name = "ec2-key2-pair"
      filename = "ec2-key2-pair.pem"
      pub_file = "ec2-key2-public.pub"
    },
    bastion_key = {
      key_name = "bastion-key-pair"
      filename = "bastion-key-pair.pem"
      pub_file = "bastion-key-pair.pub"
    }
  }
}

# create all keys
resource "tls_private_key" "keys" {
  for_each  = local.keys
  algorithm = "RSA"
  rsa_bits  = 4096
}

/* # clean up all keys when destroying
resource "tls_private_key" "cleanup_example" {
  algorithm = "RSA"
  rsa_bits  = 4096

  provisioner "local-exec" {
    when    = destroy
    command = "rm -f ${var.key_dir}/*"
  }
}
 */
# Criando todos os key pairs na AWS
resource "aws_key_pair" "generated_keys" {
  for_each   = local.keys
  key_name   = each.value.key_name
  public_key = tls_private_key.keys[each.key].public_key_openssh

  # Salvar o key pair localmente
  provisioner "local-exec" {
    command = <<-EOT
      mkdir -p ${var.key_dir}/
      echo '${tls_private_key.keys[each.key].private_key_pem}' > ${var.key_dir}/${each.value.filename}
      chmod 400 ${var.key_dir}/${each.value.filename}
    EOT
  }
}

# Criando arquivos com as chaves públicas
resource "local_file" "public_keys" {
  for_each        = local.keys
  content         = tls_private_key.keys[each.key].public_key_openssh
  filename        = "${var.key_dir}/${each.value.pub_file}"
  file_permission = "0644"
}

########### Elastic IP Address ############

resource "aws_eip" "NAT_eip" {
    domain = "vpc"
    tags = {
        Name = "NAT_eip"
    }
}

############################################

resource "aws_nat_gateway" "nat_gateway" {
    allocation_id = aws_eip.NAT_eip.id
    subnet_id = aws_subnet.public_subnet_a.id
    tags = {
        Name = "nat_gateway"
    }
}





