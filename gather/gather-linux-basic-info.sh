#!/bin/bash

:<<!
auth: @cyhfvg https://github.com/cyhfvg
date: 2022/10/21

Gather useful linux info for priv-esca,
output information into a directory.
!

if [ 0 == $# ]; then
    echo "Usage:    bash $0 /dir/to/output";
    exit 0
fi

out_dir=$1
priv="normal"
is_super=0
ext=".txt"

# root user
if [ 0 == $(id | cut -d"=" -f2 | cut -d"(" -f1) ]; then
    is_super=1
    priv="root"
fi

if [ ! -d ${out_dir}/${priv} ] ; then
    mkdir -p ${out_dir}/${priv}
fi

# current user info {{{1
(id ; echo "" ; \
    whoami ; echo ""; \
    w ; echo "" ; \
    who am i ; echo "";) &> "${out_dir}/${priv}/cur_user_info${ext}"
# }}}

# hostname , linux version, kernel version, arch {{{1
(hostname ;echo "" ; \
    cat /etc/issue ; echo "" ; \
    cat /etc/*-release ; echo "" ; \
    uname -a ; echo "" ; \
    arch; echo "";) &> "${out_dir}/${priv}/os_version${ext}"
# }}}

# users {{{1
(cat /etc/passwd ; echo "" ; \
    ls -alh /home ; echo "") &> "${out_dir}/${priv}/users${ext}"
# }}}

# hashes {{{1
if [ $is_super ]; then
    (cat /etc/shadow ; echo "" ; ) &> "${out_dir}/${priv}/shadow${ext}"
fi
# }}}

# process {{{1
(ps -ef ; echo "") &> "${out_dir}/${priv}/process${ext}"
# }}}

# network {{{1
(ifconfig -a ; echo "" ; \
    ip a ; echo "" ; \
    route ; echo "" ; \
    routel ; echo "" ; \
    netstat -pantuo ; echo "" ; \
    ss -anp ; echo "" ;) &> "${out_dir}/${priv}/network${ext}"
# }}}

# firewall {{{1
if [ $is_super ]; then
    (iptables -L ; echo "" ; ) &> "${out_dir}/${priv}/firewall${ext}"
fi
# }}}

# schtask {{{1
(ls -alh /etc/cron* ; echo "" ; \
    cat /etc/crontab ; echo "" ;) &> "${out_dir}/${priv}/schtasks${ext}"
# }}}

# writable directories {{{1
if [ ! $is_super ]; then
    (find / -writable -type d 2>/dev/null ; echo "" ) &> "${out_dir}/${priv}/writable_dir${ext}"
fi
# }}}

# disk {{{1
(mount ; echo "" ; \
    df -h ; echo "" ; \
    lsblk ; echo "" ;) &> "${out_dir}/${priv}/disk${ext}"
# }}}

# special bin file {{{1
if [ ! $is_super ]; then
    (find / -type f -perm -u=s 2>/dev/null ; echo "" ; \
        find / -type f -perm /2000 2>/dev/null ; echo "" ; \
        find / -type f -perm /6000 2>/dev/null ; echo "" ;) &> "${out_dir}/${priv}/special_bin${ext}"
fi
# }}}
