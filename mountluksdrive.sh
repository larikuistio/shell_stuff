#!/bin/bash

# script for mounting and unmounting luks encrypted drives
# I use this for mounting and unmounting external luks encrypted disks
# that I use for backups
# works at least on fedora linux :)

DEVICE="/dev/sdb1"
MOUNTPOINT="/run/media/testtest"
USER="lari"

LUKSUUID="$(cryptsetup luksUUID "$DEVICE")"

if [[ "$1" == "mount" ]]
    then
        cryptsetup luksOpen "$DEVICE" luks-"$LUKSUUID"
        mkdir -p "$MOUNTPOINT"
        chown "$USER":"$USER" "$MOUNTPOINT"
        mount /dev/mapper/luks-"$LUKSUUID" "$MOUNTPOINT"
elif [[ "$1" == "unmount" ]]
    then
        umount /dev/mapper/luks-"$LUKSUUID"
        cryptsetup luksClose /dev/mapper/luks-"$LUKSUUID"
    fi

