#!/bin/bash
# scripts/bash/terraform-destroy.sh
# Destroys all Terraform-managed infrastructure in the terraform directory

set -euo pipefail

cd "$(dirname "$0")/../../terraform"

if [ ! -f main.tf ]; then
  echo "Error: main.tf not found in terraform directory."
  exit 1
fi

# Initialize Terraform if needed
echo "Initializing Terraform..."
terraform init -input=false

echo "Running terraform destroy..."
terraform destroy -auto-approve

echo "Terraform destroy complete."