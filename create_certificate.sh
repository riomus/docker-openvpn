#!/bin/bash
cd "$(dirname "$0")"

source ./env.sh

echo "Please provide client name"
read -e client_name

docker run -v $OVPN_DATA:/etc/openvpn --rm -it kylemanna/openvpn easyrsa build-client-full $client_name nopass

docker run -v $OVPN_DATA:/etc/openvpn --rm kylemanna/openvpn ovpn_getclient $client_name > $client_name.ovpn