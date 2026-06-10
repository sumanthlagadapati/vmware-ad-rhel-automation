# Setup Guide

This guide covers the prerequisites and configuration steps required to use the scripts in this repository.

## 📋 Prerequisites

### 1. PowerShell (Windows Server / AD)
- PowerShell 5.1 or PowerShell Core 7.x
- Active Directory PowerShell module (RSAT)
- Permissions: Domain Admin or delegated permissions for AD reporting.

### 2. Bash (RHEL)
- RHEL 8 or 9
- `sudo` access for configuration changes.
- Root or similar privileges for system hardening.

### 3. Python (vSphere)
- Python 3.8+
- **Environment Management**: This project uses `uv` for dependency management.
  - Install `uv`: `powershell -ExecutionPolicy Bypass -c "irm https://astral.sh/uv/install.ps1 | iex"`
  - **Note (Windows)**: If `uv` is not recognized after installation, run `$env:Path = [System.Environment]::GetEnvironmentVariable("Path","User")` in your terminal or restart VS Code.
  - Initialize environment: `uv sync`
  - Run scripts: `uv run scripts/python/vm-provisioner.py [args]`
- vCenter access with appropriate permissions for VM management.

### 4. Terraform (Infrastructure as Code)
- Terraform 1.0+
- Access to vSphere/vCenter with permissions to provision VMs and manage infrastructure.
- See [`terraform/README.md`](./terraform/README.md) for usage instructions.

#### Destroying Infrastructure
To destroy all resources managed by this Terraform configuration, you can use the provided automation script:

```sh
bash scripts/bash/terraform-destroy.sh
```

This script will initialize Terraform (if needed) and destroy all resources with no manual confirmation required.

- Alternatively, you can run the commands manually:

  ```sh
  cd terraform
  terraform destroy
  ```

- You will be prompted to confirm before resources are deleted (unless using the script).
- Ensure you are in the `terraform` directory and using the correct workspace/environment.
- This will remove all infrastructure defined in your Terraform state.
- **Warning:** This will remove all resources managed by Terraform. Use with caution.

## 🔐 Security & Credentials

**DO NOT hardcode credentials.** 

- **Environment Variables**: Use environment variables for sensitive data.
- **Windows**: Use `Get-Credential` or SecretManagement module.
- **Linux**: Use SSH keys and encrypted environment variables.

### Example Environment Variables
- `VC_HOST`: vCenter server address
- `VC_USER`: Service account username
- `VC_PASS`: Service account password

## 📝 Network Requirements

- Port 443 (HTTPS) for vCenter API.
- Port 389/636 (LDAP/S) for Active Directory.
- Port 22 (SSH) for Linux management.

## 📊 Monitoring (Grafana)

This repository includes pre-built dashboards for visualizing infrastructure health.

### Importing the AD Dashboard
1. Open your Grafana instance.
2. Navigate to **Dashboards** > **Import**.
3. Upload the `ad-cpu-memory-disk-error.json` file from the `grafana-dashboards/` directory.
4. Select your **Prometheus** data source.
5. Click **Import**.

> [!NOTE]
> These dashboards require the `windows_exporter` to be running on your Active Directory servers and configured as a job in Prometheus.

---
For script-specific details, refer to the comments within each file in the `scripts/` directory.
