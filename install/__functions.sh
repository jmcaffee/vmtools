#!/usr/bin/env bash
##############################################################################
# File::    __functions.sh
# Purpose:: Helper functions for vmtools installer
# 
# Author::    Jeff McAffee 08/22/2012
# Copyright:: Copyright (c) 2012, kTech Systems LLC. All rights reserved.
# Website::   http://ktechsystems.com
##############################################################################

##############################################
# Global Variables
#

VMTOOLS_ROOT=/opt/vmtools
VMTOOLS_BIN=$vmtools_root/bin
VMTOOLS_AVAIL_VMS=$vmtools_root/avail-vms
VMTOOLS_ACTIVE_VMS=$vmtools_root/active-vms

VMDK=""
VMLIST=(core rails ec2sdk mysql)
VMZIPS=(turnkey-core-12.0rc2-squeeze-x86-vmdk.zip turnkey-rails-11.3-lucid-x86-vmdk.zip turnkey-ec2sdk-11.3-lucid-x86-vmdk.zip turnkey-mysql-11.3-lucid-x86-vmdk.zip)
TURNKEY="http://downloads.sourceforge.net/project/turnkeylinux/vmdk"


##############################################
# Function Definitions
#

#---------------------------------------------
# sources_list_file
#
# Returns the sources.list file path
# Should be called as: somevar=$(sources_list_file)
#
function sources_list_file () {
  local srcfile="/etc/apt/sources.list.d/source.list"
  
  if [[ -f $srcfile ]]; then
    echo $srcfile
    return
  fi

  srcfile="/etc/apt/sources.list"
  if [[ -f $srcfile ]]; then
    echo $srcfile
    return
  fi

  echo ""
}
export -f sources_list_file


#---------------------------------------------
# update_hostname
#
# Permanently update the hostname
#
function update_hostname () {
    local host=$(hostname)
    local newhost=""
    echo -n "Change host name to (default: $host): "
    read newhost
    if [[ "X$host" == "X$newhost" ]]; then
        echo "Hostname *not* changed."
        return 0;
    fi

    echo "$newhost" > /etc/hostname
    hostname $newhost
    sed -i "s|127.0.1.1 \(.*\)|127.0.1.1 $newhost|" /etc/hosts
    echo "Hostname changed to $newhost"
    return 0;
}
export -f update_hostname


#---------------------------------------------
# select_vmdk
#
# Allow user to select a VMDK.
#
# Selected VMDK will be returned in global $VMDK
#
# Parameters:
#   default: default VMDK (use just hits <Enter>)
#   msg: Message to display
#   use_all: display 'all' option when 'Y'
#
function select_vmdk () {
    local default="rails"
    local msg="Select a VMDK:"
    local use_all="N"

    if [[ "X$1" != "X" ]]; then
        default=$1
    fi

    if [[ "X$2" != "X" ]]; then
        msg=$2
    fi

    if [[ "X$3" != "X" ]]; then
        use_all=$3
    fi

    echo "$msg"
    for vm in ${VMLIST[@]} ; do
        echo "    $vm"
    done

    if [[ "$use_all" == "Y" ]]; then
        echo "    all"
    fi

    echo ""
    echo -n "Choice (default: $default)? "
    read choice

    if [[ "x$choice" != "x" ]]; then
        VMDK=$choice
    else
        VMDK=$default
    fi

}
export -f select_vmdk



