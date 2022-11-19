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
if [ 0 == "$(id -u)" ]; then
    is_super=1
    priv="root"
    echo "current user is root user!!!"
fi

if [ ! -d "${out_dir}/$(whoami)" ] ; then
    mkdir -p "${out_dir}/$(whoami)"
fi

# current user info {{{1
(id ; echo "" ; \
    whoami ; echo ""; \
    w ; echo "" ; \
    who am i ; echo "";) &> "${out_dir}/$(whoami)/cur_user_info${ext}"
echo "DONE! current user info.";
# }}}

# hostname , linux version, kernel version, arch {{{1
(hostname ;echo "" ; \
    cat /etc/issue ; echo "" ; \
    cat /etc/*-release ; echo "" ; \
    uname -a ; echo "" ; \
    arch; echo "";) &> "${out_dir}/$(whoami)/os_version${ext}"
echo "DONE! os version info.";
# }}}

# users {{{1
(cat /etc/passwd ; echo "" ; \
    ls -alh /home ; echo "") &> "${out_dir}/$(whoami)/users${ext}"
echo "DONE! user list.";
# }}}

# hashes {{{1
if [ 1 -eq $is_super ]; then
    (cat /etc/shadow ; echo "" ; ) &> "${out_dir}/$(whoami)/shadow${ext}"
    echo "DONE! hash list.";
fi
# }}}

# process {{{1
(ps -ef ; echo "") &> "${out_dir}/$(whoami)/process${ext}"
echo "DONE! process list.";
# }}}

# network {{{1
(ifconfig -a ; echo "" ; \
    ip a ; echo "" ; \
    route ; echo "" ; \
    routel ; echo "" ; \
    netstat -pantuo ; echo "" ; \
    ss -anp ; echo "" ;) &> "${out_dir}/$(whoami)/network${ext}"
echo "DONE! network info.";
# }}}

# firewall {{{1
if [ 1 -eq $is_super ]; then
    (iptables -L ; echo "" ; ) &> "${out_dir}/$(whoami)/firewall${ext}"
    echo "DONE! firewall info.";
fi
# }}}

# schtask {{{1
(ls -alh /etc/cron* ; echo "" ; \
    cat /etc/crontab ; echo "" ;) &> "${out_dir}/$(whoami)/schtasks${ext}"
echo "DONE! cron task list.";
# }}}

# writable directories {{{1
if [ 1 -ne $is_super ]; then
    (find / -writable -type d 2>/dev/null ; echo "" ) &> "${out_dir}/$(whoami)/writable_dir${ext}"
    echo "DONE! writable directory list.";
fi
# }}}

# disk {{{1
(mount ; echo "" ; \
    df -h ; echo "" ; \
    lsblk ; echo "" ;) &> "${out_dir}/$(whoami)/disk${ext}"
echo "DONE! disk list.";
# }}}

# special bin file {{{1
if [ 1 -ne $is_super ]; then
    (echo -e ">>> suid\n"; find / -type f -perm -u=s 2>/dev/null ; echo "" ; \
     echo -e ">>> sgid\n";  find / -type f -perm /2000 2>/dev/null ; echo "" ; \
     echo -e ">>> suid/sgid\n";  find / -type f -perm /6000 2>/dev/null ; echo "" ;) &> "${out_dir}/$(whoami)/special_bin${ext}"
    echo "DONE! suid/guid bin list.";
fi
# }}}
