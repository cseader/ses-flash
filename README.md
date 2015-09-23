SUSE Enterprise Storage Rapid Deployment Appliance
--------------------------------------------------

#####Kiwi Build Setup 
- Install latest kiwi from the Open Build Service

http://download.opensuse.org/repositories/Virtualization:/Appliances/

SLE 12  
http://download.opensuse.org/repositories/Virtualization:/Appliances/SLE_12/

openSUSE 13.2  
http://download.opensuse.org/repositories/Virtualization:/Appliances/openSUSE_13.2/

openSUSE Leap 42.1  
http://download.opensuse.org/repositories/Virtualization:/Appliances/openSUSE_Leap_42.1/

Tumbleweed  
Comes with the lastest version

|Intsall the kiwi packages |
|---------------------------|
|kiwi-tools|
|kiwi-instsource|
|kiwi|
|kiwi-doc|
|kiwi-templates|
|kiwi-requires|
|kiwi-desc-oemboot|
|kiwi-config-openSUSE|
```
zypper in kiwi-tools kiwi-instsource kiwi kiwi-doc kiwi-templates kiwi-requires kiwi-desc-oemboot kiwi-config-openSUSE
```

- Clone this git repo 
```
git clone https://github.com/cseader/ses-flash.git
```

- Edit config.xml to change souce paths to local repos of the same source

This repo is a download of the latest SES2 beta extracted on an installation server. 
Note: Just point it to where you have extracted the root of the DVD. 
```
<repository type="yast2">
    <source path="http://some_host/install/SES2/"/>
</repository>
```

This is the SLES 12 Server updates repo as mirrored from SMT  
```
<repository type="rpm-md">
    <source path="http://some_host/install/smt/repo/SUSE/Updates/SLE-SERVER/12/x86_64/update/"/>
</repository>
```

This repo is a download of the SLES 12 GA DVD 1 Media extracted on an installation server.
Note: Just point it to where you have extracted the root of the DVD.  
```
<repository type="yast2">
    <source path="http://some_host/install/SLES12GA-x86_64/"/>
</repository>
```

- Build yourself an image
```
kiwi -b /point/to/the/location/of/git/repo/ -d /location/of/build/destination/ --type oem
```

#####Kiwi Docs
Latest KIWI Cookbook  
https://doc.opensuse.org/projects/kiwi/doc/

KIWI openSUSE wiki  
https://en.opensuse.org/Category:KIWI
