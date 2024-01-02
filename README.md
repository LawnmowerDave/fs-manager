# fs-manager

If you work on a lot of remote machines, SSHFS can be a bit of a pain to setup repeatedly. These scripts allow you to easily add, and activate all of your mounts for both SSHFS and OXFS. 

Note: This filesystem should also work for all Unix-like systems, but has only been tested for MacOS. 

## Getting started

Start by installing a filesystem manager by running the installer

`./installer.sh`

## Usage

`add-mount` - Add a mountpoint using the filesystem of your choosing.

`mount-all` - Mount all filesystems.

`unmount-all` - Unmount all filesystems.

`active-mounts` - List all currently mounted filesystems.

