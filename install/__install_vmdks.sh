#!/usr/bin/env bash
##############################################################################
# File::    __install_vmdks
# Purpose:: Script to install various VMDKs from TurnKey's website
# 
# Author::    Jeff McAffee 08/21/2012
# Copyright:: Copyright (c) 2012, kTech Systems LLC. All rights reserved.
# Website::   http://ktechsystems.com
##############################################################################

##############################################
# Functions
#

get_vmdk_choice () {
    local choice="rails"
    echo "Select a VMDK to download:"
    for vm in ${vmlist[@]} ; do
        echo "    $vm"
    done
    echo "    all"
    echo ""
    echo -n "Choice (default: rails)? "
    read choice

    if [[ "x$choice" != "x" ]]; then
        VMDK=$choice
    else
        VMDK=rails
    fi
}

get_skip_downloads_choice () {
    local do_download="n"
    echo -n "Do you want to download VMDKs (Y/n: default: n)? "
    read do_download

    if [[ "x$do_download" != "xY" ]]; then
        SKIP_DOWNLOADS="Y"
        return
    fi

    SKIP_DOWNLOADS="N"
}

##############################################
# Variables
#

vmlist=(core rails ec2sdk mysql)
vmzips=(turnkey-core-12.0rc2-squeeze-x86-vmdk.zip turnkey-rails-11.3-lucid-x86-vmdk.zip turnkey-ec2sdk-11.3-lucid-x86-vmdk.zip turnkey-mysql-11.3-lucid-x86-vmdk.zip)
turnkey="http://downloads.sourceforge.net/project/turnkeylinux/vmdk"


##############################################
# User Input
#

get_skip_downloads_choice
if [[ "x$SKIP_DOWNLOADS" == "xY" ]]; then
    echo "Skipping VMDK downloads."
    exit 0;
fi
echo

get_vmdk_choice
echo
echo

##############################################
# Download some handy VMDKs
#

echo "- - - Downloading VMDKs - - -"
echo
vmtools_avail_vms=/opt/vmtools/avail-vms
mkdir -p $vmtools_avail_vms

cd $vmtools_avail_vms

index=0
for vm in ${vmlist[@]} ; do
    if [[ "X$VMDK" == "Xall" ]] || [[ "X$VMDK" == "X$vm" ]]; then
        echo "Downloading ${vmlist[$index]} vmdk..."
        wget $turnkey/${vmzips[$index]}
    fi
    let index=index+1
done


cd -
exit 0;
