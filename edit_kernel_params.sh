#!/bin/sh
set -xe

image_file=$1
new_params=$2

# unpack the image.tar.gz in $1
tar -xzf $1

# Find the raw image file
image_file=$(find . -type f -name "*.raw")

# Get partition offsets and sizes
partition_info=$(parted -s "${image_file}" unit B print)

start_offset=$(echo "${partition_info}" | awk '/BOOT/{gsub(/B/, "", $2); print $2}')

# Create a loop device for the image file
loop_device=$(losetup --find --show --offset "${start_offset}" "${image_file}")

# Mount the XFS partition
mkdir /mnt/xfs
mount -t xfs "${loop_device}" /mnt/xfs

grubfile=/mnt/xfs/grub/grub.cfg
test -r "$grubfile"

# check if the new parameters already exist in the grub file
if grep -qE "$new_params" "$grubfile"; then
    echo "Parameters already exist in $grubfile"
    cat $grubfile
    exit 1
fi

# add the new parameters to the end of the linux line if they haven't already been added
sed -i '/linux.*vmlinuz/ s/$/ '"$new_params"'/' "$grubfile"

# Unmount and clean up
umount /mnt/xfs
losetup -d "${loop_device}"

# pack the image back into a tar.gz and remove the unpacked disk image
tar -czf $1 $image_file --transform='s,^\./,,'
rm $image_file
