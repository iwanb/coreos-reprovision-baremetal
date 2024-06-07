Reproducing Fedora CoreOS re-provisioning issue.

Same config in `tftp/config.ign` leads to different partitioning:

```
$ diff disk-before disk-after
6c6
< Disk identifier: 333AA36F-1E5A-4770-9721-3217CD45AD37
---
> Disk identifier: 8FD44CE1-F723-46C4-9585-1314E286CC33
13c13
< /dev/nbd0p5 17827840 41943006 24115167 11.5G Linux filesystem
---
> /dev/nbd0p5 17827840 41940992 24113153 11.5G Linux filesystem
```

Start the web server:
```
./serve.sh
```

Run the VM twice, first with CoreOS 39.X (`tftp/bootipxe-first`), then with 40.X (`tftp/bootipxe-second`):
```
# Wait until provisioned, then shut down
./qemu.sh

# Creates sda.qcow2
qemu-nbd --connect=/dev/nbd0 ./sda.qcow2
fdisk /dev/nbd0 -l > disk-before
qemu-nbd --disconnect /dev/nbd0

# Run again, will boot from tftp/bootipxe-second
./qemu.sh

qemu-nbd --connect=/dev/nbd0 ./sda.qcow2
fdisk /dev/nbd0 -l > disk-after
qemu-nbd --disconnect /dev/nbd0
```