# We usually put variables inside the local block
#locals {
#  name          = "openvpn"
#  environment   = "test"
#  aws_region    = "ap-southeast-1"
#  vpc_id        = "vpc-0a607890e803f9266"
#  image_id      = "ami-064bdd7eebf57af65"
#  instance_type = "t3.medium"
#  team          = "kdp"
#  custom_tags = {
#    terraform   = "true"
#    environment = "${local.environment}"
#    team        = "${local.team}"
#  }
#
#}


#module "openvpn" {
#  source        = "../../modules/openvpn/" #make this more appropriate path
#  name          = local.name
#  environment   = local.environment
#  vpc_id        = local.vpc_id
#  image_id      = local.image_id
#  instance_type = local.instance_type
#  team          = local.team
#  custom_tags   = local.custom_tags
#}


