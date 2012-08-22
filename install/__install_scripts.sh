#!/usr/bin/env bash
##############################################################################
# File::    __install_scripts.sh
# Purpose:: Install helper scripts for administering a VirtualBox VM Server.
# 
# Author::    Jeff McAffee 08/21/2012
# Copyright:: Copyright (c) 2012, kTech Systems LLC. All rights reserved.
# Website::   http://ktechsystems.com
##############################################################################

##############################################
# Script
#

vmtools_root=/opt/vmtools
vmtools_bin=$vmtools_root/bin
vmtools_avail_vms=$vmtools_root/avail-vms
vmtools_active_vms=$vmtools_root/active-vms

##############################################

echo "Creating directories at $vmtools_root"
mkdir -p --verbose $vmtools_root
mkdir -p --verbose $vmtools_bin
mkdir -p --verbose $vmtools_avail_vms
mkdir -p --verbose $vmtools_active_vms

cp -r ./install/opt/vmtools/bin/ $vmtools_bin/

##############################################

echo "Creating symlinks."
cd $vmtools_bin
for file in ./* ; do
  if [[ -f $file ]]; then
    ln -s $file /usr/local/bin/`basename $file`
    echo "Link added: `basename $file`"
  fi
done

##############################################


