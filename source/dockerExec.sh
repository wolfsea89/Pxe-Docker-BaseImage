#!/bin/bash

download_ubuntu16_source(){
  echo "*** DOWNLOAD UBUNTU 16 ***"
  mkdir -p -m -755 /tftpboot/kernel/ubuntu-server/16.04/
  wget http://archive.ubuntu.com/ubuntu/dists/xenial-updates/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/linux -P /tftpboot/kernel/ubuntu-server/16.04/
  wget http://archive.ubuntu.com/ubuntu/dists/xenial-updates/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/initrd.gz -P /tftpboot/kernel/ubuntu-server/16.04/
}

download_ubuntu18_source(){
  echo "*** DOWNLOAD UBUNTU 18 ***"
  mkdir -p -m -755 /tftpboot/kernel/ubuntu-server/18.04/
  wget http://archive.ubuntu.com/ubuntu/dists/bionic-updates/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/linux -P /tftpboot/kernel/ubuntu-server/18.04/
  wget http://archive.ubuntu.com/ubuntu/dists/bionic-updates/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/initrd.gz -P /tftpboot/kernel/ubuntu-server/18.04/
}

download_ubuntu20_source(){
  echo "*** DOWNLOAD UBUNTU 20 ***"
  mkdir -p -m -755 /tftpboot/kernel/ubuntu-server/20.04/
  wget http://archive.ubuntu.com/ubuntu/dists/focal-updates/main/installer-amd64/current/legacy-images/netboot/ubuntu-installer/amd64/linux -P /tftpboot/kernel/ubuntu-server/20.04/
  wget http://archive.ubuntu.com/ubuntu/dists/focal-updates/main/installer-amd64/current/legacy-images/netboot/ubuntu-installer/amd64/initrd.gz -P /tftpboot/kernel/ubuntu-server/20.04/
}

create_proxmox6-3_source(){
  echo "*** DOWNLOAD PROXMOX ***"
  echo "* Create path *"
  mkdir -p -m -755 /tftpboot/kernel/proxmox/6.3
  mkdir -p -m -755 /tmp/proxmox
  mkdir -p -m -755 /tmp/proxmox/initrd-temp
  mkdir -p -m -755 /tmp/proxmox/initrd-temp/initrd.tmp

  echo "* Download ISO from: http://download.proxmox.com/iso/proxmox-ve_6.3-1.iso *"
  if [ ! -e  /tmp/proxmox/proxmox-ve_6.3-1.iso ]; then
    cd /tmp/proxmox && wget http://download.proxmox.com/iso/proxmox-ve_6.3-1.iso
  fi

  echo "* Prepare proxmox image *"
  cd /tmp/proxmox && 7z x proxmox-ve_6.3-1.iso
  cp /tmp/proxmox/boot/initrd.img /tmp/proxmox/initrd-temp
  cp /tmp/proxmox/boot/linux26 /tftpboot/kernel/proxmox/6.3

  echo "* Customise initrd.img *"
  cd /tmp/proxmox/initrd-temp && gzip -d -S ".img" /tmp/proxmox/initrd-temp/initrd.img 
  cd /tmp/proxmox/initrd-temp/initrd.tmp && cpio -i -d < /tmp/proxmox/initrd-temp/initrd
  cp /tmp/proxmox/proxmox-ve_6.3-1.iso /tmp/proxmox/initrd-temp/initrd.tmp/proxmox.iso
  cd /tmp/proxmox/initrd-temp/initrd.tmp && find . | cpio -H newc -o > ../initrd
  cd /tmp/proxmox/initrd-temp/ && gzip -9 -S ".img" initrd
  mv /tmp/proxmox/initrd-temp/initrd.img /tftpboot/kernel/proxmox/6.3/

  echo "* Clean *"
  rm -fr /tmp/proxmox
}

clean(){
  apt-get purge p7zip-full p7zip-rar cpio 
}


download_ubuntu16_source
download_ubuntu18_source
download_ubuntu20_source
create_proxmox6-3_source


in.tftpd -u root -L -vvv /tftpboot
#apachectl -D FOREGROUND