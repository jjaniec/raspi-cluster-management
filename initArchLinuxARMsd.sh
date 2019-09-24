#!/bin/bash
#d Format sd card & burn arch linux arm image
#u sudo ./initArchLinuxARMsd.sh /dev/sdX imagemodel (ex for rpi4: 4, see step 5 https://archlinuxarm.org/platforms/armv8/broadcom/raspberry-pi-4)

set -o errexit
set -o pipefail
set -o nounset
set -o verbose
#set -o xtrace

OS=$(uname -s)

if [ "${OS}" != "Linux" ];
then
 echo "OS != Linux"
 exit 1
fi;

if [ -b ${1} ] && [ "${2}" != "" ];
then
 DIR=$(mktemp -d)
 echo "DIR: ${DIR}"
 fdisk -l ${1}
 cd ${DIR}
 echo "Working dir ${PWD}, using device ${1} starting in 5 seconds"

 fdisk ${1} <<EOF
o
p
n
p
1

+100M
t
c
n
p
2


w
EOF

 wget http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-${2}-latest.tar.gz

 mkfs.vfat ${1}1
 mkfs.ext4 ${1}2
 mkdir boot
 mkdir root
 mount ${1}1 boot
 mount ${1}2 root

 bsdtar -xpf ArchLinuxARM-rpi-${2}-latest.tar.gz -C root;
 sync

 mv root/boot/* boot

 umount boot root
 rm -rf ${DIR}
 echo "Done"
 echo "Now, apply power & ethernet to the pi & ssh with user 'alarm'/'alarm'"
 echo "Then run the content of remote.sh:"
 cat remote.sh
else
 echo "Usage: ./initArchLinuxARMsd.sh /dev/sdX imagemodel (ex for rpi4: 4, see step 5 https://archlinuxarm.org/platforms/armv8/broadcom/raspberry-pi-4)"
fi;
