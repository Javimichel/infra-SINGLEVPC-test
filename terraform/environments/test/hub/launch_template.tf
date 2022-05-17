resource "aws_launch_template" "container-platform-lt" {
    name = "test-container-platform-${var.registry_name}-${local.environment_short}"
    disable_api_termination = false
    ebs_optimized           = true
    image_id                = var.aws_ami
    instance_type           = var.instance_type
    key_name                = var.key_name
    user_data               = base64encode(data.template_file.container-platform-data.rendered)

    iam_instance_profile {
        arn = var.iam_instance_profile
    }

    monitoring {
        enabled = true
    }

    # TODO: The current subnets ("subnet-22c15f7a", "subnet-6ddf9e1b", "subnet-84b5ffb9", "subnet-be4cda94") are
    # all in different AZ and private. We should, in the future, move to a 2public, 2private subnets scheme (or 
    # add 4 more subnets, one on each AZ to match these ones, and add a NAT gateway there t enable outbound internet
    # access). 
    # In the meantime, we choose to use the same solution as the legacy one: attaching a public IP to each instance.
    network_interfaces {
      associate_public_ip_address = true
      security_groups = var.instance_security_groups
    }

    tag_specifications {
        resource_type = "volume"

        tags = {
          Initiative = "container-platform"
          Name = "test-container-platform-${var.registry_name}"
          RegistryName = var.registry_name
          Environment = local.environment
        }
      }
}
