# Pxe-Docker-BaseImage

Serwer PXE (ang. Preboot Execution Environment) umożliwia uruchomienie na komputerze systemu operacyjnego, mimo że nie jest on na nim zainstalowany. Komputer taki nie musi posiadać żadnych urządzeń mogących przechowywać system (takich jak dysk twardy, stacja dyskietek, napęd CDROM, dyski USB, czy inne).

Na potrzeby projektu Serwer PXE posiada obrazy do zainstalowania systemów operacyjnych takich jak:
 - ProxMox 6.3
 - Ubuntu 16.04 LTS 
 - Ubuntu 18.04 LTS 
 - Ubuntu 20.04 LTS 

Strkutura w kontenerze
=========

Proces uruchomienia kontenera
1. Uruchomienie uslugi nginx
2. Generowanie obrazów uruchomieniowych dla Ubuntu w /tftpboot/kernel/ubuntu-server
3. Generowanie obrazów uruchomieniowych dla Proxmox w /tftpboot/kernel/proxmox
4. Uruchomienie usługi TFTP


Lista plików
```
/tftpboot/
|-- boot-screens
|   `-- background.png
|-- kernel
|   |-- proxmox
|   |   `-- 6.3
|   |       |-- initrd.img
|   |       `-- linux26
|   `-- ubuntu-server
|       |-- 16.04
|       |   |-- initrd.gz
|       |   `-- linux
|       |-- 18.04
|       |   |-- initrd.gz
|       |   `-- linux
|       `-- 20.04
|           |-- initrd.gz
|           `-- linux
|-- menus
|   |-- install_systems.cfg
|   `-- layout.cfg
|-- pxelinux.cfg
|   `-- default
|-- www
    |-- index.html
    `-- kickstart
        `-- ubuntu
            |-- 16.04
            |   `-- server.cfg
            |-- 18.04
            |   `-- server.cfg
            `-- 20.04
                `-- server.cfg
```

Konfiguracja serwera DHCP na mikrotik
=========
```
/ip dhcp-server network add \
    address=10.1.0.0/24 \
    boot-file-name=/tftpboot/pxelinux.0 \
    comment="Users Network" \
    dns-server=10.1.0.1 \
    domain=rachuna.net gateway=10.1.0.1 \
    next-server=10.1.0.2 \
```
Uruchomienie usługi w dockerze
=========
```
docker run -d --name pxe-server -p 80:80 -p 69:69/udp wolfsea89/pxe-server:1.0.0.X
```


Tips
=========
Generowanie hasła, które jest osadzone source/tftpboot/menus/install_systems.cfg w lini 4 w miejscu << password >>
```
openssl passwd -1 password
```

Author Information
=========
 **Maciej Rachuna**
##### System Administrator & DevOps Engineer
rachuna.maciej@gmail.com