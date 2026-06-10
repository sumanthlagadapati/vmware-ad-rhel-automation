# Terraform Provider for Infrastructure Reprovisioning

This directory contains Terraform configuration for reprovisioning VMware vSphere infrastructure using the official [vSphere provider](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs).

## Getting Started

1. **Install Terraform**
   - Download from [terraform.io](https://www.terraform.io/downloads.html) and ensure it's in your PATH.

2. **Configure Variables**
   - Copy `main.tf` and create a `terraform.tfvars` file with your environment values:
     ```hcl
     vsphere_user     = "administrator@vsphere.local"
     vsphere_password = "your-password"
     vsphere_server   = "vcenter.example.com"
     vsphere_datacenter = "Datacenter"
     vsphere_cluster    = "Cluster"
     vsphere_datastore  = "Datastore"
     vsphere_network    = "VM Network"
     vm_template        = "ubuntu-22.04-template"
     vm_name            = "new-vm-01"
     ```

3. **Initialize and Apply**
   ```sh
   cd terraform
   terraform init
   terraform plan
   terraform apply
   ```

## Destroying Infrastructure
To destroy all resources managed by this Terraform configuration, run:

```sh
terraform destroy
```

- You will be prompted to confirm before resources are deleted.
- Ensure you are in the `terraform` directory and using the correct workspace/environment.
- This will remove all infrastructure defined in your Terraform state.

## Notes
- This configuration is a starting point. Adjust resources and variables as needed for your environment.
- Sensitive values (like passwords) should be managed securely (e.g., environment variables, secret stores).
- See the [vSphere provider docs](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs) for advanced usage.
