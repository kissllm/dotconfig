#!/usr/bin/env sh
# How to use:
# b "kiss on nvme0" "/dev/nvme0n1" "p10" "p9"
# b "kiss on nvme1" "/dev/nvme1n1" "p3" "p2"
if [ -z "$1" ]; then
    echo "Input title pls"; exit 1;
else
    TITLE="$1"
fi
if [ -z "$2" ]; then
    echo "Input disk pls"; exit 1;
else
    DISK="$2"
fi

if [ -z "$3" ]; then
    echo "Input root pls"; exit 2;
else
    ROOT="${DISK}$3"
fi
if [ -z "$4" ]; then
    echo "Input resume pls"; exit 2;
else
    RESUME="${DISK}$4"
fi

BOOT_NUM="$(efibootmgr | grep "${TITLE}" | awk '{print $1}' | sed "s/Boot//g" | sed "s/*//g")"
echo "BOOT_NUM=${BOOT_NUM}"

mount -o remount, rw /sys/firmware/efi/efivars

if [ -n "${BOOT_NUM}" ]; then
    echo "Delete point:"
    efibootmgr -B -b ${BOOT_NUM}
fi

echo "Create point:"
efibootmgr -c -d "${DISK}" -L "${TITLE}" -l "\EFI\efistub\vmlinuz.efi" \
    "root=${ROOT} ro resume=${RESUME} tsc=unstable ro console=ttyS0,19200n8 net.ifnames=0 \
    modules=sd-mod,usb-storage,ext4 quiet rootfstype=ext4 \
    ro rd.neednet=1 ip=dhcp loglevel=4 slub_debug=P page_poison=1"
# efibootmgr -c -d "${DISK}" -L "${TITLE}" -l "\EFI\efistub\vmlinuz.efi" \
#     --unicode "root=${ROOT} ro resume=${RESUME} tsc=unstable ro console=ttyS0,19200n8 net.ifnames=0 \
#     modules=sd-mod,usb-storage,ext4 quiet rootfstype=ext4 \
#     ro rd.neednet=1 ip=dhcp loglevel=4 slub_debug=P page_poison=1"
