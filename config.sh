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
# Setup baseproduct link
#--------------------------------------
suseSetupProduct
suseSetupProductInformation

#======================================
# Add missing gpg keys to rpm
#--------------------------------------
suseImportBuildKey

#=========================================
# Set sysconfig options
#-----------------------------------------

# These are all set by YaST but not by KIWI
baseUpdateSysConfig /etc/sysconfig/boot RUN_PARALLEL no
baseUpdateSysConfig /etc/sysconfig/bootloader LOADER_TYPE grub2 
baseUpdateSysConfig /etc/sysconfig/clock HWCLOCK "-u"
baseUpdateSysConfig /etc/sysconfig/clock TIMEZONE UTC
baseUpdateSysConfig /etc/sysconfig/console CONSOLE_FONT "lat9w-16.psfu"
baseUpdateSysConfig /etc/sysconfig/console CONSOLE_SCREENMAP trivial
baseUpdateSysConfig /etc/sysconfig/kernel INITRD_MODULES "ext4"
baseUpdateSysConfig /etc/sysconfig/keyboard COMPOSETABLE "clear latin1.add"
baseUpdateSysConfig /etc/sysconfig/language INSTALLED_LANGUAGES ""
baseUpdateSysConfig /etc/sysconfig/mouse MOUSEDEVICE ""
baseUpdateSysConfig /etc/sysconfig/network/dhcp DHCLIENT_SET_HOSTNAME yes
baseUpdateSysConfig /etc/sysconfig/network/dhcp WRITE_HOSTNAME_TO_HOSTS no
baseUpdateSysConfig /etc/sysconfig/suseconfig CWD_IN_USER_PATH no
baseUpdateSysConfig /etc/sysconfig/suse_register SUBMIT_OPTIONAL true
baseUpdateSysConfig /etc/sysconfig/suse_register SUBMIT_HWDATA true
baseUpdateSysConfig /etc/sysconfig/windowmanager X_MOUSE_CURSOR ""
baseUpdateSysConfig /etc/sysconfig/windowmanager DEFAULT_WM ""

# New entries in sysconfig
echo 'DEFAULT_TIMEZONE="UTC"' >> /etc/sysconfig/clock

echo '
# Encoding used for output of non-ascii characters.
#
CONSOLE_ENCODING="UTF-8"' >> /etc/sysconfig/console

echo '
# The YaST-internal identifier of the attached keyboard.
#
YAST_KEYBOARD="english-us,pc104"' >> /etc/sysconfig/keyboard

echo '
# The full name of the attached mouse.
#
FULLNAME=""

# The YaST-internal identifier of the attached mouse.
#
YAST_MOUSE="none"

# Mouse device used for the X11 system.
#
XMOUSEDEVICE=""

# The number of buttons of the attached mouse.
#
BUTTONS="0"

# The number of wheels of the attached mouse.
#
WHEELS="0"' >> /etc/sysconfig/mouse

echo 'DISPLAYMANAGER_SHUTDOWN="root"
DISPLAYMANAGER=""
DISPLAYMANAGER_REMOTE_ACCESS="no"
DISPLAYMANAGER_ROOT_LOGIN_REMOTE="no"' > /etc/sysconfig/displaymanager

rm /etc/sysconfig/mcelog

#========================================
# Files that may vary from build to build
#----------------------------------------

# Keep track of files with randomly created unique IDs or random numbers
function random_file() { true ; }
random_file /etc/cron.d/novell.com-suse_register
random_file /etc/ntp.keys
random_file /zypp/credentials.d/NCCcredentials
random_file /var/lib/dbus/machine-id
random_file /var/lib/zypp/AnonymousUniqueId

# Keep track of files with embedded timestamps
function timestamp_file() { true ; }
timestamp_file /etc/gconf/gconf.xml.schemas/%gconf-tree.xml
timestamp_file /var/lib/PolicyKit/user-haldaemon.auths

# These caches are based only on data on the filesystem (system independent)
function cache_file() { true ; }
cache_file filesonly /etc/gtk-2.0/gdk-pixbuf64.loaders
cache_file filesonly /etc/gtk-2.0/gdk-pixbuf.loaders
cache_file filesonly /etc/gtk-2.0/gtk64.immodules
cache_file filesonly /etc/gtk-2.0/gtk.immodules
cache_file filesonly /etc/init.d/.depend.boot
cache_file filesonly /etc/init.d/.depend.halt
cache_file filesonly /etc/init.d/.depend.start
cache_file filesonly /etc/init.d/.depend.stop
cache_file filesonly /etc/rc.d/.depend.boot
cache_file filesonly /etc/rc.d/.depend.halt
cache_file filesonly /etc/rc.d/.depend.start
cache_file filesonly /etc/rc.d/.depend.stop
cache_file filesonly /etc/pango/pango64.modules
cache_file filesonly /etc/pango/pango.modules
cache_file filesonly /usr/share/info/dir
cache_file filesonly /var/adm/SuSEconfig/md5/etc/postfix/main.cf

#======================================
# Activate services
#--------------------------------------
suseInsertService boot.device-mapper
suseInsertService sshd
suseRemoveService acpid 
suseRemoveService boot.efivars
suseRemoveService boot.lvm
suseRemoveService boot.md
suseRemoveService boot.multipath
suseRemoveService display-manager
suseRemoveService kbd

# Cleanup
rm /var/lib/rpm/__db.*

#=====================================
# Enable yast2-firstboot
#-------------------------------------
mkdir -p /var/lib/YaST2
touch /var/lib/YaST2/reconfig_system

#======================================
# SSL Certificates Configuration
#--------------------------------------
echo '** Rehashing SSL Certificates...'
c_rehash

#======================================
# Umount kernel filesystems
#--------------------------------------
baseCleanMount

exit 0
