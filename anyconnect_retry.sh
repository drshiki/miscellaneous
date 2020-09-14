#!/bin/bash
# for safe exit
# set -xeuo pipefail

# Anyconnect retry connect and add iptables rule to accept all traffic to dockers  
# 2020,9,14 by Hai-chien Teng

# check per 60 seconds
while true
do
    # determinate if connected
    found=`ip a | grep 10.10.10| wc -l`
    if [ "$found" -eq 0 ]
    then

        echo "Ready to connect VPN server..."
        printf 'username\npassword\ny' | /opt/cisco/anyconnect/bin/vpn -s connect xx.xxx.com

        # Wait for HTTP establishment
        sleep 5

        # determinate if connnect fail
        found=`ip a | grep 10.10.10| wc -l`
        if [ "$found" -eq 0 ]
            then 
                # retry connect
                echo "Retry connect..."
                continue
        fi  
        echo "connected!!!"
    else 
        ip=`ip a | grep 10.10.10 | sed -r 's/.*\s(.*)\/.*/\1/'`
        echo "There are already connected, ip is $ip"
    fi

    # determinate if the ACCEPT rule was added
    foundrule=`sudo iptables -vnL ciscovpn | sed -n '3p' | grep cscotun0`
    if [ ! "$foundrule" ]
    then
        sudo iptables -t filter -I ciscovpn -i cscotun0 -p all -j ACCEPT
        echo "Add ACCEPT rule"
    fi

    # check per 60 seconds
    sleep 60
done