# GuardDuty
This terraform script will enable GuardDuty monitoring in the following regions:
- us-east-2
- us-east-1
- us-west-1
- us-west-2
- af-south-1
- ap-east-1
- ap-south-1
- ap-northeast-3
- ap-northeast-2
- ap-southeast-2
- ap-northeast-1
- ca-central-1
- eu-central-1
- eu-west-1
- eu-west-2
- eu-west-3
- eu-north-1
- sa-east-1

Reference: https://docs.aws.amazon.com/guardduty/latest/ug/guardduty_regions.html

Some regions are not available in our AWS accounts. 
As such, the terraform script does not include enabling of GuardDuty in them:
- us-gov-east-1
- us-gov-west-1
- me-south-1
- eu-south-1
- ap-southeast-3

Notes:
- As of this moment (May 17), there is no support for variable interpolation in the Provider argument. As such, there is no way to make this script dry yet.
- Reference: 
- It might be possible to make this code dry with the use of Terragrunt.  
