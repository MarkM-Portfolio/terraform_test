# Terraform EKS Cluster Creation
This terraform code will deploy a new EKS cluster.

## Prerequisites
* ACM is already available in the AWS account.

## Deployment

1. Clone this repository
2. If not existing, create a folder for your target environment by duplicating/copying the templates folder.
3. Edit the following files
  - backend.tf - edit "key" . Replace the <name>.tfstate with <tenant>-<env>-<type>.tfstate #this cannot be made variable so need to edit this manually.
  - locals.tf - Jump to configuration section on how to configure locals.tf
4. Set your terminal's AWS_PROFILE variable to your user's IAM profile for the AWS account to allow terraform to use the profile's access credentials.
```
  export AWS_PROFILE=<env>
```
5. Run the following commands
```
terraform init #This will initialize the providers

terraform validate #Check if there's any syntax errors

terraform plan #Check if there are any further errors that need fixing

terraform apply --auto-approve
```

## Notes:

1. For arm64 deployment, the whole argocd is using official arm64 image except its applicationset-controller as of writing (4/20/2021). Make sure to monitor the release of the official arm64 image and use that once available. 
2. This script should support Arm64 and Amd64 deployment.
3. NLB should not have TLS cert for rancher to work.
4. Need to create the corresponding r53 entries in Prod AWS account after
    - nacos
    - rancher
    - argocd
    - api-gateway custom domain
6. Modify configmap/auth-map.kube-system manually to provide cluster access. It is not yet automatically included in the terraform script.
7. Take a look on the following tools. Probably helpful in the future
   - [tflink](https://github.com/terraform-linters/tflint)
   - [checkov](https://github.com/bridgecrewio/checkov/)
   - [terratest ](https://github.com/gruntwork-io/terratest/)
   - [pre-commit-terraform]https://github.com/antonbabenko/pre-commit-terraform()
   - [terraform-docs]()https://github.com/terraform-docs/terraform-docs
  
## Pending:

  1. Documentation
  2. TLS SSL
  3. Argocd dex configuration
  
