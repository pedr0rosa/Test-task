resource "aws_lb" "alb_pub" {
    name = "my-alb"
    load_balancer_type = "application"
    security_groups = [aws_security_group.alb_sg.id]
    subnets = [aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_b.id, aws_subnet.public_subnet_c.id]
    tags = {
        Name = "alb_pub"
    }
}


resource "aws_security_group" "alb_sg" {
    name = "alb-sg"
    description = "ALB sg allow HTTP"
    vpc_id = aws_vpc.vpc_task.id

    ingress {
        description = "HTTP"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "HTTPS"
        from_port = 443
        to_port = 443
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
        Name = "alb_sg"
    }

}

resource "aws_lb_listener" "alb_listener_http" {
    load_balancer_arn = aws_lb.alb_pub.arn
    port = 80
    protocol = "HTTP"

    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.my_target_group.arn
    }

    tags = {
        Name = "alb_listener_http"
    }
}
/* 
 resource "aws_lb_listener" "alb_listener_https" {
    load_balancer_arn = aws_lb.alb_pub.arn
    port = 443
    protocol = "HTTPS"

    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.my_target_group.arn
    }

    tags = {
        Name = "alb_listener_https"
    }
} */

resource "aws_lb_target_group" "my_target_group" {
    name = "my-target-group"
    target_type = "instance"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.vpc_task.id
    health_check {
        enabled = true
        #used when there is httpd server
        #path = "/"
        path = "/health"
        protocol = "HTTP"
        matcher = "200"
        interval = 30
        timeout = 3
    }
}

/* resource "aws_lb_listener_certificate" "ACM_certificate_attach" {
    listener_arn = aws_lb_listener.alb_pub_listener.arn
    certificate_arn = aws_acm_certificate.SSL_certificate.arn
} */

resource "aws_lb_target_group_attachment" "ec2_primary_attach" {
  target_group_arn = aws_lb_target_group.my_target_group.arn
  target_id        = aws_instance.ec2_primary.id
  port             = 80
}
resource "aws_lb_target_group_attachment" "ec2_secondary_attach" {
  target_group_arn = aws_lb_target_group.my_target_group.arn
  target_id        = aws_instance.ec2_secondary.id
  port             = 80
}