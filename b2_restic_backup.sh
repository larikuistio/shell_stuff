#!/bin/bash


# directories that are backed up
export BACKUP_DIRS="/ --exclude /bin --exclude /boot --exclude /dev --exclude '/lib*' --exclude /media --exclude /mnt --exclude /proc --exclude /sys --exclude /tmp --exclude '/vmlinuz*' --exclude '/initrd*' --exclude /lost+found --exclude /run"

# b2 variables
export B2_ACCOUNT_ID=""
export B2_ACCOUNT_KEY=""
export B2_BUCKET=""

export WORKING_DIR=""

mkdir $WORKING_DIR

chown -R postgres:postgres $WORKING_DIR
sudo -u postgres pg_dumpall > $WORKING_DIR/postgresql.bak
chown -R root:root $WORKING_DIR

if [ "$1" == "init" ];
        then
        restic -r b2:$B2_BUCKET init
        fi

restic -r b2:$B2_BUCKET backup $BACKUP_DIRS

restic check -r b2:$B2_BUCKET

restic forget --prune --keep-daily 14 --keep-monthly 12 --keep-yearly 2 -r b2:$B2_BUCKET

rm -rf $WORKING_DIR
