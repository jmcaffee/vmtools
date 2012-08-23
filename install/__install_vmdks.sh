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

# Source the common functions.
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $SCRIPT_DIR/__functions.sh


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



##############################################
# User Input
#

get_skip_downloads_choice
if [[ "x$SKIP_DOWNLOADS" == "xY" ]]; then
    echo "Skipping VMDK downloads."
    exit 0;
fi
echo

select_vmdk "rails" "Select a VMDK to download:" "Y"
echo
echo

##############################################
# Download some handy VMDKs
#

echo "- - - Downloading VMDKs - - -"
echo

mkdir -p $VMTOOLS_AVAIL_VMS

cd $VMTOOLS_AVAIL_VMS

index=0
for vm in ${VMLIST[@]} ; do
    if [[ "X$VMDK" == "Xall" ]] || [[ "X$VMDK" == "X$vm" ]]; then
        echo "Downloading ${VMLIST[$index]} vmdk..."
        wget $TURNKEY/${VMZIPS[$index]}
    fi
    let index+=1
done


cd - > /dev/nul
exit 0;
