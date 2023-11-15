terraform {
  source            = "../../terraform/"
}

remote_state {
  backend = "s3"
  config = {
    encrypt         = true
    bucket          = ""
    key             = ""
    region          = "eu-west-1"

    s3_bucket_tags  = {
      Stack         = "Terraform"
      Maintainer    = "Siarhei Beliakou"
    }
  }
}