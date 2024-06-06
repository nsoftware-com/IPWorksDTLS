/*
 * IPWorks DTLS 2024 C++ Edition - Sample Project
 *
 * This sample project demonstrates the usage of IPWorks DTLS in a 
 * simple, straightforward way. It is not intended to be a complete 
 * application. Error handling and other checks are simplified for clarity.
 *
 * www.nsoftware.com/ipworksdtls
 *
 * This code is subject to the terms and conditions specified in the 
 * corresponding product license agreement which outlines the authorized 
 * usage and restrictions.
 */

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

#include "../../include/ipworksdtls.h"
#define LINE_LEN 80

class MyDTLSServer : public DTLSServer
{
  int FireConnected(DTLSServerConnectedEventParams *e)
  {
    if (e->StatusCode == 0)
    {
      printf("\r\nClient successfully connected from: %s: %d\n", e->SourceAddr, e->SourcePort);
      printf("ConnectionId: %d\n", e->ConnectionId);
    }
    else
    {
      printf("\r\nError connecting: %d: %s\n", e->StatusCode, e->Description);
    }
    return 0;
  }

  int FireDisconnected(DTLSServerDisconnectedEventParams *e)
  {
    printf("Client disconnecting. ConnectionId: %d\n", e->ConnectionId);
    if (e->StatusCode != 0)
    {
      printf("Error while disconnecting, removing connection. Error: %d: %s\n", e->StatusCode, e->Description);
    }
    return 0;
  }

  int FireDataIn(DTLSServerDataInEventParams *e)
  {
    printf("Received packet from client. ConnectionId: %d\n", e->ConnectionId);
    printf("Echoing packet: %s\n", e->Datagram);
    this->SendText(e->ConnectionId, e->Datagram);
    return 0;
  }

  int FireSSLServerAuthentication(DTLSClientSSLServerAuthenticationEventParams *e)
  {
    if (!e->Accept)
    {
      printf("\r\nServer provided the following certificate: \n");
      printf("Subject: %s \n", e->CertSubject);
      printf("Issuer: %s \n", e->CertIssuer);
      printf("The following problems have been determined for this certificate:  %s \n", e->Status);
      printf("Would you like to continue or cancel the connection?  [y/n] \n");

      char response[LINE_LEN];

      fgets(response, LINE_LEN, stdin);
      response[strlen(response) - 1] = '\0';
      if (strcmp(response, "y") == 0)
        e->Accept = true;
    }
    return 0;
  }

  int FireSSLStatus(DTLSServerSSLStatusEventParams *e) 
  {
    printf("[SSL Status] %s\r\n", e->Message);
    return 0;
  }
};

int main(int argc, char* argv[])
{
  MyDTLSServer dtlsserver;

  char buffer[LINE_LEN];

  if (argc < 2)
  {
    fprintf(stderr, "usage: dtlsserver port cert_path [cert_pass]\n");
    fprintf(stderr, "\n");
    fprintf(stderr, "  port        the UDP port to listen on (required)\n");
    fprintf(stderr, "  cert_path   the path to the certificate file (required)\n");
    fprintf(stderr, "  cert_pass   the password to the specified certificate\n");
    fprintf(stderr, "\nExample: dtlsserver 1234 ./test.pfx test\n");
    printf("Press enter to continue.");
    getchar();
  }
  else
  {
    printf("*****************************************************************\n");
    printf("* This demo shows how to set up an echo server using DTLSServer. *\n");
    printf("*****************************************************************\n");

    dtlsserver.SetLocalPort(atoi(argv[1]));
    dtlsserver.SetSSLCertStoreType(CST_PFXFILE);
    dtlsserver.SetSSLCertStore(argv[2], strlen(argv[2]));
    if (argc > 3)
    {
      dtlsserver.SetSSLCertStorePassword(argv[3]);
    }
    
    //The default value of "*" picks the first private key in the certificate. For simplicity this demo will use that value.
    dtlsserver.SetSSLCertSubject("*");

    dtlsserver.SetDefaultIdleTimeout(120); // optional, disconnects inactive clients after 120 seconds.
    int ret_code = dtlsserver.StartListening();

    if (ret_code)
    {
      printf("Error: %i - %s\n", ret_code, dtlsserver.GetLastError());
      goto done;
    }

    printf("Listening...\n");

    while (true)
    {
      dtlsserver.DoEvents();
    }

  done:
    if (dtlsserver.GetListening())
    {
      dtlsserver.StopListening();
    }

    printf("Exiting... (press enter)\n");
    getchar();

    return 0;
  }
}


