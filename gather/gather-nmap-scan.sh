#!/usr/bin/env -S bash

:<<!
auth: @cyhfvg https://github.com/cyhfvg
date: 2022/06/26

nmap scan script.
!

set -euo pipefail
cd ${0%/*}

if [ $# -ne 1 ]; then
    echo -e "Usage:\t$0 192.168.0.1"
    exit 1
fi

host=$1

echo -e "scan ${host} all tcp port...\n"
portScanDir="."

# scan all ports
# scan tcp ports
nmap -T4 -Pn -n -v -sS -p- -oN ${portScanDir}/all-port.nmap "$host" && \
    tcpPorts=$(cat ${portScanDir}/all-port.nmap | grep -oP "^\d+(?=/tcp\s+open)" | tr '\n' ',') && \
    echo "scan ${host} tcp port..." && \
    nmap -T4 -Pn -n -v -sSVC -p "${tcpPorts%,*}" -oN ${portScanDir}/tcp.nmap "$host";

# scan udp ports top 1000
# echo "scan ${host} top 1000 udp port..."
nmap -T4 -v -sU --top-ports 1000 -oN "${portScanDir}/udp.nmap" "$host"
