terraform {
  ## Note: S3 backend with state locking preferred, but the resources need to be created outside of this script. Local is enabled for now.
  ## Buckets containing terraform state should have versioning enabled to allow for easy state recovery.
  # backend s3 {
  # dynamodb_table = "xxx"
  # encrypt        = true
  # key            = "xxx"
  # region         = "xxx"
  # bucket         = "xxx"
  # }
  backend "local" {
  }
}

provider "aws" {
  region = "us-east-1"
}