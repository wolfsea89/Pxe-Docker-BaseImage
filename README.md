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
