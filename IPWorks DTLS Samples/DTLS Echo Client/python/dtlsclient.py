# 
# IPWorks DTLS 2024 Python Edition - Sample Project
# 
# This sample project demonstrates the usage of IPWorks DTLS in a 
# simple, straightforward way. It is not intended to be a complete 
# application. Error handling and other checks are simplified for clarity.
# 
# www.nsoftware.com/ipworksdtls
# 
# This code is subject to the terms and conditions specified in the 
# corresponding product license agreement which outlines the authorized 
# usage and restrictions.
# 

import sys
import string
from ipworksdtls import *

input = sys.hexversion < 0x03000000 and raw_input or input


def ensureArg(args, prompt, index):
    if len(args) <= index:
        while len(args) <= index:
            args.append(None)
        args[index] = input(prompt)
    elif args[index] is None:
        args[index] = input(prompt)


dataReceived = False

def fireSSLServerAuthentication(e):
  if e.accept:
    return
  print("\nServer provided the following certificate:\nIssuer: " + e.cert_issuer + "\nSubject: " + e.cert_subject)
  print("The following problems have been determined for this certificate: " + e.status)
  p = input("Would you like to continue or cancel the connection?  [y/n] \n")
  e.accept = p == "y"

def fireDataIn(e):
  global dataReceived
  dataReceived = True
  print("Received the data: " + bytes.decode(e.datagram))

def fireConnected(e):
  if e.status_code == 0:
    print("\nSuccessfully connected.")
  else:
   print("\nError connecting: " + str(e.status_code) + ":" + e.description)

def fireDisconnected(e):
  if e.status_code != 0:
    print("Error encountered while disconnecting: " + str(e.status_code) + ":" + e.description)
  print("Disconnected from server.")

def fireSSLStatus(e):
  print("[SSL Status] " + e.message)

print("*****************************************************************")
print("* This is a demo to show how to connect to a remote DTLS server *")
print("* to send data, and receive the echoed response.                *")
print("*****************************************************************")

if len(sys.argv) < 3:
  print("usage: dtlsclient.py host port")
  print("")
  print("  host    the address of the remote host (required)")
  print("  port    the UDP port in the remote host (required)")
  print("\r\nExample: dtlsclient.py localhost 1234")
else:
  try:
    dtlsclient = DTLSClient()
    dtlsclient.on_data_in = fireDataIn
    dtlsclient.on_ssl_server_authentication = fireSSLServerAuthentication
    dtlsclient.on_connected = fireConnected
    dtlsclient.on_disconnected = fireDisconnected
    dtlsclient.on_ssl_status = fireSSLStatus

    dtlsclient.set_remote_host(sys.argv[1])
    dtlsclient.set_remote_port(int(sys.argv[2]))
    dtlsclient.connect()
    while True:
      if not dtlsclient.get_connected():
        break
      dtlsclient.do_events()
      dataReceived = False
      command = int(input("Please input command: 1 [Send Data] or  2 [Exit]: "))
      if command == 1:
        send = input("Please enter data to send: ")
        dtlsclient.send_bytes(bytes(send, 'utf-8'))    
        print("Now waiting for response...")
        while dataReceived == False and dtlsclient.get_connected():
          dtlsclient.do_events()
      else:
        dtlsclient.disconnect()
        break
      
  except IPWorksDTLSError as e:
    print("ERROR: %s" % e.message)





