resource "local_file" "exportbackend-to-services-cloudfront-www" {
    content  = <<EOF
data "terraform_remote_state" "storage" {
   backend = "s3"
   config = {
        key = "storage/storage-www/storage-www.tfstate"
        region = "us-east-1"
        profile  = "Infrastructure"
        bucket  = "${data.terraform_remote_state.variables.outputs.backendname}"
   }
}
    EOF
    filename = "../../services/cloudfront-www/backend-exported-from-storage-storage-www.tf"
    depends_on = [data.terraform_remote_state.variables ]
}
