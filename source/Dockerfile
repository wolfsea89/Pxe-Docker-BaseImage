FROM ubuntu:latest

ENV TZ=Europe/Warsaw
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

LABEL Author='Maciej Rachuna'
LABEL Application='PXE Server'
LABEL Version='${jenkins_include_version}'
LABEL JenkinsJob='${jenkins_include_jenkinsJob}'

# update the username and password
# ENV PXE_PASS='${jenkins_include_admin_password}'
ENV PXE_PASS='password'

RUN apt-get update && \
    apt-get install -y tftpd-hpa pxelinux syslinux-common wget && \
    ### CREATE tftpboot
    mkdir -p -m 0755 /tftpboot && \
    cp /usr/lib/syslinux/modules/bios/*.c32 /tftpboot/ && \
    cp /usr/lib/PXELINUX/pxelinux.0 /tftpboot/pxelinux.0

ADD source/tftpboot/ /tftpboot/
COPY source/etc/apache2/apache2.conf /etc/apache2/apache2.conf
COPY source/etc/apache2/sites-enabled/000-default.conf /etc/apache2/sites-enabled/000-default.conf
COPY source/etc/default/tftpd-hpa /etc/default/tftpd-hpa

RUN mkdir -p -m -755 /tftpboot/kernel/ubuntu-server/16.04/ && \
    wget http://archive.ubuntu.com/ubuntu/dists/xenial-updates/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/linux -P /tftpboot/kernel/ubuntu-server/16.04/ && \
    wget http://archive.ubuntu.com/ubuntu/dists/xenial-updates/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/initrd.gz -P /tftpboot/kernel/ubuntu-server/16.04/ && \
    mkdir -p -m -755 /tftpboot/kernel/ubuntu-server/18.04/ && \
    wget http://archive.ubuntu.com/ubuntu/dists/bionic-updates/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/linux -P /tftpboot/kernel/ubuntu-server/18.04/ && \
    wget http://archive.ubuntu.com/ubuntu/dists/bionic-updates/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/initrd.gz -P /tftpboot/kernel/ubuntu-server/18.04/ && \
    mkdir -p -m -755 /tftpboot/kernel/ubuntu-server/20.04/ && \
    wget http://archive.ubuntu.com/ubuntu/dists/focal-updates/main/installer-amd64/current/legacy-images/netboot/ubuntu-installer/amd64/linux -P /tftpboot/kernel/ubuntu-server/20.04/ && \
    wget http://archive.ubuntu.com/ubuntu/dists/focal-updates/main/installer-amd64/current/legacy-images/netboot/ubuntu-installer/amd64/initrd.gz -P /tftpboot/kernel/ubuntu-server/20.04/


RUN chown -R tftp: /tftpboot/* && \
    export pxe_hash=$(openssl passwd -1 ${PXE_PASS}) && \
    find /tftpboot -type f -exec sed -i -e "s|<<password>>|$pxe_hash|g" {} \;

CMD in.tftpd -u root -L -vvv /tftpboot; apachectl -D FOREGROUND
EXPOSE 80 69/udp