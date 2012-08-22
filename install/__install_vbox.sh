#!/usr/bin/env bash
##############################################################################
# File::    install
# Purpose:: Install VirtualBox and helper scripts
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


sources_list_file () {
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


update_hostname () {
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



##############################################
# Validation Checks
#

e_badargs=65
e_nosourceslist=66

##############################################
# Script
#

# Find the sources.list file.

sources_list=$(sources_list_file)
if [[ -z $sources_list ]]; then
  echo "Unable to find sources.list."
  exit $e_nosourceslist
fi

echo "sources.list found at \"$sources_list\""

# Add repo to sources.list.

echo "Adding VirtualBox repo to sources.list."
script_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
script_path=$script_path/`basename $0`

(cat <<EOL

# Adding virtualbox repo.
# Added by $script_path
deb http://download.virtualbox.org/virtualbox/debian lucid contrib non-free
EOL
) >>$sources_list


# Download Oracle's public encryption key.

echo "Retrieving Oracle's encryption key."
wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | sudo apt-key add -

# Update the package database.

echo "Updating apt-get."
apt-get update

# Install everything we need.

echo "Installing headers, virtualbox-4.1 and dkms."
apt-get install linux-headers-$(uname -r) build-essential virtualbox-4.1 dkms

# Add the current user to the vboxusers group.

echo "Adding $(whoami) to vboxusers group."
adduser $(whoami) vboxusers

# Install the extension pack.

echo "Installing VirtualBox extension pack."
downloads=/tmp/vboxext
mkdir -p $downloads
cd $downloads
wget http://download.virtualbox.org/virtualbox/4.1.18/Oracle_VM_VirtualBox_Extension_Pack-4.1.18-78361.vbox-extpack
VBoxManage extpack install Oracle_VM_VirtualBox_Extension_Pack-4.1.18-78361.vbox-extpack
cd -
rm -rf $downloads

# Update hostname

update_hostname

exit 0;
