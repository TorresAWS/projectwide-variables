terraform {
    backend "s3" {
        key = "storage-www/storage-www.tfstate"
        region = "us-east-1"
        profile  = "Infrastructure"
    }
}
