#!/bin/bash -eux

echo "==> Recording box generation date"
date > /etc/vagrant_box_build_date

kernel_version=`rpm -qa kernel |sort -V |tail -n 1`

if [[ !( ${kernel_version} =~ `uname -r` ) ]]; then
    echo "==>Applying updates"
    yum -y update

    # reboot
    echo "Rebooting the machine..."
    reboot
    sleep 60
fi

echo "==> Install basic kit and dependencies..."
yum -y install binutils gcc make patch libgomp glibc-headers glibc-devel kernel-headers-`uname -r` kernel-devel-`uname -r` dkms perl wget bzip2
