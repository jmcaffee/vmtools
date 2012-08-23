#!/usr/bin/env bash
##############################################################################
# File::    __install_scripts.sh
# Purpose:: Install helper scripts for administering a VirtualBox VM Server.
# 
# Author::    Jeff McAffee 08/21/2012
# Copyright:: Copyright (c) 2012, kTech Systems LLC. All rights reserved.
# Website::   http://ktechsystems.com
##############################################################################

# Source the common functions.
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $SCRIPT_DIR/__functions.sh

##############################################
# Script
#

echo "Creating directories at $VMTOOLS_ROOT"
mkdir -p --verbose $VMTOOLS_ROOT
mkdir -p --verbose $VMTOOLS_BIN
mkdir -p --verbose $VMTOOLS_AVAIL_VMS
mkdir -p --verbose $VMTOOLS_ACTIVE_VMS

cp -r $SCRIPT_DIR/opt/vmtools/bin/* $VMTOOLS_BIN/

##############################################

echo "Creating symlinks."
cd $VMTOOLS_BIN
for file in ./* ; do
  if [[ -f $file ]]; then
    fullpath=$(readlink -f "$file")
    ln -s $fullpath /usr/local/bin/`basename $file`
    echo "Link added: `basename $file`"
  fi
done

##############################################


