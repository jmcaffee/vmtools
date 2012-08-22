#!/usr/bin/env bash
##############################################################################
# File::    __install_vmdks
# Purpose:: Script to install various VMDKs from TurnKey's website
# 
# Author::    Jeff McAffee 08/21/2012
# Copyright:: Copyright (c) 2012, kTech Systems LLC. All rights reserved.
# Website::   http://ktechsystems.com
##############################################################################

echo -n "Do you want to download VMDKs (Y/n: default: n)? "
read do_download

if [[ "X$do_download" != "XY" ]]; then
    echo "Skipping VMDK downloads."
    exit 0;
fi

##############################################
# Download some handy VMDKs
#


vmtools_avail_vms=/opt/vmtools/avail-vms

cd $vmtools_avail_vms
wget http://downloads.sourceforge.net/project/turnkeylinux/vmdk/turnkey-rails-11.3-lucid-x86-vmdk.zip
wget http://downloads.sourceforge.net/project/turnkeylinux/vmdk/turnkey-core-12.0rc2-squeeze-x86-vmdk.zip
wget http://downloads.sourceforge.net/project/turnkeylinux/vmdk/turnkey-ec2sdk-11.3-lucid-x86-vmdk.zip
wget http://downloads.sourceforge.net/project/turnkeylinux/vmdk/turnkey-mysql-11.3-lucid-x86-vmdk.zip

cd -
exit 0;
