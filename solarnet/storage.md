# Setting up ZFS RAIDZ on OVH storage host

This is the procedure as followed with the `castor` host.

1. Install host with standard Ubuntu 14.04 64bit,
   and the standard RAID1 on /home
2. Remove RAID1 on /home
  - remove /home from fstab
  - umount /home
  - mdadm --remove /dev/md3
  - mdadm --zero-superblock /dev/sda3
  - mdadm --zero-superblock /dev/sdb3
  - mdadm --zero-superblock /dev/sdc3
  - remove md3 from mdadm.conf
  - parted -s -- /dev/sda set 3 raid off
  - parted -s -- /dev/sdb set 3 raid off
  - parted -s -- /dev/sdc set 3 raid off
3. Install ZFS and matching kernel
  - apt-get install linux-image-3.19.0-*-lowlatency
  - set GRUB_DEFAULT="1>0" in /etc/default/grub
  - update-grub
  - reboot
  - apt-add-repository --yes ppa:zfs-native/stable && apt-get update && apt-get install -y ubuntu-zfs
4. Create RAIDZ pool and volumes
  - zpool create -f data raidz /dev/sda3 /dev/sdb3 /dev/sdc3
  - zfs create -o mountpoint=/mnt/ipfs data/ipfs
  - mkdir -p /ipfs/ipfs_master && ln -s /mnt/ipfs/ /ipfs/ipfs_master
  - zfs create -o mountpoint=/home data/home
