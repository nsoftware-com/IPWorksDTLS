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

bool dataInReceived;

class MyDTLSClient : public DTLSClient
{
public:
  int FireConnected(DTLSClientConnectedEventParams* e)
  {
    if (e->StatusCode == 0)
    {
      printf("\r\nSuccessfully connected.\n");
    }
    else
    {
      printf("\r\nError connecting: %d: %s\n", e->StatusCode, e->Description);
    }
    return 0;
  }

  int FireDisconnected(DTLSClientDisconnectedEventParams *e)
  {
    if (e->StatusCode != 0)
    {
      printf("Error encountered while disconnecting: %d: %s\n", e->StatusCode, e->Description);
    }
    printf("Disconnected from server.\n");
    return 0;
  }

  int FireDataIn(DTLSClientDataInEventParams *e)
  {
    printf("Received echo from %s:%d\n", e->SourceAddress, e->SourcePort);
    printf("Packet: %s\n", e->Datagram);
    dataInReceived = true;
    return 0;
  }

  int FireSSLServerAuthentication(DTLSClientSSLServerAuthenticationEventParams *e)
  {
    if (!e->Accept)
    {
      printf("\nServer provided the following certificate: \n");
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

  int FireSSLStatus(DTLSClientSSLStatusEventParams *e) 
  {
    printf("[SSL Status] %s\r\n", e->Message);
    return 0;
  }
};

int main(int argc, char* argv[])
{
  MyDTLSClient dtlsclient;

  if (argc < 2)
  {

    fprintf(stderr, "usage: dtlsclient host port\n");
    fprintf(stderr, "\n");
    fprintf(stderr, "  host  the address of the remote host (required)\n");
    fprintf(stderr, "  port    the UDP port in the remote host (required)\n");
    fprintf(stderr, "\nExample: dtlsclient localhost 1234\n");
    printf("Press enter to continue.");
    getchar();
  }
  else
  {
    printf("**************************************************************************************************************\n");
    printf("* This is a demo to show how to connect to a remote DTLS server, send data, and receive the echoed response. *\n");
    printf("**************************************************************************************************************\n");

    int ret_code;

    dtlsclient.SetRemoteHost(argv[1]);
    dtlsclient.SetRemotePort(atoi(argv[2]));
    ret_code = dtlsclient.Connect();

    if (ret_code)
    {
      printf("Error connecting: %d - %s\n", ret_code, dtlsclient.GetLastError());
      goto done;
    }

    printf("Type \"?\" for a list of commands.\n");

    char command[LINE_LEN];
    while (true) 
    {
      dtlsclient.DoEvents();
      if (!dtlsclient.GetConnected())
      {
        goto done;
      }

      dataInReceived = false;
      printf("> ");
      fgets(command, LINE_LEN, stdin);
      command[strlen(command) - 1] = '\0';
      if (!strcmp(command, "?"))
      {
        printf("Commands: \r\n");
        printf("  ?             display the list of valid commands\n");
        printf("  1             send data to the remote host\n");
        printf("  2             exit the application\n\n");
      }
      else if (!strcmp(command, "1"))
      {
        char text[LINE_LEN];
        printf("Please enter data to send: ");
        fgets(text, LINE_LEN, stdin);
        text[strlen(text) - 1] = '\0';
        ret_code = dtlsclient.SendText(text);
        if (ret_code)
        {
          printf("Sending failed: %d - %s\n", ret_code, dtlsclient.GetLastError());
        }
        else
        {
          printf("Waiting for response...\n");
          while (!dataInReceived && dtlsclient.GetConnected())
          {
            dtlsclient.DoEvents();
          }
        }
      }
      else if (!strcmp(command, "2"))
      {
        goto done;
      }
      else
      {
        printf("Command not recognized.\n");
      }
    }

  done:
    if (dtlsclient.GetConnected())
    {
      dtlsclient.Disconnect();
    }
    printf("Exiting... (press enter)\n");
    getchar();

    return 0;
  }

}




