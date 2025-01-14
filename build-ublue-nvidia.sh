#!/bin/sh

set -oeux pipefail

### SETUP nvidia container stuffs

#install -D /etc/pki/akmods/certs/public_key.der /tmp/ublue-os-ucore-nvidia/rpmbuild/SOURCES/public_key.der

mkdir -p /tmp/ublue-os-ucore-nvidia/rpmbuild/SOURCES/

curl -L https://nvidia.github.io/libnvidia-container/stable/rpm/nvidia-container-toolkit.repo \
    -o /tmp/ublue-os-ucore-nvidia/rpmbuild/SOURCES/nvidia-container-toolkit.repo
sed -i "s@gpgcheck=0@gpgcheck=1@" /tmp/ublue-os-ucore-nvidia/rpmbuild/SOURCES/nvidia-container-toolkit.repo

curl -L https://raw.githubusercontent.com/NVIDIA/dgx-selinux/master/bin/RHEL9/nvidia-container.pp \
    -o /tmp/ublue-os-ucore-nvidia/rpmbuild/SOURCES/nvidia-container.pp

rpmbuild -ba \
    --define '_topdir /tmp/ublue-os-ucore-nvidia/rpmbuild' \
    --define '%_tmppath %{_topdir}/tmp' \
    /tmp/ublue-os-ucore-nvidia/ublue-os-ucore-nvidia.spec

mkdir -p /var/cache/rpms/kmods/nvidia

mv /tmp/ublue-os-ucore-nvidia/rpmbuild/RPMS/*/*.rpm \
   /var/cache/rpms/kmods/nvidia/
