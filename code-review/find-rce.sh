#!/usr/bin/env -S bash

:<<!
auth: @cyhfvg https://github.com/cyhfvg
date: 2022/06/26

find RCE for everything.

usage:
script.sh ./**/*.py
!

set -euo pipefail
cd ${0%/*}

if [ $# -lt 1 ]; then
    echo "Usage: $0 ./**/*.py"
    exit 1
fi

files=$1

# find RCE for python {{{1
grep --color=auto -nRPH "subprocess|\.run|exec(utable)?" "$files"
# eval
grep --color -niRP "eval(?=\([^)]+\))" "$files"
#}}}
