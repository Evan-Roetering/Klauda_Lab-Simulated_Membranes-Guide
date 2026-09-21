# Useful Programs and Resources for Molecular Dynamics Simulations
&emsp;&#8202;│  
&emsp;├──🞂 Evan Roetering  
&emsp;├──🞂 Klauda Lab  
&emsp;├──🞂 University of Maryland  
&emsp;└──🞂 Last Edit: 9/21/2026  

### 1. HPC Cluster:
[High Performance Computing at UMD](https://hpcc.umd.edu/) provides our computational resources via the [Zaratan High Performance Computing Cluster](https://hpcc.umd.edu/home/clusters/zaratan/). 
This system gives us access to [a few high performance computing options](https://hpcc.umd.edu/home/clusters/zaratan/#details-of-the-zaratan-cluster) including AMD EPYC 7763 cpus, Intel Xeon Platinum 8468 cpus, NVIDIA A100 accelerator gpus, and NVIDIA H100 accelerator gpus. 
The cluster runs [Red Hat Linux](https://www.redhat.com/en/technologies/linux-platforms/enterprise-linux) as the operating system and resources are managed and assigned by a job scheduling software called [slurm](https://slurm.schedmd.com/overview.html). 
Access to the cluster is given by Dr. Klauda and is tied to your university login information.

### 2. Linux:
The best way to access the cluster is from a Linux terminal, which can be added into windows with [Windows Subsystem for Linux (WSL)](https://learn.microsoft.com/en-us/windows/wsl/about).  
WSL Installation Steps for Windows 11:  
1. Download [Ubuntu](https://apps.microsoft.com/detail/9PDXGNCFSCZV?hl=en-us&gl=US&ocid=pdpshare) from the Microsoft Store ([Debian](https://apps.microsoft.com/detail/9MSVKQC78PK6?hl=en-us&gl=US&ocid=pdpshare), [Kali](https://apps.microsoft.com/detail/9PKR34TNCV07?hl=en-us&gl=US&ocid=pdpshare), and many other options are also available if you prefer a different Linux variant
2. Run Windows Powershell as Administrator
3. Input `wsl --install` to powershell
4. Reboot your computer
5. Open the Ubuntu app and choose a username and password for you WSL user

### 3. WinScp:
While files can be copied from Zaratan with the scp command, it is often easier to use WinScp. It rovides a GUI for side-by-side navigation of your computer's filesystem and Zaratan's filesystem where you can us scp to copy files between the two. An installer for it can be downloaded from the [WinScp Website](https://winscp.net/eng/download.php).  
First time setup for Zaratan access:
1. Run the installer and open WinScp
2. Fill in the following fields:
    * File Protocol: `SFTP`
    * Host Name: `login.zaratan.umd.edu`
    * Port Number: `22`
    * User Name: `<zaratan-username>`
    * Password: `<zaratan-password>`
3. Select save
4. By default, it will use `<zaratan-username>@login.zaratan.umd.edu` as the site name, but if you can change it to something more memorable like `Zaratan` if you want
5. You will have the option to select to save your password and/or make a desktop shortcut. Because UMD requires two-factor authentication, I recommend saving your password for convenience if you are using a computer that you do not share access to.

### 4. VMD:
