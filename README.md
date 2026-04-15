# 🛠️ VMware + Active Directory + RHEL Automation

A comprehensive automation suite for managing hybrid infrastructure across VMware vSphere, Windows Active Directory, and Red Hat Enterprise Linux.

## 🚀 Overview

This repository provides production-ready scripts and configurations to streamline infrastructure management, security hardening, and observability. It is designed for system administrators and DevOps engineers working in high-availability environments.

## 📁 Repository Structure

- **`.github/workflows/`**: automated CI/CD pipelines (e.g., Python linting and testing).
- **`grafana-dashboards/`**: pre-configured JSON dashboards for infrastructure observability.
- **`scripts/bash/`**: RHEL management and security hardening scripts.
- **`scripts/powershell/`**: Windows Server and Active Directory reporting and management.
- **`scripts/python/`**: vSphere automation (VM provisioning, snapshots, etc.) using `pyVmomi`.

## ✨ Key Features

- **Automated Testing**: Integrated GitHub Actions for Python scripts.
- **Observability**: Ready-to-import Grafana dashboards for AD health monitoring (CPU, Memory, Disk, Errors).
- **Environment Management**: Modern Python management using `uv`.
- **Infrastructure as Code**: Structured components for repeatable deployments.

## 🛠️ Getting Started

1. **Review the [Setup Guide](file:///e:/GITHUB_LOCAL/vmware-ad-rhel-automation/SETUP.md)** for prerequisites and environment configuration.
2. **Install `uv`** (if not already installed) to### Importing the Dashboards
1. Open your Grafana instance.
2. Navigate to **Dashboards** > **Import**.
3. Upload the JSON files from the `grafana-dashboards/` directory:
   - `ad-cpu-memory-disk-error.json` (for Windows AD)
   - `rhel-cpu-memory-disk-error.json` (for Linux RHEL)
   - `vmware-cpu-memory-disk-vmstatus.json` (for vSphere VMs)
4. Select your **Prometheus** data source.
5. Click **Import**.

> [!NOTE]
> These dashboards require the appropriate exporters (`windows_exporter`, `node_exporter`, or `vmware_exporter`) to be running and configured as scrape jobs in Prometheus.

## 📊 Monitoring

We provide a suite of specialized Grafana dashboards for end-to-end infrastructure observability:

### 1. Active Directory Infrastructure Overview
- **Metrics**: CPU Usage %, Memory Availability, Logical Disk Space, and Service Errors.
- **Source**: Windows Exporter.

### 2. RHEL Infrastructure Overview
- **Metrics**: CPU/Memory/Disk utilization and Systemd failed unit tracking.
- **Source**: Node Exporter.

### 3. VMware Infrastructure Overview
- **Metrics**: VM-specific CPU/Memory/Disk usage and real-time Power State status.
- **Source**: vSphere/VMware Exporter.

## 🤝 Contributing

Contributions are welcome! Please ensure all scripts are tested and follow the project's coding standards.