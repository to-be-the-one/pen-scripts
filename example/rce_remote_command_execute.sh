#!/bin/env bash

echo -e "input command.\nExample:\n>whoami\n"
echo -n ">"

while read cmd
do
    printf "\033[32m${cmd}\033[0m\n";

    # FIXME: change to correct command
    content=$(python3 ./exploit.py "${cmd} 2>&1" | sed -e '1d')
    printf "\033[33m${content}\033[0m\n";

    echo -n ">"
done
