######## transfer the outputs to an ansible inventory TEMPLATE ########
####### used the example: https://discuss.hashicorp.com/t/terraform-to-dynamically-produce-ansible-inventory/45368

resource "local_file" "db_credentials" {
  content = templatefile("${path.module}/../templates/db_credentials.tpl", {
    db_user     = var.db_user
    db_password = var.db_password
    db_endpoint = aws_db_instance.db_postgres.endpoint
    db_port     = aws_db_instance.db_postgres.port
    db_name     = aws_db_instance.db_postgres.db_name  # Make sure this is set in your RDS resource
  })
  filename = "${path.module}/../application/db_credentials.py"
}