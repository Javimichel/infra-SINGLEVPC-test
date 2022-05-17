resource "aws_autoscaling_group" "container-platform-asg" {
    name                      = "test-container-platform-${var.registry_name}-${local.environment_short}"
    desired_capacity          = 2
    max_size                  = 4
    min_size                  = 1
    wait_for_elb_capacity     = 1
    health_check_grace_period = 300
    health_check_type         = "ELB"
    load_balancers            = [aws_elb.container-platform-elb.name]
    vpc_zone_identifier       = var.vpc_private_subnets
    enabled_metrics = [ "GroupMaxSize", "GroupDesiredCapacity", "GroupPendingInstances", "GroupStandbyInstances", 
                        "GroupTerminatingInstances", "GroupTotalInstances", "GroupMinSize", "GroupInServiceInstances" ]

    launch_template {
        id      = aws_launch_template.container-platform-lt.id
        version = aws_launch_template.container-platform-lt.latest_version
    }

    tag {
        key                 = "Name"
        value               = "test-container-platform-${var.registry_name}-${local.environment_short}"
        propagate_at_launch = true
    }

    tag {
        key                 = "Initiative"
        value               = "container-platform"
        propagate_at_launch = true
    }

    tag {
        key                 = "Tool"
        value               = "terraform"
        propagate_at_launch = true
    }

    tag {
        key                 = "RepositoryType"
        value               = var.registry_name
        propagate_at_launch = true
    }

    tag {
        key                 = "Environment"
        value               = local.environment_short
        propagate_at_launch = true
    }
}
