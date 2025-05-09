resource "local_file" "exportbackend-to-services-cloudfront-www" {
    content  = <<EOF
data "terraform_remote_state" "zones" {
   backend = "s3"
   config = {
        key = "vpcs/zone/zone.tfstate"
        region = "us-east-1"
        profile  = "Infrastructure"
        bucket  = "${data.terraform_remote_state.variables.outputs.backendname}"
   }
}
    EOF
    filename = "../../services/cloudfront-www/backend-exported-from-vpcs-zone.tf"
    depends_on = [data.terraform_remote_state.variables ]
}
