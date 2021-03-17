# Pxe-Docker-BaseImage

Serwer PXE (ang. Preboot Execution Environment) umożliwia uruchomienie na komputerze systemu operacyjnego, mimo że nie jest on na nim zainstalowany. Komputer taki nie musi posiadać żadnych urządzeń mogących przechowywać system (takich jak dysk twardy, stacja dyskietek, napęd CDROM, dyski USB, czy inne).

Na potrzeby projektu Serwer PXE posiada obrazy do zainstalowania systemów operacyjnych takich jak:
 - ProxMox 6.3
 - Ubuntu 16.04 LTS 
 - Ubuntu 18.04 LTS 
 - Ubuntu 20.04 LTS 


# Konfiguracja serwera DHCP na mikrotik
```
/ip dhcp-server network add \
    address=10.1.0.0/24 \
    boot-file-name=/tftpboot/pxelinux.0 \
    comment="Users Network" \
    dns-server=10.1.0.1 \
    domain=rachuna.net gateway=10.1.0.1 \
    next-server=10.1.0.2 \
```

Pxe docker




mrachuna@nbo-rachuna-002:~ $ docker run -dit --name pxe -p 80:80 -p 69:69/udp pxe bash

mrachuna@nbo-rachuna-002:~ $ docker stop pxe && docker rm pxe

mrachuna@nbo-rachuna-002:~ $ docker exec -it pxe bash

password

openssl passwd -1 password
Password: 
Verifying - Password: 
$1$0FfFLZq3$u4yCdORcBAeZaXx1WUeV.0
