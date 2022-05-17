####################
#   Networking (VPC / Subnets / Route tables)
####################

// The VPC containing ALL these resources
variable "vpc" {
  description = "VPC"
  type        = string
  default = "vpc-d74e4eb2"    //fury-core
}

// In a normal install, ELBs would be in a public subnet, but hub.furycloud.io uses an intenal ELB
variable "vpc_public_subnets" {
  description = "VPC public subnets"
  type        = list(string)
  default = ["subnet-22c15f7a", "subnet-6ddf9e1b", "subnet-84b5ffb9", "subnet-be4cda94"]
}

// Private subnets for all instances
variable "vpc_private_subnets" {
  description = "VPC private subnets"
  type        = list(string)
  default = [ "subnet-22c15f7a", "subnet-6ddf9e1b", "subnet-84b5ffb9", "subnet-be4cda94" ]
}

####################
#     SECURITY GROUPS
####################
variable "elb_security_groups" {
  type    = list(string)
  default = ["sg-d9f1f3a1"]     //fury-hub-LoadBalancerSecurityGroup-AAFJIT8E8Q4C
}

variable "instance_security_groups" {
  type    = list(string)
  default = ["sg-e3f1f39b"]     //fury-hub-ServersSecurityGroup-VOWZG4OGQLHD
}

####################
#   AMI / Instances
####################
variable "aws_ami" {
  type    = string
  default = "ami-051f5a3dcd64ef153" //container-platform-hub-1645030362
}

variable "instance_type" {
    type = string
    default = "t3.small"
}

// BA key name
variable "key_name" {
  type        = string
  description = "SSH KeyPair"
  default     = "ba"
}

variable "iam_instance_profile" {
    type = string
    default = "arn:aws:iam::736370371722:instance-profile/fury_app"
}

####################
#   STORAGE
####################
variable "s3_bucket_name" {
  type        = string
  default     = "container-platform"
  description = "S3 bucket where all files related to terraform are stored" 
}

####################
#   APP CONFIGS
####################
variable "datadog_api_key" {
  description = "Datadog API key"
  type        = string
}

variable "registry_name" {
  type        = string
  description = "Name of the registry"
}