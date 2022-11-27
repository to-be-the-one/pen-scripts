#!/usr/bin/env -S bash

:<<!
auth: @cyhfvg https://github.com/cyhfvg
date: 2022/07/07

require nothing!

the simplest port scanner (script)

check target ip's ports is up when in a box without tools like ssh, nmap, nc etc...
!

# usage
if [ $# -lt 1 ]; then
    echo -e "usage:\nbash $0 192.168.1.1"
    exit 0
fi

# main
host=$1
for port in {1..65535}; do
    timeout .1 bash -c "echo >/dev/tcp/${host}/${port}" >/dev/null 2>&1 && echo "port ${port} is open"
done

echo "Done"
