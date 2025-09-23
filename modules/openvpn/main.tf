locals {
  security_group_ingress = {
    default = {
      description = "Terraform created rule for NFS Inbound"
      from_port   = 2049
      protocol    = "tcp"
      to_port     = 2049
      self        = true
      cidr_blocks = [data.aws_vpc.this.cidr_block]
    }
  }

}

# get AWS managed kms of EFS
data "aws_kms_key" "this" {
  key_id = "alias/aws/elasticfilesystem"
}

data "aws_vpc" "this" {
  id = var.vpc_id
}

data "aws_subnets" "this" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

data "aws_subnet" "this" {
  for_each = toset(data.aws_subnets.this.ids)
  id       = each.value
}

resource "tls_private_key" "this" {
  algorithm = "ED25519"
}

resource "aws_key_pair" "this" {
  key_name   = "${var.name}-${var.team}-${var.environment}-keypair"
  public_key = trimspace(tls_private_key.this.public_key_openssh)
}

resource "aws_eip" "this" {
  # instance = aws_instance.web.id
  vpc  = true
  tags = merge({ "Name" = "openvpn-eip" }, var.custom_tags)
}

resource "aws_placement_group" "this" {
  name     = "${var.name}-${var.team}-${var.environment}-placementgroup"
  strategy = var.strategy
  tags     = var.custom_tags
}

resource "aws_security_group" "this" {
  name        = "${var.name}-${var.team}-${var.environment}-sg"
  description = "Allow Openvpn required ports"
  vpc_id      = var.vpc_id

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "openvpn-1194-udp"
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    #    self = true
    #    ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  ingress {
    description = "efs-port"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = var.custom_tags
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.name}-${var.team}-${var.environment}-profile"
  role = aws_iam_role.this.name
}

resource "aws_iam_role" "this" {
  name = "${var.name}-${var.team}-${var.environment}-role"
  path = "/"
  inline_policy {
    name = "${var.name}-${var.team}-${var.environment}-policy"

    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    { 
      "Sid": "Stmt1656814613134",
      "Action": [
        "ec2:AssociateAddress",
        "ec2:DescribeAddresses",
        "ec2:DescribeAddressesAttribute"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF

  }
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_launch_configuration" "this" {
  name_prefix          = "${var.name}-${var.team}-${var.environment}-launch-conf-"
  image_id             = var.image_id
  instance_type        = var.instance_type
  key_name             = aws_key_pair.this.key_name
  security_groups      = [aws_security_group.this.id]
  iam_instance_profile = aws_iam_instance_profile.this.name

  lifecycle {
    create_before_destroy = true
  }

  # user_data script to update openvpn config during lunch
  user_data = <<-EOF
    #!/bin/bash

    # Allocate static EIP
    curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/
    _INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)
    echo $_INSTANCE_ID
    aws ec2 associate-address --region ${var.region} --instance-id $_INSTANCE_ID --allocation-id ${aws_eip.this.allocation_id}


    # create clients ovpn files directory
    mkdir /root/ovpn_files
   
    # create mount point for openvpn
    sudo mkdir ${var.efs_mountpoint}
    sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${module.efs.efs_dns_name}:/ ${var.efs_mountpoint}
    
    # Add /etc/fstab entry for automounting during restart 
    echo "${module.efs.efs_dns_name}:/ ${var.efs_mountpoint} nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport,_netdev 0 0" >> /etc/fstab

    # create a cronjob that will sync local openvpn files to efs.
    crontab -l | { cat; echo "*/30 * * * *  rsync -a /etc/openvpn/ /efs/openvpn"; } | crontab -
    
    # --delete will ensure that what ever is deleted under /root/ovpn_files will be delete also on /efs
    crontab -l | { cat; echo "*/30 * * * *  rsync -a --delete /root/ovpn_files/ /efs/ovpn_files"; } | crontab -

    # backup efs files once a day
    crontab -l | { cat; echo "* 0 * * * bash /root/backup-script.sh"; } | crontab -


    # install openvpn
    sudo /root/install-openvpn.sh
    sudo systemctl enable openvpn
    sudo systemctl start openvpn

    # if openvpn files are present in the /efs folder. overwrite the local server files
    # as well as update the local private IP to what is curretly set on the ec2
    if [ -d "/efs/openvpn" ] && [ -d "/efs/ovpn_files" ]
    then
      _ACTUAL_PRIVATE_LOCAL_IP=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/local-ipv4)
      _CURRENT_PRIVATE_IP=$(cat /efs/openvpn/server/server.conf | grep 'local ')
      sed -i "s/$_CURRENT_PRIVATE_IP/local $_ACTUAL_PRIVATE_LOCAL_IP/g" /efs/openvpn/server/server.conf

      cp -r /efs/openvpn /etc/
      cp -r /efs/ovpn_files /root/
    fi
      
    # During my tests, For openvpn to work. it has to be restarted once.
    # Note that I've tried stopping, restaring and disabling the service but it does not work. It has to be restarted 
    reboot
  EOF

}

resource "aws_autoscaling_group" "this" {
  name                 = "${var.name}-${var.team}-${var.environment}-asg"
  max_size             = var.max_size
  min_size             = var.min_size
  desired_capacity     = var.desired_capacity
  placement_group      = aws_placement_group.this.id
  launch_configuration = aws_launch_configuration.this.name
  vpc_zone_identifier  = data.aws_subnets.this.ids

  instance_refresh {
    strategy = "Rolling"
    triggers = ["launch_configuration"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "${var.name}-${var.team}-${var.environment}"
    propagate_at_launch = true

  }

  dynamic "tag" {
    for_each = var.custom_tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

}


## EFS 
module "efs" {
  source                 = "../efs/"
  efs_name               = "efs-${var.name}-${var.team}-${var.environment}"
  environment            = var.environment
  tags                   = var.custom_tags
  vpc_id                 = var.vpc_id
  subnet_id              = data.aws_subnets.this.ids
  kms_key_id             = data.aws_kms_key.this.arn
  security_group_ingress = local.security_group_ingress
}
