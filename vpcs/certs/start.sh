#!/bin/bash
backend="../../global/tf-state/backend.hcl"
terraform init -backend-config=$backend  
terraform plan 
terraform apply --auto-approve 
