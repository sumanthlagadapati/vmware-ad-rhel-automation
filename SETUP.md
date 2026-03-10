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

---
For script-specific details, refer to the comments within each file in the `scripts/` directory.
