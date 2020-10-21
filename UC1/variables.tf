#General vars

variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {
  default = "eu-west-1"
}

variable "path_to_private_key" {}
variable "path_to_public_key" {}

#Webserver vars
variable "ami" {}
variable "instance_type" {}
variable "instance_username" {}

#Network vars
variable "availability_zone" {}

##################
#variable "route53_hosted_zone_name" {}
# variable "AMIS" {
#   type = "map"
#   default = {
#     us-east-1 = "ami"
#     eu-west-1 = "ami"
#     eu-west-2 = "ami"
#   }
# }
