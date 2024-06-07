#!/usr/bin/env bash
if [ -e sda.qcow2 ]
then
   cp tftp/bootipxe-second tftp/bootipxe
else
   cp tftp/bootipxe-first tftp/bootipxe
   ./mkimage.sh
fi
qemu-kvm \
    -cpu host -accel kvm \
    -netdev user,id=net0,tftp=$(pwd)/tftp/,bootfile=/undionly.kpxe \
    -device virtio-net-pci,netdev=net0 \
    -m 3072 \
    -hda sda.qcow2 \
    -boot once=n
