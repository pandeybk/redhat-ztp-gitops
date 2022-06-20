#!/bin/bash

export CLUSTER_NAME="snohub"
export NAME_BRIDGE="br0"
export MAC_ADDRESS_MODIFIER="f"

sudo mkdir -p /opt/ssd/${CLUSTER_NAME} /opt/ssd/boot
sudo qemu-img create -f qcow2 /opt/ssd/${CLUSTER_NAME}/hub01.qcow2 200G

virt-install \
  --name=${CLUSTER_NAME}-master-1 \
  --ram=40960 \
  --vcpus=16 \
  --cpu host-passthrough \
  --os-type linux \
  --os-variant rhel8.0 \
  --noreboot \
  --events on_reboot=restart \
  --noautoconsole \
  --boot hd,cdrom \
  --import \
  --disk path=/opt/ssd/${CLUSTER_NAME}/hub01.qcow2,size=200 \
  --disk /opt/ssd/boot/discovery_image_${CLUSTER_NAME}.iso,device=cdrom \
  --network type=direct,source=${NAME_BRIDGE},mac=00:00:00:00:00:${MAC_ADDRESS_MODIFIER}1,source_mode=bridge,model=virtio


virsh start ${CLUSTER_NAME}-master-1


sudo qemu-img create -f qcow2 /opt/ssd/${CLUSTER_NAME}/disk-hub01.qcow2 50G
cat <<EOF > /opt/ssd/${CLUSTER_NAME}/disk-hub01.xml
<disk type='file' device='disk'>
    <driver name='qemu' type='qcow2'/>
    <source file='/opt/ssd/${CLUSTER_NAME}/disk-hub01.qcow2'/>
    <target dev='vdb' bus='virtio'/>
</disk>
EOF
virsh attach-device ${CLUSTER_NAME}-master-1 /opt/ssd/${CLUSTER_NAME}/disk-hub01.xml --persistent
sudo wipefs -a /dev/vdb
