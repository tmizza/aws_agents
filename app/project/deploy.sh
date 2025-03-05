#!/bin/bash
# Deploy infrastructure using Terraform
terraform init
terraform apply -auto-approve

echo "Infrastructure deployed successfully!"