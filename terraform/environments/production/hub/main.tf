terraform {
  backend "s3" {
    bucket = "fury-container-platform"
    region = "us-east-1"
    key    = "infra/environment/production/hub"
  }
}

provider "aws" {
  region = "us-east-1"
}

locals {
  environment                   = "production"
  environment_short             = substr(local.environment,0,4)
  s3_config_bucket_name          = "fury-container-platform"
}

# Nginx sidecar rules
resource "aws_s3_bucket_object" "nginx-config" {
  bucket  = local.s3_config_bucket_name
  key     = "files/environment/${local.environment_short}/${var.registry_name}/conf/nginx.conf"
  etag    = filemd5("files/nginx.conf")
  content = file("files/nginx.conf")
}

# Registry config
resource "aws_s3_bucket_object" "registry-config" {
  bucket  = local.s3_config_bucket_name
  key     = "files/environment/${local.environment_short}/${var.registry_name}/conf/registry-config.yml"
  etag    = filemd5("files/registry-config.yml")
  content = file("files/registry-config.yml")
}

# Entire docker-compose
resource "aws_s3_bucket_object" "docker-compose" {
  bucket  = local.s3_config_bucket_name
  key     = "files/environment/${local.environment_short}/${var.registry_name}/docker-compose.yml"
  etag    = filemd5("files/docker-compose.yml")
  content = templatefile("files/docker-compose.yml", {
    environment         = local.environment
    registry_name       = var.registry_name
    datadog_api_key     = var.datadog_api_key
  })
}

# Logstash config
resource "aws_s3_bucket_object" "logstash-config-conf" {
  bucket  = local.s3_config_bucket_name
  key     = "files/environment/${local.environment_short}/${var.registry_name}/conf/logstash.conf"
  etag    = filemd5("files/logstash.conf")
  content = templatefile("files/logstash.conf", {
    datadog_api_key     = var.datadog_api_key
  })
}

# Registry config
resource "aws_s3_bucket_object" "logstash-config-yml" {
  bucket  = local.s3_config_bucket_name
  key     = "files/environment/${local.environment_short}/${var.registry_name}/conf/logstash.yml"
  etag    = filemd5("files/logstash.yml")
  content = file("files/logstash.yml")
}

# Logs uploader
resource "aws_s3_bucket_object" "log-uploader" {
  bucket  = local.s3_config_bucket_name
  key     = "files/environment/${local.environment_short}/${var.registry_name}/scripts/upload_logs.sh"
  etag    = filemd5("files/upload_logs.sh")
  content = file("files/upload_logs.sh")
}