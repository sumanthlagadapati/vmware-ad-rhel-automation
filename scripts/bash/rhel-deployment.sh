#!/bin/bash

# ==============================================================================
# RHEL Deployment & Hardening Script
# Description: Automates the post-deployment configuration and hardening of RHEL.
# Author: Sumanth Lagadapati
# ==============================================================================

set -e # Exit on error

# Configuration Variables
LOG_FILE="/var/log/rhel-automation.log"

# Function: Logging
log_msg() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# 1. System Info & Permissions Check
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

log_msg "Starting RHEL deployment and hardening script..."

# 2. Update System
log_msg "Updating system packages..."
dnf update -y

# 3. Hostname & Network Configuration
# log_msg "Configuring Hostname..."
# hostnamectl set-hostname rhel-node01

# 4. Security Hardening - Kernel Parameters
log_msg "Applying kernel hardening parameters..."
cat <<EOF > /etc/sysctl.d/99-hardening.conf
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.all.rp_filter = 1
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv6.conf.all.disable_ipv6 = 1
EOF
sysctl -p /etc/sysctl.d/99-hardening.conf

# 5. Disable Unused Services
log_msg "Disabling unused services..."
systemctl disable --now bluetooth.service 2>/dev/null || true
systemctl disable --now avahi-daemon.service 2>/dev/null || true

# 6. Configure SSH Hardening
log_msg "Hardening SSH configuration..."
sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/#MaxAuthTries 6/MaxAuthTries 3/' /etc/ssh/sshd_config
systemctl restart sshd

# 7. Configure Firewalld
log_msg "Configuring Firewalld..."
systemctl enable --now firewalld
firewall-cmd --permanent --add-service=ssh
firewall-cmd --reload

# 8. Finished
log_msg "RHEL deployment and hardening completed successfully."
log_msg "Please review $LOG_FILE for details."
