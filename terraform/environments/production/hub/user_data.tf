data "template_file" "container-platform-data" {
    template = file("user_data.sh")
    vars = {
        environment         = local.environment_short
        registry_name       = var.registry_name
        bucket_name         = local.s3_config_bucket_name
    }
}