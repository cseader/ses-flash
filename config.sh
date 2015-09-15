#!/bin/bash
#================
# FILE          : config.sh
#----------------
# PROJECT       : OpenSuSE KIWI Image System
# COPYRIGHT     : (c) 2006 SUSE LINUX Products GmbH. All rights reserved
#               :
# AUTHOR        : Marcus Schaefer <ms@suse.de>
#               :
# BELONGS TO    : Operating System images
#               :
# DESCRIPTION   : configuration script for SUSE based
#               : operating systems
#               :
#               :
# STATUS        : BETA
#----------------
#======================================
# Functions...
#--------------------------------------
test -f /.kconfig && . /.kconfig
test -f /.profile && . /.profile

#======================================
# Greeting...
#--------------------------------------
echo "Configure image: [$kiwi_iname]..."

#======================================
# SuSEconfig
#--------------------------------------
suseConfig

#==========================================
# setup gfxboot
#------------------------------------------
suseGFXBoot openSUSE grub

#======================================
# Keep UTF-8 locale
#--------------------------------------
baseStripLocales \
    $(for i in $(echo $kiwi_language | tr "," " ");do echo -n "$i.utf8 ";done)
baseStripTranslations kiwi.mo

#======================================
# Umount kernel filesystems
#--------------------------------------
baseCleanMount

#=====================================
# Enable yast2-firstboot
#-------------------------------------
mkdir -p /var/lib/YaST2
touch /var/lib/YaST2/reconfig_system

#=====================================
# Add repos 
#-------------------------------------
zypper ar -c -t yast2 "iso:/?iso=/srv/iso/SUSE-Enterprise-Storage-2-DVD-x86_64-Build0034-Media1.iso"
zypper ar -c -t yast2 "iso:/?iso=/srv/iso/SLE-12-Server-DVD-x86_64-GM-DVD1.iso"

#=====================================
# Ceph Admin Setup
#-------------------------------------
su - ceph
ssh-keygen -P "" -f "/home/ceph/.ssh/id_rsa" -q

#=====================================
# default systemd target
#-------------------------------------

systemctl set-default -f graphical.target

#=====================================
# Add configuration options          
#-------------------------------------

sysconf_addword /etc/sysconfig/displaymanager DISPLAYMANAGER "gdm"
sysconf_addword /etc/sysconfig/windowmanager DEFAULT_WM "gnome"

exit 0
