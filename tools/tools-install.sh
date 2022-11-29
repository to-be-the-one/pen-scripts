#!/usr/bin/env -S bash

:<<!
auth: @cyhfvg https://github.com/cyhfvg
date: 2022/11/28

install penetration test tools automatically.
!

set -euo pipefail
cd ${0%/*}

# install tools by apt {{{1
#
# shells
defer_1=("rlwrap" "zsh" "ncat")

# services
defer_2=("vsftpd")

# web (proxy, subdomain, webspidering, fuzzing, vulnerability, exploit)
defer_3=("subfinder" "dnsmap" "gospider" "whatweb" "wafw00f" "gobuster" "ffuf" "dirbuster" \
    "nuclei" "nikto" "wpscan" "exploitdb" "sqlmap" "httpx-toolkit" "httprobe")
defer_3_gui=("burpsuite")

# network scan sniffer
defer_4=("nmap" "masscan" "enum4linux" "tcpdump")
defer_4_gui=("wireshark")

# wordlist, resources
defer_5=("seclists" "dirb" "windows-binaries" "webshells" "wordlists")

# password attack
defer_6=("john" "hashcat" "crowbar" "hydra")
defer_6_gui=("johnny")

# framework
defer_7=("metasploit-framework" "recon-ng" "python3-impacket" "impacket-scripts" "bloodhound.py" \
    "crackmapexec" "evil-winrm")


function install_by_defer() {
    pkg_array=("$@")
    printf "\n%s \033[33m%s\033[0m\n\n" "install" $(IFS=','; echo "${pkg_array[*]}")
    apt install "${pkg_array[@]}" -y || true
}

# install with apt
# $1 == "cmdlet" / "gui" / "all" , default "all"
function install_tools_by_apt() {
    install_mode=""
    [ $# -eq 0 ] && install_mode="all"
    install_mode="$1"
    [[ "${install_mode}" =~ ^(all|cmdlet|gui)$ ]] && true || (echo "mode error" ; exit 1)

    for idx in {1..10};
    do
        if [[ "${install_mode}" =~ ^(all|cmdlet)$ ]]
        then
            # cmdlet tools
            temp_defer="defer_${idx}"
            [ -v "${temp_defer}" ] && eval install_by_defer '${'"${temp_defer}"'[@]}' || true
        fi

        if [[ "${install_mode}" =~ ^(all|gui)$ ]]
        then
            # gui tools
            temp_defer_gui="${temp_defer}_gui"
            [ -v "${temp_defer_gui}" ] && eval install_by_defer '${'"${temp_defer_gui}"'[@]}' || true
        fi
    done
}

# 1}}}

function update_system() {
    apt update && apt -u upgrade -y || exit 1
}

# main {{{1
function main() {
    update_system

    # cmdlet / gui / all
    install_tools_by_apt "cmdlet"
}
# }}}

# invoke main
main
