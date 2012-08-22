#!/usr/bin/env bash
##############################################################################
# File::    install
# Purpose:: Install script for VirtualBox VM Server and helper scripts.
# 
# Author::    Jeff McAffee 08/21/2012
# Copyright:: Copyright (c) 2012, kTech Systems LLC. All rights reserved.
# Website::   http://ktechsystems.com
##############################################################################

##############################################
# Functions
#

usage() {
    echo "vmtools Installer"
    echo ""
    echo "Usage: sudo `basename $0` {install_type}"
    echo "    Types:"
    echo "        all     - install everything"
    echo "        vbox    - install VirtualBox"
    echo "        scripts - install scripts"
    echo "        vmdks   - install some VMDK files from Turnkey"
    echo ""
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
expected_args=1
e_badargs=65
if [ $UID -ne $required_uid ] || [ $# -ne $expected_args ]
then
        usage
        exit $e_badargs
fi

##############################################
# Script
#

install_type=$1
if [[ "X$install_type" == "Xall" || "X$install_type" == "Xvbox" ]]; then
    . ./install/__install_vbox.sh
fi

if [[ "X$install_type" == "Xall" || "X$install_type" == "Xscripts" ]]; then
    . ./install/__install_scripts.sh
fi

if [[ "X$install_type" == "Xall" || "X$install_type" == "Xvmdks" ]]; then
    . ./install/__install_vmdks.sh
fi

