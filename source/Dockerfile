FROM ubuntu:latest

ENV TZ=Europe/Warsaw
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

LABEL Author='Maciej Rachuna'
LABEL Application='PXE Server'
LABEL Version='${jenkins_include_version}'
LABEL JenkinsJob='${jenkins_include_jenkinsJob}'
ENV Version='${jenkins_include_version}'

# update the username and password
# ENV PXE_PASS='${jenkins_include_admin_password}'
ENV PXE_PASS='password'

ADD source/tftpboot/ /tftpboot/
COPY source/etc/nginx/sites-enabled/default /etc/nginx/sites-enabled/default
COPY source/etc/default/tftpd-hpa /etc/default/tftpd-hpa
COPY source/dockerExec.sh /

RUN apt-get update && \
    apt-get install -y tftpd-hpa pxelinux syslinux-common wget nginx p7zip-full p7zip-rar cpio && \
    ### CREATE tftpboot
    mkdir -p -m 0755 /tftpboot && \
    cp /usr/lib/syslinux/modules/bios/*.c32 /tftpboot/ && \
    cp /usr/lib/PXELINUX/pxelinux.0 /tftpboot/pxelinux.0 && \
    chmod +x /dockerExec.sh && \
    chown -R tftp: /tftpboot/* && \
    export pxe_hash=$(openssl passwd -1 ${PXE_PASS}) && \
    find /tftpboot -type f -exec sed -i -e "s|<<password>>|$pxe_hash|g" {} \;

CMD /dockerExec.sh
EXPOSE 80 69/udp