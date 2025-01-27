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


def fireConnected(e):
  if e.status_code == 0:
    print("\nClient successfully connected from: " + e.source_addr + ":" + str(e.source_port))
    print("ConnectionId: " + str(e.connection_id))
  else:
    print("\nError connecting: " + str(e.status_code) + ": " + e.description)

def fireDisconnected(e):
  print("Client disconnecting. ConnectionId: " + str(e.connection_id))
  if e.status_code != 0:
    print("Error while disconnecting, removing connection. Error: " + str(e.status_code) + ":" + e.description)

def fireDataIn(e):
  print("Received packet from " + str(e.connection_id))
  print("Echoing packet back to client: " + bytes.decode(e.datagram))
  dtlsserver.send_bytes(e.connection_id, e.datagram)

def fireSSLStatus(e):
  print("[SSL Status] " + e.message)

print("******************************************************************\n")
print("* This demo shows how to set up an echo server using DTLSServer. *\n")
print("******************************************************************\n")

if len(sys.argv) < 3:
  print("usage: dtlsserver.py port cert_path cert_pass")
  print("")
  print("  port:        the UDP port to listen on (required)")
  print("  cert_path:   the path to the certificate file (required)")
  print("  cert_pass:   the password to the specified certificate")
  print("\nExample: dtlsserver.py 1234 ./test.pfx test")
else:
  try:
    dtlsserver = DTLSServer()
    dtlsserver.on_connected = fireConnected
    dtlsserver.on_disconnected = fireDisconnected
    dtlsserver.on_data_in = fireDataIn
    dtlsserver.on_ssl_status = fireSSLStatus

    dtlsserver.set_local_port(int(sys.argv[1]))
    dtlsserver.set_ssl_cert_store_type(2)
    dtlsserver.set_ssl_cert_store(sys.argv[2])
    dtlsserver.set_ssl_cert_store_password(sys.argv[3])
    dtlsserver.set_ssl_cert_subject("*")
    dtlsserver.set_default_idle_timeout(120)

    dtlsserver.start_listening()
    print("Listening...")
    print("Press Ctrl-C to shutdown")


    while True:
      dtlsserver.do_events()

  except IPWorksDTLSError as e:
    print("ERROR: %s" % e.message)

  except KeyboardInterrupt:
    print("Shutdown requested...exiting")
    dtlsserver.shutdown()






