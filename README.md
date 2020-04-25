# esam
A clutter-free, minimal Arch Linux installer.

## Usage
Caution: This script is not any beginner-friendly, super-easy-to-handle-script for installing Arch Linux. Many more things can go wrong when you perform the installation. The purpose of the script is to get a easy-to-modify, less-cluttered arch linux installer. Let's dive in.
* Create, Format and mount the destination partition to /mnt. 
* Modify the variables for your specific informations.
* After the pacstrap and genfstab command, copy esam.sh to your /mnt. chmod it. 
* place a .bashrc file for your non-root account to the /mnt then, or else the installer will complain. Do arch-chroot. 

## What esam doesn't do
esam doen't perform any genfstab command or install grub. Please do it yourself.
