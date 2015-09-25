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
 
Before cloning the repository you are going to want to create a directory to clone it into. For the scope of this guide we will use /home/some_user/git/ as the git directory that contains all of our project repos. Before running the git clone we need to change our directory to the git directory as the command indicate below.  
```
cd /home/some_user/git/
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

Before building the image you will need to create for yourself another directory for your kiwi build directory.  
You will want to create a directory that is different from your git repository where you will rsync the contents of your git repository into. For example in this case I will create a directory called /home/some_user/kiwi/ses2-flash/. I like to give it a name that I can identifiy like I have here with ses2-flash since I will be building version 2 of SES. Another reason why we create this directory is because we are adding some large ISO's into an overlay directory that we don't want getting picked up by our git repository. I just like keeping it all separated. You don't have to do it this way. You could infact just keep your git repo and then just add the below files to the overlay directory indicated below.  
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

Here is what the contents of that directory might look like afterwards.  
Note: The SUSE Enterprise storage 2 DVD is not released, but reflects what it would look like if it were. For Beta testers you would drop in the Beta iso image here.  
```
flisk:/home/cseader/kiwi/ses2-flash # l root/srv/iso/
total 3025116
drwxr-xr-x 2 cseader users        113 Aug 20 16:03 ./
drwxr-xr-x 3 cseader users         16 Aug 20 16:03 ../
-rw-r----- 1 root    root  2937061376 Sep 15 17:38 SLE-12-Server-DVD-x86_64-GM-DVD1.iso
-rw-r----- 1 root    root   160655360 Sep 15 17:29 SUSE-Enterprise-Storage-2-DVD-x86_64-GM-DVD1.iso
```

You are now ready to run the kiwi build with the below command.  
```
kiwi -b /home/some_user/kiwi/ses2-flash/ -d /location/of/build/destination/ --type oem
```

#####Kiwi Docs
Latest KIWI Cookbook  
https://doc.opensuse.org/projects/kiwi/doc/

KIWI openSUSE wiki  
https://en.opensuse.org/Category:KIWI
