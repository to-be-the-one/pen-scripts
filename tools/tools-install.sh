#!/usr/bin/env -S bash

:<<!
auth: @cyhfvg https://github.com/cyhfvg
date: 2022/11/28

install penetration test tools automatically.
!

set -euo pipefail
cd ${0%/*}

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

apt update && apt -u upgrade -y || exit 1

function install_by_defer() {
    pkg_array=("$@")
    for pkg in ${pkg_array[@]}
    do
        apt search "${pkg}" 2>/dev/null | grep --color=never -q "${pkg}" && apt install "${pkg}" -y || echo "${pkg} not exist"
    done
}

# main
for idx in {1..10};
do
    # cmdlet tools
    temp_defer="defer_${idx}"
    [ -v "${temp_defer}" ] && eval install_by_defer '${'"${temp_defer}"'[@]}' || true

    # gui tools
    temp_defer_gui="${temp_defer}_gui"
    [ -v "${temp_defer_gui}" ] && eval install_by_defer '${'"${temp_defer_gui}"'[@]}' || true
done
