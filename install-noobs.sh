#!/bin/sh

arc=$1 # Archive to install
dev=$2 # Device to install on
vol_name='NOOBS'

echo "Partitioning $dev..."
parted $dev mklabel msdos
parted -a opt $dev mkpart primary fat32 0% 100%

echo "Creating filesystem on $dev..."
mkfs.fat -L NOOBS -F 32 $dev

echo "Mounting $dev as $VOL_NAME"

echo "Extracting files from $arc"

echo "copying files from $arc to $VOL_NAME"

echo "Volume $VOL_NAME is ready for use!"

