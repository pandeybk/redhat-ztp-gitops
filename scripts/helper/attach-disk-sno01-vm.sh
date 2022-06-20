
export HUB_CLUSTER_NAME="hubztp"
sudo qemu-img create -f qcow2 /opt/ssd/${HUB_CLUSTER_NAME}/disk-sno01.qcow2 50G

cat <<EOF > /opt/ssd/${HUB_CLUSTER_NAME}/disk-sno01.xml
<disk type='file' device='disk'>
    <driver name='qemu' type='qcow2'/>
    <source file='/opt/ssd/${HUB_CLUSTER_NAME}/disk-sno01.qcow2'/>
    <target dev='vdb' bus='virtio'/>
</disk>
EOF

virsh attach-device ${HUB_CLUSTER_NAME}-sno01 /opt/ssd/${HUB_CLUSTER_NAME}/disk-sno01.xml --persistent

## ssh to each vm and run following
sudo wipefs -a /dev/vdb
