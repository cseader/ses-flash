###SUSE Enterprise Storage Rapid Deployment Appliance

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


| Intsall the kiwi packages |
|---------------------------|
|kiwi-tools-7.03.14-1.1.x86_64|
|kiwi-instsource-7.03.14-1.1.x86_64|
|kiwi-7.03.14-1.1.x86_64|
|kiwi-doc-7.03.14-1.1.noarch|
|kiwi-templates-7.03.14-1.1.x86_64|
|kiwi-requires-7.03.14-1.1.noarch|
|kiwi-desc-oemboot-7.03.14-1.1.x86_64|
|kiwi-config-openSUSE-13.2-8.8.1.x86_64|

- Clone this git repo https://github.com/cseader/ses-flash.git

- Build yourself an image
```
kiwi -b /point/to/the/location/of/git/repo/ -d /location/of/build/destination/ --type oem
```

