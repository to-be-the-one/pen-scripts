#!/bin/bash

# require `nc`
#
# the simplest port scanner (script)
#
# check target ip's ports is up when in a box without tools like ssh, nmap etc...


# usage
if [ $# -lt 1 ]; then
    echo -e "usage:\nbash $0 192.168.0.1"
    exit 0
fi

# main
ip=$1
for port in $(seq 65535); do
    # exec `nc`
    nc -z -w 5 ${ip} ${port}
    if [ $? -eq 0 ]; then
        echo "${ip}:${port} open"
    fi
done

echo -e "\n--- scan over."
