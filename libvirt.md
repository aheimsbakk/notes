# `libvirt`

Installing a small Debian VM from scratch. This is done on Fedora 32.

## Preparations

### Install software

`libvirt` is already installed on Fedora 32. It's used in Gnome Boxes. We will not use that for this. We'll do it the old fashioned way with `virt-install`.

```bash
sudo dnf install -y virt-manager virt-install
```

### Let user access `libvirt`

Become a `libvirt` user on the system.

```bash
sudo usermod -aG libvirtd $USER
```

## Installation

1. Create a default `preseed.cfg` file. It contain a random root password for this installation. We change the installation to be atomic layout, just one big partition.
    ```bash
    osinfo-install-script -p jeos debian10
    sed -i 's/home/oneroot/' preseed.cfg
    cat <<EOF >> preseed.cfg
    d-i partman-basicfilesystems/no_swap boolean false
    d-i partman-auto/expert_recipe string oneroot :: 1000 50 -1 ext4 \\
     \$primary{ } \$bootable{ } method{ format } \\
     format{ } use_filesystem{ } filesystem{ ext4 } \\
     mountpoint{ / } \\
    .
    EOF
    ```
0. Edit `preseed.cfg` and make your customations.
0. Install VM. Send back some information to the community with popularity contest.
    ```bash
    virt-install --connect qemu:///system \
      --console pty,target_type=serial \
      --disk size=10,driver.discard=unmap,target.bus=virtio \
      --graphics none \
      --initrd-inject preseed.cfg \
      --location http://ftp.no.debian.org/debian/dists/buster/main/installer-amd64 \
      --name debian10 \
      --os-type linux \
      --os-variant debian10 \
      --ram 2024 \
      --vcpus 4 \
      --extra-args 'console=ttyS0,115200n8 serial locale=nb_NO keymap=no auto=true mirror/country=manual mirror/http/hostname=ftp.no.debian.org mirror/http/directory=/debian mirror/http/proxy= passwd/make-user=false popularity-contest/participate=true file=/preseed.cfg'
    ```

<!---
# vim: set spell spelllang=en:
-->
