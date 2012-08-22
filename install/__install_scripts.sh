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
# Functions
#

usage() {
  echo "Usage: sudo `basename $0`"
}

##############################################
# Validation Checks
#

# Set required UID based on the terminal.
# In windows, the terminal is cygwin.
if [[ "x$TERM" == "xcygwin" ]]; then
  required_uid=500;
else
  required_uid=0;
fi

# Check for proper number of command line args.
expected_args=0
e_badargs=65
if [ $UID -ne $required_uid ] || [ $# -ne $expected_args ]
then
    usage
    exit $e_badargs
fi

##############################################
# Script
#

vmtools_root=/opt/vmtools
vmtools_bin=$vmtools/bin
vmtools_avail_vms=$vmtools_root/avail-vms
vmtools_active_vms=$vmtools_root/active-vms

##############################################

echo "Creating directories at $vmtools_root"
mkdir -p $vmtools_root
mkdir -p $vmtools_bin
mkdir -p $vmtools_avail_vms
mkdir -p $vmtools_active_vms

cp -r ./install/opt/vmtools/bin/ $vmtools_bin/

##############################################

echo "Creating symlinks."
cd $vmtools_bin
for file in * ; do
  if [[ -f $file ]]; then
    ln -s $file /usr/local/bin/`basename $file`
    echo "Link added: `basename $file`"
  fi
done

##############################################


