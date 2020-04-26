# esam
A clutter-free, minimal Arch Linux installer.

## Usage
Caution: This script is not any beginner-friendly, super-easy-to-handle script for installing Arch Linux. Many things can go wrong when you perform the installation. Make sure that, you are familiar with arch wiki for the instllation process. The purpose of the script is to get a easy-to-modify, less-cluttered arch linux installer. Let's dive in.
* Create, Format and mount the destination partition to /mnt. 
* Modify esam's variables for your specific information.
* After the pacstrap and genfstab command, copy esam.sh to your /mnt. chmod it. 
* place a .bashrc file for your non-root account to the /mnt then, or else the installer will complain. Do arch-chroot. 
* Source the script and run esam.

## What esam doesn't do
esam doesn't perform any genfstab command, partitioning, checking internet connection or install grub. Please do these yourself.
