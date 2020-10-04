#!/bin/sh

########################################################################
# A b2 backup script
# Uses duplicity (http://duplicity.nongnu.org/)
#
# Adjust to your needs
########################################################################

# directories that are backed up
BACKUP_DIRS="/some/path/here /another/path/here"

# b2 variables
B2_ACCOUNT_ID=b2_account_id_here
B2_APPLICATION_KEY=b2_application_key_here
BUCKET=bucket_name_here

# GPG
ENCRYPT_KEY=gpg_encrypt_key
export PASSPHRASE=passphrase

duplicity cleanup --force b2://$B2_ACCOUNT_ID:$B2_APPLICATION_KEY@$BUCKET

# Send them to b2
duplicity --full-if-older-than 7D --encrypt-key="$ENCRYPT_KEY" $BACKUP_DIRS b2://$B2_ACCOUNT_ID:$B2_APPLICATION_KEY@$BUCKET

# Verify
duplicity verify --encrypt-key="$ENCRYPT_KEY" b2://$B2_ACCOUNT_ID:$B2_APPLICATION_KEY@$BUCKET $WORKING_DIR

# Cleanup
duplicity remove-older-than 30D --force --encrypt-key=$ENCRYPT_KEY b2://$B2_ACCOUNT_ID:$B2_APPLICATION_KEY@$BUCKET
