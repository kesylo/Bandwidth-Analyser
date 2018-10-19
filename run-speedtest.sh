#!/bin/bash

# Variables
ping=""
dwn=""
up=""
ssid1="FAMOCO"
ssid2="FAMOCO-5Ghz"

launch_tests(){
	date +%x > /home/pi/Documents/bandwidthAnalyser/"$1".log

	if [ $4 == 1 ]
	then
		sudo speedtest --simple >> /home/pi/Documents/bandwidthAnalyser/$1.log
	fi

	if [ $4 == 0 ]
	then
		echo 0 >> $1.log
		echo 0 >> $1.log
		echo 0 >> $1.log
	fi

	cat $1.log >> $2.log

	# Retreive data from log and append to tempory file
	cat $1.log | awk 'NR==1' > temp
	ping=$(echo "cat $1.log | awk 'NR==2'" | bash)
	echo $ping | tr ' ' '\n' | grep -E '^[+-]?[0-9]*\.?([0-9]+)$' >> temp
	dwn=$(echo "cat $1.log | awk 'NR==3'" | bash)
	echo $dwn | tr ' ' '\n' | grep -E '^[+-]?[0-9]*\.?([0-9]+)$' >> temp
	up=$(echo "cat $1.log | awk 'NR==4'" | bash)
	echo $up | tr ' ' '\n' | grep -E '^[+-]?[0-9]*\.?([0-9]+)$' >> temp

	# Run Python script to append to Gsheet 
	python2.7 textToGsheet.py $3
	##sleep 8
	echo "Data sent successfully"

	# Cleanup
	rm temp
	rm $1.log
}

### Ethernet
ping -c 2 -I eth0 8.8.8.8 >> /dev/null 2>&1
if [ $? ==  0 ]
then
	echo "Running speedtest on Ethernet link..."
	ifconfig wlan0 down
	sleep 5
	launch_tests "result_Ethernet" "speedtest_Ethernet" 2 1
	sleep 10
else
	echo "Not able to check internet connectivity!"
	launch_tests "result_Ethernet" "speedtest_Ethernet" 2 0
fi

### WIFI
SSID="$(iwgetid -r)"
if [ "$SSID" = "$ssid1" ]; then
	echo "Running speedtest on Wifi links..."
	ifconfig eth0 down
	sleep 5
	launch_tests "result_2ghz" "speedtest_2ghz" 0 1
	#./wifiConnect.sh FAMOCO-5Ghz famocoaccess
	ifconfig eth0 down
	sleep 8
	#launch_tests "result_5ghz" "speedtest_5ghz" 1 1
elif [ "$SSID" = "$ssid2" ]; then
	echo "Running speedtest on Wifi links..."
	ifconfig eth0 down
	sleep 5
	#launch_tests "result_5ghz" "speedtest_5ghz" 1 1
	#./wifiConnect.sh FAMOCO famocoaccess
	ifconfig eth0 down
	sleep 8
	launch_tests "result_2ghz" "speedtest_2ghz" 0 1
elif [ "$SSID" = "" ]; then
	echo "Running speedtest on Wifi links..."
	./wifiConnect.sh FAMOCO famocoaccess
	ifconfig eth0 down
	sleep 10
	ifconfig eth0 down
	launch_tests "result_2ghz" "speedtest_2ghz" 0 1
	sleep 2
	#./wifiConnect.sh FAMOCO-5Ghz famocoaccess
	ifconfig eth0 down
	sleep 8
	#launch_tests "result_5ghz" "speedtest_5ghz" 1 1
else
	echo "Failed to launch tests"
	exit 1
fi






systemctl restart dhcpcd 



