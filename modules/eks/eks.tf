module "eks" {
  #depends on = var.create_vpc_in == "true" ? [module.vpc] : [var.vpc_cidr_in]
  source  = "registry.terraform.io/terraform-aws-modules/eks/aws"
  version = "18.20.1"

  cluster_name                    = local.cluster_name
  cluster_version                 = var.eks_version_in
  cluster_endpoint_private_access = var.eks_private_access_in
  cluster_endpoint_public_access  = var.eks_private_access_in == "true" ? "false" : "true"
  enable_irsa                     = true

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {
    }
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
    
  }

  vpc_id     = local.eks_vpc_id
  subnet_ids = var.create_vpc_in == true ? module.vpc.private_subnets : var.private_subnet_ids_in

  manage_aws_auth_configmap = true

  aws_auth_users = var.aws_users_in

  # Extend cluster security group rules
  cluster_security_group_additional_rules = {
    admin_access = {
      description = "Admin ingress to Kubernetes API"
      cidr_blocks = ["0.0.0.0/0"]
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      type        = "ingress"
    }
    ingress_nodes_karpenter_ports_tcp = {
      description                = "Karpenter readiness"
      protocol                   = "tcp"
      from_port                  = 8443
      to_port                    = 8443
      type                       = "ingress"
      source_node_security_group = true
    }
  }

  # Extend node-to-node security group rules
  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
    aws_lb_controller_webhook = {
      description                   = "Cluster API to AWS LB Controller webhook"
      protocol                      = "all"
      from_port                     = 9443
      to_port                       = 9443
      type                          = "ingress"
      source_cluster_security_group = true
    }
  }

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    ami_type       = var.ami_type_default_in
    instance_types = var.instance_types_default_in # this will create two node groups as default
    # vpc_security_group_ids = [aws_security_group.additional.id] # if you want to add additional security groups
  }

  ###This section can be non-dynamic as discussed. For future improvements
  eks_managed_node_groups = {
    (local.nodegroup_name) = {
      min_size     = var.min_size_in
      max_size     = var.max_size_in
      desired_size = var.desired_size_in

      #### Make this variable
      #instance_types = ["t4g.2xlarge"] #var.instance_types_in
      instance_types = var.instance_types_in
      capacity_type  = "ON_DEMAND"
      labels = {
        Environment = var.environment_in
        GithubRepo  = "terraform-aws"
        GithubOrg   = "kumu-media"
      }

      key_name = var.ssh_key_name_in

      ##### make this part variable
      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size = 150
            volume_type = "gp3"
            iops        = 3000
            throughput  = 150
            #            encrypted             = true
            #            kms_key_id            = data.aws_kms_key.ebs.arn
            delete_on_termination = true
          }
        }
      }

      block_device_mappings = var.block_device_mappings_in

      tags = {
        environment = var.environment_in
        type        = "application"
        "karpenter.sh/discovery" = local.cluster_name
      }
    }
  }
}

