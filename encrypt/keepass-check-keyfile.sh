#!/usr/bin/env -S bash

:<<!
auth: @cyhfvg https://github.com/cyhfvg
date: 2022/06/26

check which file is right key file for *.kdbx database file.(keepass)

required:
1. database file (*.kdbx)
2. key files (which you want to check)
3. right password for database

dependency:
$ sudo apt install kpcli -y

ref:
[hackthebox Safe](https://app.hackthebox.com/machines/Safe)
[Safe - WriteUp](https://www.tagnull.de/post/safe/)
!

set -euo pipefail
cd ${0%/*}

# change this {{{1
PASS=bullshit
DB_FILE=MyPasswords.kdbx
FILE_LIST=(./*.JPG)
#}}}

# color defination {{{1
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NONE='\033[0m'
#}}}


for keyfile in "${FILE_LIST[@]}" ; do
    # check is keyfile correct?
    if echo $PASS | kpcli --kdb $DB_FILE --key "$keyfile" --command quit >/dev/null 2>&1; then
        printf "${GREEN}OK${NONE}: ${YELLOW}%s${NONE}" "${keyfile}";
        break
    fi
done
