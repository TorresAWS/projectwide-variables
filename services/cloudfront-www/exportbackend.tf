data "terraform_remote_state" "zones" {
   backend = "s3"
   config = {
        key = "vpcs/zone/zone.tfstate"
        region = "us-east-1"
        profile  = "Infrastructure"
        bucket  = "tfstate03312025"
   }
}
data "terraform_remote_state" "storage" {
   backend = "s3"
   config = {
        key = "storage-www/storage-www.tfstate"
        region = "us-east-1"
        profile  = "Infrastructure"
        bucket  = "tfstate03312025"
   }
}
data "terraform_remote_state" "certs" {
   backend = "s3"
   config = {
        key = "vpcs/certs/certs.tfstate"
        region = "us-east-1"
        profile  = "Infrastructure"
        bucket  = "tfstate03312025"
   }
}

data "terraform_remote_state" "variables" {
   backend = "s3"
   config = {
        key = "global/variables/variables.tfstate"
        region = "us-east-1"
        profile  = "Infrastructure"
        bucket  = "tfstate03312025"
   }
}
