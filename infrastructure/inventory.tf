######## transfer the outputs to an ansible inventory TEMPLATE ########
####### used the example: https://discuss.hashicorp.com/t/terraform-to-dynamically-produce-ansible-inventory/45368

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/../templates/inventory.tpl",
    {
      bastion_ip      = aws_instance.Bastion_host.public_ip
      ec2_primary     = aws_instance.ec2_primary.private_ip
      ec2_secondary   = aws_instance.ec2_secondary.private_ip
      db_endpoint     = aws_db_instance.db_postgres.endpoint
      db_user         = var.db_user
      db_password     = var.db_password
      db_port         = aws_db_instance.db_postgres.port
      db_name         = aws_db_instance.db_postgres.db_name

    }
  )
  filename = "${path.module}/../ansible/inventory.ini"
}