terraform {
  required_version = ">=0.12.0"
  backend "s3" {
    key            = "infra/terraform.state"
    bucket         = "baliketech"
    region         = "us-east-1"
    dynamodb_table = "dynamo_baliketech"
  }
}
