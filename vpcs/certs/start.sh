#!/bin/bash
backend="../../global/tf-state/backend.hcl"
rm -rf cloud.tf ; ln -s    ../../global/providers/cloud.tf ./cloud.tf
terraform init -backend-config=$backend  
terraform plan 
terraform apply --auto-approve 
