#!/bin/env bash

:<<!
auth: @cyhfvg https://github.com/cyhfvg
date: 2022/10/27

require: rpcclient

invoke rpcclient's enumXXXX command, save output into *.rpcclient file.
!

if [ $# -lt 1 ]
then
    echo -e "\nUsage: $0 <rpcclient_param>\n"
    echo -e "Example: $0 -N -U thinc.local/uName:pword 192.168.1.3\n"
    printf "\033[33m%s\033[0m is rpcclient's param.\n\n" "-N -U thinc.local/uName%pword 192.168.1.3"
    exit 0
fi

param=""
while [ "$1" != "" ]; do
    if [ -z "${param}" ]
    then
        param="$1"
    else
        param="${param} $1"
    fi
    shift
done

rpcclient_enum_cmd=("enumdomains" "enumdrivers" "enumports" "enumprocdatatypes" "enumdomgroups" "enummonitors" "enumprinters" "enumprocs" "enumdomusers" "enumpermachineconnections" "enumprivs" "enumtrust")

for cmd in ${rpcclient_enum_cmd[*]}
do
    rpc_client="rpcclient ${param} -c '${cmd}'"
    printf "\n\033[33m%s\033[0m\n" "${rpc_client}"

    res=$(eval ${rpc_client})
    if [ -n "${res}" ]
    then
        echo "${res}" | tee "${cmd}.rpcclient"
    fi
done

