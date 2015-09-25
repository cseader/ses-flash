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
If you don't know how to setup an installation server then you can reference the documentation here.  
https://www.suse.com/documentation/sles11/book_sle_deployment/data/sec_deployment_remoteinst_instserver.html  
There are many guides on the internet around this topic. Do some googling. :-)  
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

Before building the iamge you will need to create for yourself another directory for your kiwi build directory.  
You will want to create a directory that is different from your git repository where you will rsync the contents of your git repository into. For example in this case I will create a directory called /kiwi/ses2-flash/. I like to give it a name that I can identifiy like I have here with ses2-flash since I will be building version 2 of SES.

```
mkdir -p /home/some_user/kiwi/ses2-flash/
```
Now rsync the contents of your git repo into /home/some_user/kiwi/ses2-flash/  
Note: The git repo is ses-flash because thats what git will create from a clone since its the name of the project.  
```
rsync -avP /home/directory/git/ses-flash/ /home/some_user/kiwi/ses2-flash/
```
Once you have your git repository synced then you can now add some required overlay files into your overlay directory.  
You will need to download both the SLES 12 Server GA x86_64 DVD iso image and the SUSE Enterprise Storage 2 iso image and put them into the directory /home/some_user/kiwi/root/srv/iso/  
Once they are in that directory then they will be picked up as overlay files when you run the kiwi build.  

You are now ready to run the kiwi build with the below command.  
```
kiwi -b /home/some_user/kiwi/ses2-flash/ -d /location/of/build/destination/ --type oem
```

#####Kiwi Docs
Latest KIWI Cookbook  
https://doc.opensuse.org/projects/kiwi/doc/

KIWI openSUSE wiki  
https://en.opensuse.org/Category:KIWI
