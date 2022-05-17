resource "aws_elb" "container-platform-elb" {
    name     = "container-platform-${var.registry_name}-${local.environment_short}"
    internal        = true
    security_groups = var.elb_security_groups
    subnets         = var.vpc_public_subnets

    listener {
        instance_port     = 5000
        instance_protocol = "http"
        lb_port           = 5000
        lb_protocol       = "http"
    }

    listener {
        instance_port      = 5000
        instance_protocol  = "http"
        lb_port            = 443
        lb_protocol        = "https"
        ssl_certificate_id = "arn:aws:acm:us-east-1:736370371722:certificate/3cfc4302-4284-445e-9be2-3a4963461542" # Expires June 2022
    }    
    
    health_check {
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout             = 4
        interval            = 5
        target              = "HTTP:5000/v2/"
    }

    tags = {
        Name           = "container-platform-${var.registry_name}-${local.environment_short}"
        Initiative     = "container-platform"
        Tool           = "terraform"
        RegistryName   = var.registry_name
        Environment    = local.environment_short
    }
}