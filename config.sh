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
echo "** Running suseConfig..."
suseConfig

echo "** Running ldconfig..."
/sbin/ldconfig

#======================================
# Setup baseproduct link
#--------------------------------------
suseSetupProduct

#======================================
# Setup default runlevel
#--------------------------------------
baseSetRunlevel 5 

#======================================
# Add missing gpg keys to rpm
#--------------------------------------
suseImportBuildKey

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

# Enable sshd
chkconfig sshd on

#=====================================
# Add repos 
#-------------------------------------
#mkdir -p /etc/products.d
# fixed with above suseSetupProduct
#ln -s /etc/products.d/SLES.prod /etc/products.d/baseproduct
zypper ar -c -t yast2 -f iso:/?iso=/srv/iso/SUSE-Enterprise-Storage-2-DVD-x86_64-Build0034-Media1.iso SUSE-Enterprise-Storage-2
zypper ar -c -t yast2 -f iso:/?iso=/srv/iso/SLE-12-Server-DVD-x86_64-GM-DVD1.iso SUSE-Linux-Enterprise-Server-12
zypper -n refresh 

#=====================================
# Ceph Admin Setup
#-------------------------------------
su ceph -c 'ssh-keygen -P "" -f "/home/ceph/.ssh/id_rsa" -q'

#=====================================
# default systemd target
#-------------------------------------

systemctl set-default -f graphical.target

#======================================
# Sysconfig Update
#--------------------------------------
echo '** Update sysconfig entries...'
baseUpdateSysConfig /etc/sysconfig/keyboard KEYTABLE us.map.gz 
baseUpdateSysConfig /etc/sysconfig/network/config FIREWALL no
baseUpdateSysConfig /etc/sysconfig/network/config NETWORKMANAGER no
baseUpdateSysConfig /etc/sysconfig/console CONSOLE_FONT lat9w-16.psfu
baseUpdateSysConfig /etc/sysconfig/displaymanager DISPLAYMANAGER xdm
baseUpdateSysConfig /etc/sysconfig/windowmanager DEFAULT_WM icewm-session
#sysconf_addword /etc/sysconfig/displaymanager DISPLAYMANAGER "gdm"
#sysconf_addword /etc/sysconfig/windowmanager DEFAULT_WM "gnome"
#sed -i 's/DISPLAYMANAGER.*/DISPLAYMANAGER="gdm"/' /etc/sysconfig/displaymanager
#sed -i 's/DEFAULT_WM.*/DEFAULT_WM="gnome"/' /etc/sysconfig/windowmanager

#======================================
# SSL Certificates Configuration
#--------------------------------------
echo '** Rehashing SSL Certificates...'
c_rehash

exit 0
