#!/bin/sh
## Simple WIFI command line connector 
## Usage: 
## sudo ./wifiConnector.sh <SSID> <PASSWORD>

## Usage message
display_usage() {
echo "This script must be run with super-user privileges and receive 2 arguments."
echo "eg: sudo ./wifiConnector.sh <SSID> <PASSWORD>"
exit 1
}

## Check if root access
if [ "$(id -u)" != "0" ]; then
display_usage
fi

## Check if user gives enough parameters
if [ "$#" -ne 2 ]; then
display_usage
fi

echo "Connecting to $1..."
systemctl restart dhcpcd

sleep 10

ifconfig eth0 down

## Append config to the wifi file
cat <<EOT > /etc/wpa_supplicant/wpa_supplicant.conf
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
country=FR

network={
        ssid="$1"
        psk="$2"
}
EOT

systemctl restart dhcpcd

sleep 10


## Show wifi connection status
#iwconfig wlan0
SSID="$(iwgetid -r)"
if [ "$SSID" = "$1" ]; then
	echo "Connected to $1"
else
	echo "Failed to connect to $1"
fi


