# pxe
Pxe docker


mrachuna@nbo-rachuna-002:~ $ docker run -dit --name pxe -p 80:80 -p 69:69/udp pxe bash

mrachuna@nbo-rachuna-002:~ $ docker stop pxe && docker rm pxe

mrachuna@nbo-rachuna-002:~ $ docker exec -it pxe bash

password

openssl passwd -1 password
Password: 
Verifying - Password: 
$1$0FfFLZq3$u4yCdORcBAeZaXx1WUeV.0


Mount the proxmox iso in a temporal directory:
# mount proxmox-ve_3.3-a06c9f73-2.iso proxmox-iso/
Copy “proxmox-iso/boot/initrd.img” and “proxmox-iso/boot/linux26” to a temp directory 'initrd-temp':
# mkdir initrd-temp
# cp proxmox-iso/boot/initrd.img ./initrd-temp
# cp proxmox-iso/boot/linux26 ./initrd-temp
Move to 'initrd-temp' directory and rename “initrd.img” to “initrd.org.img”, then unzip it:
# cd initrd-temp
# mv initrd.img initrd.org.img
# gzip -d -S ".img" ./initrd.org.img
Create a directory 'initrd.tmp' for the files in the initrd, extract initrd to this directory:
# mkdir initrd.tmp
# cd initrd.tmp
# cpio -i -d < ../initrd.org
Umount the Proxmox ISO and copy it as proxmox.iso:
# umount ../../proxmox-iso/
# cp ../../proxmox-ve_3.3-a06c9f73-2.iso proxmox.iso
Create a new initrd.img:
# find . | cpio -H newc -o > ../initrd
Zip this new initrd:
# cd ..
# gzip -9 -S ".img" initrd


 2243  mkdir initrd-temp
 2244  cp /media/mrachuna/PVE/boot/linux26 .
 2245  cp /media/mrachuna/PVE/boot/initrd.img .
 2246  mv initrd.img initrd.org.img
 2247  gzip -d -S ".img" ./initrd.org.img
 2248  mkdir initrd.tmp
 2249  cd initrd.tmp
 2250  cpio -i -d < ../initrd.org
 2251  cp ~/Pobrane/proxmox-ve_6.3-1.iso .
 2252  ls -l
 2253  mv proxmox-ve_6.3-1.iso proxmox-ve_6.3-1.iso 
 2254  mv proxmox-ve_6.3-1.iso proxmox.iso 
 2255  ls -l
 2256  mv proxmox.iso ../../
 2257  ls -l
 2258  rm ../../proxmox.iso 
 2259  cp ~/Pobrane/proxmox-ve_6.3-1.iso proxmox.iso
 2260  find . | cpio -H newc -o > ../initrd
 2261  cd ..
 2262  gzip -9 -S ".img" initrd
 2263  ls -l