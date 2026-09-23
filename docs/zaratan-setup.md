# Zaratan Access and WSL Setup

## What is Zaratan?
[High Performance Computing at UMD](https://hpcc.umd.edu/) provides our computational resources via the [Zaratan High Performance Computing Cluster](https://hpcc.umd.edu/home/clusters/zaratan/). 
This system gives us access to [a few high performance computing options](https://hpcc.umd.edu/home/clusters/zaratan/#details-of-the-zaratan-cluster) including AMD EPYC 7763 cpus, Intel Xeon Platinum 8468 cpus, NVIDIA A100 accelerator gpus, and NVIDIA H100 accelerator gpus. 
The cluster runs [Red Hat Linux](https://www.redhat.com/en/technologies/linux-platforms/enterprise-linux) as the operating system and resources are managed and assigned by a job scheduling software called [slurm](https://slurm.schedmd.com/overview.html). 
Access to the cluster is given by Dr. Klauda and is tied to your university login information.

## Installing WSL
The best way to access the cluster is from a Linux terminal, which enables access through ssh. With [Windows Subsystem for Linux (WSL)](https://learn.microsoft.com/en-us/windows/wsl/about), a Linux terminal can be added into windows, allowing you to use it to navigate your own computer and remotely connect to Zaratan.  
#### WSL Installation for Windows 11:  
1. Download [Ubuntu](https://apps.microsoft.com/detail/9PDXGNCFSCZV?hl=en-us&gl=US&ocid=pdpshare) from the Microsoft Store ([Debian](https://apps.microsoft.com/detail/9MSVKQC78PK6?hl=en-us&gl=US&ocid=pdpshare) is also fine if you prefer it)
2. Run Windows Powershell as Administrator
3. Input `wsl --install` to powershell
4. Reboot your computer
5. Launch Ubuntu and choose a username and password for you WSL user

With WSL installed, you can now navigate your windows filesystem and control it with linux commands, which can be found in [this cheatsheet](https://ubuntu.com/server/docs/reference/cli-cheatsheet/). You will start in your Ubuntu home directory, which is a virtual Linux environment with the same filesystem structure as a real Linux operating system. From inside WSL you can navigate to and interact with the rest of your windows filesystem, which you can find in `/mnt/c/`.
## Setting Up ~/bin
When you create a user in WSL, Ubuntu generates a file called `.bashrc` that allows you to configure and customize the way your terminal looks and behaves. In order to use some of the scripts in this repository, it will be helpful to modify this file so that you have a `~/bin` directory for storing custom scripts.  
#### Making a `~/bin` directory:
1. Launch Ubuntu and navigate to your home directory with `cd ~`
2. Make a subdirectory called "bin" in your home directory with `mkdir -p ~/bin`
3. Open ~/.bashrc with vim or nano and add this line to the end of it `export PATH="$HOME/bin:$PATH"`

## Connecting to the Cluster
We will use SSH to connect to Zaratan. The most simple way to do this is by entering `ssh -l <username> login.zaratan.umd.edu` into your linux terminal, entering your password, and completing two factor authentication. This can get very annoying, particularly if you have a long and/or forgettable password, so I find automating the process to be very helpful.  
#### Single Command Login:
1. Download the [.zaratan.exp](scripts/WSL/.zaratan.exp) and [zaratan](scripts/WSL/zaratan) scripts from this repository
2. Save both of them to your `~/bin` directory in WSL
3. Fill the empty username and password field in `~/bin/.zaratan.exp` with your login information
4. Make both of them executable with `chmod +x ~/bin/.zaratan.exp` and `chmod +x ~/bin/zaratan`
5. Login to Zaratan by typing `zaratan` into your WSL terminal and approving 2FA with Duo
#### Adding a Launch Menu on Startup:
1. Make a ~/bin/ssh_scripts directory with `mkdir -p ~/bin/ssh_scripts`
2. Copy ~/bin/zaratan into that directory with `cp ~/bin/zaratan ~/bin/ssh_scripts/`
3. Download the [launch_menu.sh](scripts/WSL/launch_menu.sh) script from this repository and move it to ~/bin
4. Make launch_menu.sh executable with `chmod +x ~/launch_menu.sh`
4. Edit your .bashrc file with `vim ~/.bashrc` and add `~/bin/launch_menu.sh` to the end of it (This has to be the last line of the .bashrc file, if you add other customization, make sure it comes before this)
5. Whenever you open ubuntu, you will be greeted with a menu that lets you decide where you want the terminal to be
6. If you have access to other devices you want ssh access to, you can automate that with bash scripts and put a copy in ~/bin/ssh_scripts/ and launch_menu.sh will automatically include them in your menu

## File Transfers
Files can be transferred between your computer and Zaratan through a few methods that are best suited to different situations.

#### Transferring onto Zaratan:
The rsync command can be used to transfer files over ssh in the terminal and is effective for quickly moving files onto Zaratan while working in WSL. Similarly to ssh, I have some scripts to do this without manually typing in login information:
1. Download the [.to-zt.exp](scripts/WSL/.to-zt.exp) and [to-zt](scripts/WSL/from-zt) scripts from this repository
2. Save both of them to your `~/bin` directory in WSL
3. Fill the empty username and password field in `~/bin/.to-zt.exp` with your login information
4. Make both of them executable with `chmod +x ~/bin/.to-zt.exp` and `chmod +x ~/bin/to-zt`
5. In WSL, execute `to-zt -f <source_dir> [-o <destination_dir>]` to copy a local file to zaratan
    * -f should be the relative path to the file you want to copy from the current working directory
    * -o should show where to copy the file to using either an absolute path from / if your `<source_dir>` begins with "/" or a relative path starting from your `~/scratch.energybio` directory if it doesnt. It defaults to copying the file to your `~/scratch.energybio` directory if not included

#### Transferring off of Zaratan:
The rsync command can also be used to pull files from Zaratan to your computer using SSH. To set this one up:
1. Download the [.from-zt.exp](scripts/WSL/.from-zt.exp) and [from-zt](scripts/WSL/from-zt) scripts from this repository
2. Save both of them to your `~/bin` directory in WSL
3. Fill the empty username and password field in `~/bin/.from-zt.exp` with your login information
4. Make both of them executable with `chmod +x ~/bin/.from-zt.exp` and `chmod +x ~/bin/from-zt`
5. In WSL, execute `from-zt -f <source_dir> [-o <destination_dir>]` to copy a local file to zaratan
    * -f should show where the file you are pulling is using either an absolute path from / if your `<source_dir>` begins with "/" or a relative path starting from your `~/scratch.energybio` directory if it doesnt. It defaults to copying the file to your `~/scratch.energybio` directory if not included
    * -o should be the relative path from the current working directory to copy the file to

#### Multiple File Transfers with WinScp:
Transferring with rsync can be faster for small transfers where it isnt worth spending time navigating a separate app, but for large transfers with multiple files, a tool like WinScp is much more efficient. It provides a GUI for side-by-side navigation of your computer's filesystem and Zaratan's filesystem where you can us scp to copy files between the two. An installer for it can be downloaded from the [WinScp Website](https://winscp.net/eng/download.php).  
First time setup for Zaratan access:
1. Run the installer and open WinScp
2. Fill in the following fields:
    * File Protocol: `SFTP`
    * Host Name: `login.zaratan.umd.edu`
    * Port Number: `22`
    * User Name: `<your-username>`
    * Password: `<your-password>`
3. Select save
4. By default, it will use `<zaratan-username>@login.zaratan.umd.edu` as the site name, but if you can change it to something more memorable like `Zaratan` if you want
5. You will have the option to select to save your password and/or make a desktop shortcut. Because UMD requires two-factor authentication, I recommend saving your password for convenience if you are using a computer that you do not share access to.

## Zaratan User Configuration
In this section we will set up your zaratan user in preparation for using custom functions, scripts, and executables that will be required for building systems and running simulations.

#### Editing .bashrc:
Like WSL, Zaratan also has a .bashrc that configures the terminal behavior. We will edit it so that you have access to custom scripts inside ~/scratch.energybio:  
1. Make a ~/scratch.energybio/bin directory where you can save custom scripts with `mkdir -p ~/scratch.energybio/bin`
2. Open ~/.bashrc in your text editor with `vim ~/.bashrc`
3. Insert the following lines at the end of the file:
```
PATH="$PATH:$HOME/scratch.energybio/bin"
PATH="$HOME/.local/bin:$HOME/bin:$PATH"
# If you want to add additional directories to your PATH, put them here
export PATH
```
4. Save the file

#### Job Status Script:
When using compute resources on Zaratan, you can view the status of your jobs with `squeue -u <username>` or `squeue --me`. Squeue can deliver a really wide range of information with different flags that you can find out more about with `squeue --help`, but the default doesn't return all the most useful information. For a preconfigured way to check the status of your jobs with a single command, download the [job_status](scripts/zt-bin/job_status) script from this repository. Then upload it to zaratan, move it to the ~/scratch.energybio/bin directory and make it executable with `chmod +x ~/scratch.energybio/bin/job_status`.