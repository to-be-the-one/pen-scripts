#!/usr/bin/python3

import ldap3

# FIXME: change this
targetHost = '10.10.10.161'
targetPort = 389

# connect without credentials
server = ldap3.Server(targetHost, get_info = ldap3.ALL, port = targetPort, use_ssl = False)
connection = ldap3.Connection(server)
connection.bind()

# get naming context or domain name
print(server.info)

# query by domain name : htb.local
connection.search(search_base='DC=htb,DC=local', search_filter='(&(objectClass=*))', search_scope='SUBTREE', attributes='*')
print(connection.entries)

# dump all ldap
connection.search(search_base='DC=htb,DC=local', search_filter='(&(objectClass=person))', search_scope='SUBTREE', attributes='userPassword')
print(connection.entries)

