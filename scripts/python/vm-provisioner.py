#!/usr/bin/env python3

"""
VMware vSphere VM Provisioning Tool
Author: Sumanth Lagadapati
Usage: python vm-provisioner.py clone --template "ubuntu-22.04" --name "new-vm-01"
"""

import argparse
import os
import sys
import time
from pyVim.connect import SmartConnect, Disconnect
from pyVmomi import vim, vmodl
import ssl

# Simple SSL context to avoid certificate warnings (in dev)
context = ssl.SSLContext(ssl.PROTOCOL_TLS_CLIENT)
context.check_hostname = False
context.verify_mode = ssl.CERT_NONE

def get_args():
    parser = argparse.ArgumentParser(description='vSphere VM Provisioning Tool')
    parser.add_argument('--host', default=os.getenv('VC_HOST'), help='vCenter host')
    parser.add_argument('--user', default=os.getenv('VC_USER'), help='vCenter user')
    parser.add_argument('--password', default=os.getenv('VC_PASS'), help='vCenter password')
    
    subparsers = parser.add_subparsers(dest='command')
    
    # Clone command
    clone_parser = subparsers.add_parser('clone', help='Clone a VM from a template')
    clone_parser.add_argument('--template', required=True, help='Template name')
    clone_parser.add_argument('--name', required=True, help='New VM name')
    clone_parser.add_argument('--datacenter', default='Datacenter', help='Datacenter name')
    
    # List command
    subparsers.add_parser('list', help='List all VMs')
    
    return parser.parse_args()

def connect_to_vcenter(args):
    try:
        si = SmartConnect(host=args.host, user=args.user, pwd=args.password, sslContext=context)
        return si
    except Exception as e:
        print(f"Error connecting to vCenter: {e}")
        sys.exit(1)

def get_obj(content, vimtype, name):
    obj = None
    container = content.viewManager.CreateContainerView(content.rootFolder, [vimtype], True)
    for c in container.view:
        if c.name == name:
            obj = c
            break
    return obj

def list_vms(content):
    print(f"{'VM Name':<30} {'Power State':<15} {'IP Address':<15}")
    print("-" * 60)
    container = content.viewManager.CreateContainerView(content.rootFolder, [vim.VirtualMachine], True)
    for vm in container.view:
        print(f"{vm.name:<30} {vm.runtime.powerState:<15} {vm.guest.ipAddress or 'N/A':<15}")

def clone_vm(content, template_name, new_vm_name, dc_name):
    print(f"Cloning {template_name} to {new_vm_name}...")
    
    dc = get_obj(content, [vim.Datacenter], dc_name)
    template = get_obj(content, [vim.VirtualMachine], template_name)
    
    if not template:
        print(f"Template {template_name} not found")
        return

    relospec = vim.vm.RelocateSpec()
    clonespec = vim.vm.CloneSpec(location=relospec, powerOn=True, template=False)
    
    task = template.CloneVM_Task(folder=dc.vmFolder, name=new_vm_name, spec=clonespec)
    
    while task.info.state not in [vim.TaskInfo.State.success, vim.TaskInfo.State.error]:
        time.sleep(2)
        print(f"Task state: {task.info.state} - {task.info.progress or 0}%")
        
    if task.info.state == vim.TaskInfo.State.success:
        print(f"Successfully cloned VM: {new_vm_name}")
    else:
        print(f"Error cloning VM: {task.info.error}")

def main():
    args = get_args()
    if not all([args.host, args.user, args.password]):
        print("Error: Missing credentials. Set VC_HOST, VC_USER, and VC_PASS env vars.")
        sys.exit(1)

    si = connect_to_vcenter(args)
    content = si.RetrieveContent()

    if args.command == 'list':
        list_vms(content)
    elif args.command == 'clone':
        clone_vm(content, args.template, args.name, args.datacenter)
    else:
        print("Use --help to see available commands")

    Disconnect(si)

if __name__ == "__main__":
    main()
