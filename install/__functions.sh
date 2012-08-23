#!/usr/bin/env bash
##############################################################################
# File::    __functions.sh
# Purpose:: Helper functions for vmtools installer
# 
# Author::    Jeff McAffee 08/22/2012
# Copyright:: Copyright (c) 2012, kTech Systems LLC. All rights reserved.
# Website::   http://ktechsystems.com
##############################################################################

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $SCRIPT_DIR/opt/vmtools/bin/__vmtools.sh

##############################################
# Global Variables
#



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


