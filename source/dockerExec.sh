#!/bin/bash
download_ubuntu16_source(){
  echo "*** DOWNLOAD UBUNTU 16.04 ***"
  sed -i 's/<p>Status: .*<\/p>/<p>Status: Prepare - Ubuntu 16.04<\/p>/g' /tftpboot/www/index.html
  mkdir -p -m -755 /tftpboot/kernel/ubuntu-server/16.04/
  wget http://archive.ubuntu.com/ubuntu/dists/xenial-updates/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/linux -P /tftpboot/kernel/ubuntu-server/16.04/
  wget http://archive.ubuntu.com/ubuntu/dists/xenial-updates/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/initrd.gz -P /tftpboot/kernel/ubuntu-server/16.04/
}

download_ubuntu18_source(){
  echo "*** DOWNLOAD UBUNTU 18.04 ***"
  mkdir -p -m -755 /tftpboot/kernel/ubuntu-server/18.04/
  sed -i 's/<p>Status: .*<\/p>/<p>Status: Prepare - Ubuntu 18.04<\/p>/g' /tftpboot/www/index.html
  wget http://archive.ubuntu.com/ubuntu/dists/bionic-updates/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/linux -P /tftpboot/kernel/ubuntu-server/18.04/
  wget http://archive.ubuntu.com/ubuntu/dists/bionic-updates/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/initrd.gz -P /tftpboot/kernel/ubuntu-server/18.04/
}

download_ubuntu20_source(){
  echo "*** DOWNLOAD UBUNTU 20.04 ***"
  sed -i 's/<p>Status: .*<\/p>/<p>Status: Prepare - Ubuntu 20.04<\/p>/g' /tftpboot/www/index.html
  mkdir -p -m -755 /tftpboot/kernel/ubuntu-server/20.04/
  wget http://archive.ubuntu.com/ubuntu/dists/focal-updates/main/installer-amd64/current/legacy-images/netboot/ubuntu-installer/amd64/linux -P /tftpboot/kernel/ubuntu-server/20.04/
  wget http://archive.ubuntu.com/ubuntu/dists/focal-updates/main/installer-amd64/current/legacy-images/netboot/ubuntu-installer/amd64/initrd.gz -P /tftpboot/kernel/ubuntu-server/20.04/
}

create_proxmox6-3_source(){
  echo "*** DOWNLOAD PROXMOX ***"
  sed -i 's/<p>Status: .*<\/p>/<p>Status: Prepare - Proxmox<\/p>/g' /tftpboot/www/index.html
  echo "* Create path *"
  mkdir -p -m -755 /tftpboot/kernel/proxmox/6.3
  mkdir -p -m -755 /tmp/proxmox
  mkdir -p -m -755 /tmp/proxmox/initrd-temp
  mkdir -p -m -755 /tmp/proxmox/initrd-temp/initrd.tmp

  if [ ! -e  /tmp/proxmox/proxmox-ve_6.3-1.iso ]; then
    echo "* Download ISO from: http://download.proxmox.com/iso/proxmox-ve_6.3-1.iso *"
    sed -i 's/<p>Status: .*<\/p>/<p>Status: Prepare - Proxmox - Download ISO<\/p>/g' /tftpboot/www/index.html
    cd /tmp/proxmox && wget http://download.proxmox.com/iso/proxmox-ve_6.3-1.iso
  fi

  sed -i 's/<p>Status: .*<\/p>/<p>Status: Prepare - Proxmox - Prepere custom initrd.img<\/p>/g' /tftpboot/www/index.html
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

sed -i "s/<p>Version: .*<\/p>/<p>Version: $Version<\/p>/g" /tftpboot/www/index.html

service nginx start

download_ubuntu16_source
download_ubuntu18_source
download_ubuntu20_source
create_proxmox6-3_source

sed -i 's/<p>Status: .*<\/p>/<p>Status: Working<\/p>/g' /tftpboot/www/index.html

in.tftpd -u root -L -vvv /tftpboot