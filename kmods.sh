#!/bin/sh

set -oeux pipefail

cp /tmp/ublue-os-akmods-addons/rpmbuild/SOURCES/_copr_ublue-os-akmods.repo /etc/yum.repos.d/

ARCH="$(rpm -E '%_arch')"
KERNEL="$(rpm -q "${KERNEL_NAME}" --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')"
RELEASE="$(rpm -E '%fedora')"

rpm-ostree install \
    akmod-gcadapter_oc-*.fc${RELEASE}.${ARCH}
akmods --force --kernels "${KERNEL}" --kmod gcadapter_oc
modinfo /usr/lib/modules/${KERNEL}/extra/gcadapter_oc/gcadapter_oc.ko.xz > /dev/null \
|| (find /var/cache/akmods/gcadapter_oc/ -name \*.log -print -exec cat {} \; && exit 1)