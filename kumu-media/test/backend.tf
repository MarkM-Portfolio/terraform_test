terraform {
  backend "s3" {
    bucket         = "kumu-terraform-states"
    key            = "kumu-media/kumu-media-test-eks.tfstate" #####change this per project. kumu-media/<tenant>-<env>-<type>.tfstate
    region         = "ap-southeast-1"
    dynamodb_table = "kumu-terraform-state-locks"
    role_arn       = "arn:aws:iam::336468631963:role/s3-terraform-state"
  }
}