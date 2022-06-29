#!/bin/bash

:<<!
auth: @cyhfvg https://github.com/cyhfvg
date: 2022/06/26

find RCE for everything.

usage:
script.sh ./**/*.py
!

files=$1

# find RCE for python
grep --color=auto -nRPH "subprocess|\.run|exec(utable)?" "$files"

