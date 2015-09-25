#!/bin/bash
#
# 1-ses-prep
# first step in SES setup scripts
#

# Global Variabls

systype="admin"
sesiso="SUSE-Enterprise-Storage-2-DVD-x86_64-Build0034-Media1.iso"
slesiso="SLE-12-Server-DVD-x86_64-GM-DVD1.iso"

# Ask whether the system is for Admin or OSD/MON

#echo "What are we setting up?(admin/OSD/MON), followed by [Enter]:" 

#read systype 

case $systype in
  admin)
  echo "Setting up Ceph Admin Server!"  
  ;;

  OSD)
  echo "Setting up Ceph OSD Server!"
  ;;

  MON)
  echo "Setting up Ceph MON Server!"
  ;;

  *)
  echo "Wrong value. Use adim, OSD, or MON"
  ;;
esac

#=====================================
# Ceph User Setup
#-------------------------------------
# generate ssh keys
su ceph -c 'ssh-keygen -P "" -f "/home/ceph/.ssh/id_rsa" -q'

#=====================================
# Add local repos to system
#-------------------------------------
#ln -s /etc/products.d/SLES.prod /etc/products.d/baseproduct
# Adding SES2 repo
if [[ -e "/srv/iso/$sesiso" ]]; then
  zypper -n ar -c -t yast2 -f "iso:/?iso=/srv/iso/$sesiso" SUSE-Enterprise-Storage-2
else
  echo "$sesiso is missing. please register system with either SUSE Manager Server, SMT or SCC"
fi

# Adding SLES 12 GA repo
if [[ -e "/srv/iso/$slesiso" ]]; then
  zypper -n ar -c -t yast2 -f "iso:/?iso=/srv/iso/$slesiso" SUSE-Linux-Enterprise-Server-12
else
  echo "$slesiso is missing. please register system with either SUSE Manager Server, SMT or SCC"
fi

# Refresh repos
if [[ `zypper sl` ]]; then
  zypper -n refresh
fi
