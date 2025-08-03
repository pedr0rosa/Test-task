
resource "local_file" "app_tests" {
  content = templatefile("${path.module}/../templates/app_tests.tpl", {alb_dns = aws_lb.alb_pub.dns_name})
  filename = "${path.module}/../app_tests.sh"
  file_permission = "0755"

    provisioner "local-exec" {
    when    = destroy
    command = "rm -f ${self.filename}"
  }
}