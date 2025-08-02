output db_password {
  value       = "${var.db_password}"
}

output db_user {
  value       = "${var.db_user}"
}

output db_endpoint {
  value       = "${aws_db_instance.db_postgres.endpoint}"
}

output db_name {
  value       = "${aws_db_instance.db_postgres.db_name}"
}

output db_port {
  value       = "${aws_db_instance.db_postgres.port}"
}

output alb_dns {
  value       = "${aws_lb.alb_pub.dns_name}"
}

output ec2_primary_ip {
  value       = "${aws_instance.ec2_primary.private_ip}"
}

output ec2_secondary_ip {
  value       = "${aws_instance.ec2_secondary.private_ip}"
}

output bastion_ip {
  value       = "${aws_instance.Bastion_host.public_ip}"
}

 output public_key1_ec2 {
    value       = tls_private_key.keys["ec2_key1"].public_key_openssh
}

output public_key2_ec2 {
    value       = tls_private_key.keys["ec2_key2"].public_key_openssh
}

output "public_key_bastion" {
    value       = tls_private_key.keys["bastion_key"].public_key_openssh
}


