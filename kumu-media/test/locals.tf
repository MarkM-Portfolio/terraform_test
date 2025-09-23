##MAKE SURE TO EDIT BACKEND.TF AS WELL DEPENDING ON THE ENVIRONMENT.

locals {
  environment  = "test"
  tenant       = "kumu-media"
  eks_version  = "1.21"
  cluster_name = join("-", [local.tenant, local.environment, "eks"])

  #### VPC SECTION ####
  create_vpc = false #set to false if the VPC is already created
  ###If existing, enter the existing values. If not, enter the new values and they will be created. 
  vpc_cidr = "172.31.0.0/16" ##enter here the existing VPC cidr if create_vpc = false. Otherwise, it will create it when create_vpc is true.
  vpc_id   = "vpc-0a607890e803f9266"
  ##If create_vpc is true, these subnets will be created. if false, these values will be ignored.
  private_subnets = [for i in range(2, 5, 1) : cidrsubnet(local.vpc_cidr, 4, i)]
  public_subnets  = [for i in range(1, 4, 1) : cidrsubnet(local.vpc_cidr, 8, i)]
  #If create_vpc is true, these values will not be read. If create_vpc is false , enter here the existing subnets
  private_subnet_ids = ["subnet-0c427b4619b853ab5", "subnet-070c857e9153a82f9", "subnet-019a76b713b4494f8"]
  public_subnet_ids  = ["subnet-03c4dc57d2d02e74c", "subnet-08bfae19014bed187", "subnet-042bfee6d76e4d0df"]
  eks_private_access = "false"

  ##### Existing Security Groups #####
  rds_security_group_id        = "sg-023c3ec0aef150e16"
  redis_security_group_id      = "sg-08d3bfe984d38853e"
  opensearch_security_group_id = "sg-0b1330228c573dfac"

  ##### Node group defaults ####
  disk_size_default      = 150
  ami_type_default       = "AL2_ARM_64" #[AL2_x86_64 AL2_x86_64_GPU AL2_ARM_64 CUSTOM BOTTLEROCKET_ARM_64 BOTTLEROCKET_x86_64]
  instance_types_default = ["t4g.2xlarge"]
  instance_types         = ["t4g.2xlarge"] #Use this to modify instance type of worker nodes
  ssh_key_name           = ""

  ##### Number of nodes #####
  max_size     = 10
  min_size     = 10
  desired_size = 10

  block_device_mappings = {
    xvda = {
      device_name = "/dev/xvda"
      ebs = {
        volume_size = 150
        volume_type = "gp3"
        iops        = 3000
        throughput  = 150
        #encrypted             = true
        #kms_key_id            = data.aws_kms_key.ebs.arn
        delete_on_termination = true
      }
    }
  }

  github_repo = "terraform"
  github_org  = "kumu-media"

  rancher_hostname = "rancher-${local.environment}.kumuapi.com"

  regional_certificate_arn = "arn:aws:acm:ap-southeast-1:${data.aws_caller_identity.current.id}:certificate/8f5b9512-455b-472e-abd1-b5e84c61bd29" #edit this
  domain_name              = "${local.tenant}-${local.environment}.kumuapi.com"
  ec2_server_url           = "https://dev-api-ec2.kumuapi.com"

  aws_users = [
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.id}:user/eziera.gabriel@kumu.ph"
      username = "eziera.gabriel@kumu.ph"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.id}:user/adrian.adriano@kumu.ph"
      username = "adrian.adriano@kumu.ph"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.id}:user/george.delacruz@kumu.ph"
      username = "george.delacruz@kumu.ph"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.id}:user/christian.riosa@kumu.ph"
      username = "christian.riosa@kumu.ph"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.id}:user/jericko.tejido@kumu.ph"
      username = "jericko.tejido@kumu.ph"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.id}:user/bernadette.sable@kumu.ph"
      username = "bernadette.sable@kumu.ph"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.id}:user/tony@kumu.ph"
      username = "tony@kumu.ph"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.id}:user/renz.moreno@kumu.ph"
      username = "renz.moreno@kumu.ph"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.id}:user/mark.monteros@kumu.ph"
      username = "mark.monteros@kumu.ph"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.id}:user/kristofferson.gica@kumu.ph"
      username = "kristofferson.gica@kumu.ph"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.id}:user/deven.bhooshan@kumu.ph"
      username = "deven.bhooshan@kumu.ph"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.id}:user/john.ibanez@kumu.ph"
      username = "john.ibanez@kumu.ph"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.id}:user/kemuel@kumu.ph"
      username = "kemuel@kumu.ph"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.id}:user/redan@kumu.ph"
      username = "redan@kumu.ph"
      groups   = ["system:masters"]
    }
  ]


  #### EFS Configuration ####

  efs_name         = join("-", [local.tenant, local.environment, "nacos-efs"])
  encrypted        = true
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"

  security_group_ingress = {
    default = {
      description = "Terraform created rule for NFS Inbound"
      from_port   = 2049
      protocol    = "tcp"
      to_port     = 2049
      self        = true
      cidr_blocks = ["10.20.0.0/16"]
    }
  }

  #### end of EFS configuration ####
}

# locals {
#   api_gateways_v2 = {
#     ####copy this part###
#     api-creator-dist-kumu-live = {                                                                                    #identifier only
#       name               = "api-creator-dist-kumu-live-v2"                                                            #name of API
#       openapi_config     = "api-creator-dist-kumu-live.yaml"                                                          #filename of the openapi config
#       custom_domain_name = "dev-ssr.kumu.live"                                                                        #Custom URL of API Gateway
#       acm_arn            = "arn:aws:acm:ap-southeast-1:222029663836:certificate/47cc7d0e-c4e7-474f-a0fb-acf656d51c81" #ACM for the Custom URL
#       endpoint_config    = "REGIONAL"
#     }
#     ####until this part####
#     ####copy this part###
#     api-kumuapi = {                                       #identifier only
#       name               = "api-kumuapi"                  #name of API
#       openapi_config     = "api-kumuapi.yaml"             #filename of the openapi config
#       custom_domain_name = "dev-api.kumuapi.com"          #Custom URL of API Gateway
#       acm_arn            = local.regional_certificate_arn #ACM for the Custom URL
#       endpoint_config    = "EDGE"
#     }
#     ####until this part####
#     ####copy this part###
#     api-kumu-live = {                                                                                                 #identifier only
#       name               = "api-kumu-live-v2"                                                                         #name of API
#       openapi_config     = "api-kumu-live.yaml"                                                                       #filename of the openapi config
#       custom_domain_name = "dev-liveapi.kumu.live"                                                                    #Custom URL of API Gateway
#       acm_arn            = "arn:aws:acm:ap-southeast-1:222029663836:certificate/47cc7d0e-c4e7-474f-a0fb-acf656d51c81" #ACM for the Custom URL
#       endpoint_config    = "REGIONAL"
#     }
#     ####until this part####
#     ####copy this part###
#     api-kumu-live-8-test = {                                                                                          #identifier only
#       name               = "api-kumu-live-8-test-v2"                                                                  #name of API
#       openapi_config     = "api-kumu-live-8-test.yaml"                                                                #filename of the openapi config
#       custom_domain_name = "dev-liveapi-v8.kumu.live"                                                                 #Custom URL of API Gateway
#       acm_arn            = "arn:aws:acm:ap-southeast-1:222029663836:certificate/47cc7d0e-c4e7-474f-a0fb-acf656d51c81" #ACM for the Custom URL
#       endpoint_config    = "REGIONAL"
#     }
#     ####until this part####
#     ####copy this part###
#     api-payments = {                                                                                                  #  identifier only
#       name               = "api-payments-v2"                                                                          #name of API
#       openapi_config     = "api-payments.yaml"                                                                        #filename of the openapi config
#       custom_domain_name = "dev.payments.kumuapi.com"                                                                 #Custom URL of API Gateway
#       acm_arn            = "arn:aws:acm:ap-southeast-1:222029663836:certificate/bd817438-67ae-4981-9027-2009652de007" #ACM for the Custom URL
#       endpoint_config    = "REGIONAL"
#     }
#     ####until this part####
#     ####copy this part###
#     api-targeted-vg = {                                      #  identifier only
#       name               = "api-targeted-vg-v2"              #name of API
#       openapi_config     = "api-targeted-vg.yaml"            #filename of the openapi config
#       custom_domain_name = "api-targeted-vg-dev.kumuapi.com" #Custom URL of API Gateway
#       acm_arn            = local.regional_certificate_arn    #ACM for the Custom URL
#       endpoint_config    = "REGIONAL"
#     }
#     ####until this part####
#     ####copy this part###
#     segment-tracker = {                                      #  identifier only
#       name               = "segment-tracker-v2"              #name of API
#       openapi_config     = "segment-tracker.yaml"            #filename of the openapi config
#       custom_domain_name = "segment-tracker-dev.kumuapi.com" #Custom URL of API Gateway
#       acm_arn            = local.regional_certificate_arn    #ACM for the Custom URL
#       endpoint_config    = "REGIONAL"
#     }
#     ####until this part####
#     ####copy this part###
#     sso-service = {                                       #  identifier only
#       name               = "sso-service-v2"               #name of API
#       openapi_config     = "sso-service.yaml"             #filename of the openapi config
#       custom_domain_name = "sso-service-dev.kumuapi.com"  #Custom URL of API Gateway
#       acm_arn            = local.regional_certificate_arn #ACM for the Custom URL
#       endpoint_config    = "REGIONAL"
#     }
#     ####until this part####
#   }
# }