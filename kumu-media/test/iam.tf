module "efs_policy" {
  source      = "../../modules/iam/policies"
  policy_name = "AmazonEKS-EFS-CSI-Driver-Policy-${local.environment}"
  path        = "/"
  description = "Allows the CSI driver's service account to make calls to AWS APIs"
  tags = {
    Terraform = "true"
  }

  policy = <<-EOF
  {
      "Version": "2012-10-17",
      "Statement": [
          {
              "Sid": "EFSCreateAccessPointPermission",
              "Effect": "Allow",
              "Action": [
                  "elasticfilesystem:CreateAccessPoint"
              ],
              "Resource": "*",
              "Condition": {
                  "StringLike": {
                      "aws:RequestTag/efs.csi.aws.com/cluster": "true"
                  }
              }
          },
          {
              "Sid": "EFSDeleteAccessPointPermission",
              "Effect": "Allow",
              "Action": [
                  "elasticfilesystem:DeleteAccessPoint"
              ],
              "Resource": "*",
              "Condition": {
                  "StringLike": {
                       "aws:ResourceTag/efs.csi.aws.com/cluster": "true"
                  }
              }
          },
          {
              "Sid": "EFSPermissions",
              "Effect": "Allow",
              "Action": [
                  "elasticfilesystem:DescribeMountTargets",
                  "elasticfilesystem:DescribeAccessPoints",
                  "elasticfilesystem:DescribeFileSystems"
              ],
              "Resource": "*"
          },
          {
              "Sid": "Stmt1AddtionalEC2PermissionsForConsole",
              "Effect": "Allow",
              "Action": [
                  "ec2:DescribeAvailabilityZones",
                  "ec2:DescribeSecurityGroups",
                  "ec2:DescribeVpcs",
                  "ec2:DescribeVpcAttribute"
              ],
              "Resource": "*"
          },
          {
              "Sid": "Stmt2AdditionalKMSPermissionsForConsole",
              "Effect": "Allow",
              "Action": [
                  "kms:ListAliases",
                  "kms:DescribeKey"
              ],
              "Resource": "*"
          }
      ]
  }
    EOF
}

module "efs_role" {
  source             = "../../modules/iam/roles"
  role_name          = "AmazonEKS-EFS-CSI-DriverRole-${local.environment}"
  assume_role_policy = <<-EOF
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Principal": {
                    "Federated": "arn:aws:iam::${data.aws_caller_identity.current.id}:oidc-provider/${module.aws_eks.eks_oidc_provider}"
                },
                "Action": "sts:AssumeRoleWithWebIdentity",
                "Condition": {
                    "StringEquals": {
                        "${module.aws_eks.eks_oidc_provider}:sub": "system:serviceaccount:kube-system:efs-csi-controller-sa"
                    }
                }
            }
        ]
    }
    EOF

  existing_policy_arn = module.efs_policy.arn

}
