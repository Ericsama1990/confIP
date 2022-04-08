#!/bin/bash

#
# confIP.sh es un script per tal de facilitar i automatitzar la tarea de configurar una IP estatica a un servidor linux
#

#
# Dependencies:
#	- nmcli
#


#
# FUNCIO PRINCIPAL
#
myfunction () {

#modifiquem els valors 
	sudo nmcli connection modify '$DEVICE' ipv4.addresses $IPFINAL
	sudo nmcli connection modify '$DEVICE' ipv4.gateway $GATEWAY
	sudo nmcli connection modify '$DEVICE' ipv4.dns $DNS
	sudo nmcli connection modify \'$DEVICE\' ipv4.method manual

#Reiniciem controladora
	sudo nmcli connection down ‘$DEVICE’
	sudo nmcli connection up ‘$DEVICE’

return "0"
}



#Llimpiem la terminal per a focalitzar la informacio.
clear

# Imprimim en pantalla el stat de les nostres controladores de red
printf "%s\n" "INFO DEVICE SYSTEM"
nmcli dev status

# Advertencia + ingres de dades a formatejar. Per defecte la mascara subred sera 255.255.255.0
echo " Warning! you are about to change the IP settings of a network device. \n Be sure to spell this name correctly in the next entry "
read -p "   Ingresa la ID de DEVICE a configurar : " DEVICE
read -p "   Ingresa IP : " IPV4
read -p "   Ingresa Gateway : " GATEWAY
read -p "   Ingresa DNS : " DNS

# Modifiquem la IP seleccionada, donanli un valor de mascara 255.255.255.0 que equival a /24.
STR2="/24"
IPFINAL="$IPV4$STR2"

# Imprimim en pantalla els nous valors ingresats
printf "%s\n" "$DEVICE" "$IPFINAL" "$GATEWAY" "$DNS"

# Preguntem si es vol aplicar els canvis o fer exit.
echo "Do you want to apply these changes? [Y/N]"

while true; do
    read -p "Do you wish to install this program? " yn
    case $yn in
        [Yy]* ) myfunction; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
