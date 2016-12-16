#!/bin/bash
cd "$(dirname "$0")"

source ./env.sh

echo "Data volume is $OVPN_DATA"

if  [[ -z `docker volume ls | grep $OVPN_DATA` ]]; then
	echo "Please provide address"
	read -e address
	address="udp://$address:1194"
	echo "Configuring for address $address"
	docker volume create --name $OVPN_DATA
	docker run -v $OVPN_DATA:/etc/openvpn --rm kylemanna/openvpn ovpn_genconfig -u $address
	docker run -v $OVPN_DATA:/etc/openvpn --rm -it kylemanna/openvpn ovpn_initpki
fi

echo "Docker image with name $CONTAINER_NAME"

if  docker ps -a | grep -q $CONTAINER_NAME 
 then docker start $CONTAINER_NAME
 else docker run -v $OVPN_DATA:/etc/openvpn -d -p 1194:1194/udp --cap-add=NET_ADMIN  --restart=always --name=$CONTAINER_NAME  kylemanna/openvpn 
fi
