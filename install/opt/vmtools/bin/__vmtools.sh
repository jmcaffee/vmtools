#!/usr/bin/env bash
##############################################################################
# File::    __vmtools.sh
# Purpose:: Helper functions for vmtools scripts
# 
# Author::    Jeff McAffee 08/22/2012
# Copyright:: Copyright (c) 2012, kTech Systems LLC. All rights reserved.
# Website::   http://ktechsystems.com
##############################################################################

##############################################
# Global Variables
#

VMTOOLS_ROOT=/opt/vmtools
VMTOOLS_BIN=$VMTOOLS_ROOT/bin
VMTOOLS_AVAIL_VMS=$VMTOOLS_ROOT/avail-vms
VMTOOLS_ACTIVE_VMS=$VMTOOLS_ROOT/active-vms

VMDK=""
VMZIP=""
VMLIST=(core rails ec2sdk mysql)
VMZIPS=(turnkey-core-12.0rc2-squeeze-x86-vmdk.zip turnkey-rails-11.3-lucid-x86-vmdk.zip turnkey-ec2sdk-11.3-lucid-x86-vmdk.zip turnkey-mysql-11.3-lucid-x86-vmdk.zip)
TURNKEY="http://downloads.sourceforge.net/project/turnkeylinux/vmdk"


##############################################
# Function Definitions
#

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


#---------------------------------------------
# get_vmdk_zip
#
# Return a VMDK .zip file based on selected $VMDK value.
#
# Call this function as vmzip=$(get_vmdk_zip)
#
function get_vmdk_zip () {
    local vmzip="UNKNOWN"
    local index=0
    for vm in ${VMLIST[@]} ; do
        if [[ "X$VMDK" == "X$vm" ]]; then
            vmzip="${VMZIPS[$index]}"
        fi
        let index+=1
    done
    echo "$vmzip"
}
export -f get_vmdk_zip



