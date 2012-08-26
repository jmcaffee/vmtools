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

# Error Codes
E_BADARGS=65


##############################################
# Function Definitions
#

# Common Directory functions so all vmtools scripts
# use the same values.
#

#---------------------------------------------
# vm_root_dir
#
# Return the path to a VM's root directory given the VM name.
#
function vm_root_dir () {

    # Inputs
    local vmname="tmp"         # VBox name of VM. Required.

    vmname=${1:-$vmname}        # Defaults to $vmname.
    echo "$VMTOOLS_ACTIVE_VMS/$vmname"
}
export -f vm_root_dir



#---------------------------------------------
# vm_scripts_dir
#
# Return the path to a VM's scripts dir given the VM name.
#
function vm_scripts_dir () {

    # Inputs
    local vmname="/tmp"         # VBox name of VM. Required.

    vmname=${1:-$vmname}        # Defaults to $vmname.
    echo "$VMTOOLS_ACTIVE_VMS/$vmname/scripts"
}
export -f vm_scripts_dir



#---------------------------------------------
# is_linux
#
# Return true or false
#
function is_linux () {
    local is_linux=false
    if [[ "x$(uname)" == "xLinux" ]]; then
        is_linux=true
    fi
    echo $is_linux
}
export -f is_linux



#---------------------------------------------
# required_uid
#
# Return the required UID (sudo) based on OS.
#
# Retrieve the result using:
# req=$(required_uid)
#
function required_uid () {
    local required_uid=500
    # Set required UID to 500 by default (for windows).

    if [[ "x$(uname)" == "xLinux" ]]; then
        required_uid=0;
    fi

    echo "$required_uid"

}
export -f required_uid



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


#---------------------------------------------
# generate_upstart_file
#
# Generate a upstart script for starting a VM
#
function generate_upstart_file () {
    
    # Inputs
    local output="$1"           # Output file. Required.
    local vmname="$2"           # Name of VM. Required.
    local vmuser="$3"             # User privledges used to start VM. Default: root
    local start_on_boot="$4"    # true/false: VM Should start at boot. Default: false
    local remote_desktop="$5"   # true/false: VM should allow RD access. Default: false

    # Vars
    local start_cmd=""
    local vbox_cmd=""


    # Validate required inputs

    if [[ "x$output" == "x" ]]; then
        exit $E_BADARGS;
    fi

    if [[ "x$vmname" == "x" ]]; then
        exit $E_BADARGS;
    fi

    # Validate, or set defaults for optional inputs

    if [[ "x$vmuser" == "x" ]]; then
        vmuser="root"
    fi

    if [[ "x$start_on_boot" == "x" ]]; then
        start_on_boot=false
    elif [[ "x$start_on_boot" == "xfalse" ]]; then
        start_on_boot=false
    else
        start_on_boot=true
    fi

    if [[ "x$remote_desktop" == "x" ]]; then
        remote_desktop=false
    elif [[ "x$remote_desktop" == "xfalse" ]]; then
        remote_desktop=false
    else
        remote_desktop=true
    fi

    # Set the start-on text.

    start_cmd="start on (local-filesystems and net-device-up IFACE=eth0)"
    if $start_on_boot; then
        start_cmd=$start_cmd
    else
        start_cmd="# $start_cmd"
    fi

    # Set the vbox command line text.

    # Using single quotes here so vmname isn't expanded.
    vbox_cmd=' --startvm $vmname'
    if $remote_desktop; then
        vbox_cmd="$vbox_cmd --vrde=on"
    else
        vbox_cmd="$vbox_cmd --vrde=off"
    fi

    (sed -e "s/USERNAME/$vmuser/g"        \
         -e "s/VMNAME/$vmname/g"        \
         -e "s/STARTCMD/$start_cmd/g"   \
         -e "s/VBOXCMD/$vbox_cmd/g" <<'EOF'
description "VMNAME VM"
author "Jeff McAffee"

# VM will start at boot if next line is uncommented.
STARTCMD

# Stop the VM when the system goes down. Our pre-stop script has
# already run at this point, the VM stopped with 'savestate'.
stop on runlevel [016]

console output

env user=USERNAME
env vmname=VMNAME

# Restart VM if it shuts down, stop trying after 5 bounces in 10 seconds.
respawn
respawn limit 5 10

pre-stop script
su $user -c "VBoxManage controlvm $vmname savestate"
end script

exec su $user -c "VBoxHeadless VBOXCMD"

EOF
) >$output


}
export -f generate_upstart_file


#---------------------------------------------
# is_vm_running
#
# Return true if a specified VM is running.
# Actually checks the results of 'VBoxManage list runningvms'
#
function is_vm_running () {
    local vmname="tmp"
    vmname=${1:-$vmname}        # Defaults to $vmname.
    
    #found=(VBoxManage list runningvms | grep -iw "$vmname" )
    found="found something"
    if [ -n found ]; then
        echo true;
        return
    fi
    echo false;
}
export -f is_vm_running



