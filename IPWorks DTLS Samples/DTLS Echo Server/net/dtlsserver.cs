/*
 * IPWorks DTLS 2024 .NET Edition - Sample Project
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
 * 
 */

﻿using System;
using System.Collections.Generic;
using nsoftware.IPWorksDTLS;

class dtlsserverDemo {
  private static DTLSServer dtlsserver;

  private static void dtlsserver_OnConnected(object sender, DTLSServerConnectedEventArgs e) {
    if (e.StatusCode == 0) {
      Console.WriteLine("\nClient successfully connected from: " + e.SourceAddr + ":" + e.SourcePort);
      Console.WriteLine("ConnectionId: " + e.ConnectionId);
    } else {
      Console.Write("\nError connecting: " + e.StatusCode + ": " + e.Description);
    }
  }

  private static void dtlsserver_OnDataIn(object sender, DTLSServerDataInEventArgs e) {
    Console.WriteLine("Received packet from " + dtlsserver.Connections[e.ConnectionId].RemoteHost + ":" + dtlsserver.Connections[e.ConnectionId].RemotePort);
    Console.WriteLine("Echoing packet back to client: " + e.Datagram);
    dtlsserver.SendText(e.ConnectionId, e.Datagram);
  }

  private static void dtlsserver_OnDisconnected(object sender, DTLSServerDisconnectedEventArgs e) {
    Console.WriteLine("Client disconnecting. ConnectionId: " + e.ConnectionId);
    if (e.StatusCode != 0) {
      Console.WriteLine("Error while disconnecting, removing connection. Error: " + e.StatusCode + ": " + e.Description + "\r\n");
    }
  }

  private static void dtlsserver_OnError(object sender, DTLSServerErrorEventArgs e) {
    Console.WriteLine("Error: " + e.Description);
  }

  private static void dtlsserver_OnSSLStatus(object sender, DTLSServerSSLStatusEventArgs e) {
    Console.WriteLine("[SSL Status] " + e.Message);
  }

  static void Main(string[] args) {
    dtlsserver = new DTLSServer();

    if (args.Length < 4) {
      Console.WriteLine("\nIncorrect arguments specified.");
      Console.WriteLine("usage: dtlsserver /port port /cert cert_path [/pass password]");
      Console.WriteLine("port:       The UDP port to listen on (required)");
      Console.WriteLine("cert:       The path to the certificate file (required)");
      Console.WriteLine("pass:       The password to the specified certificate");
      Console.WriteLine("\r\nExample: dtlsserver /port 1234 /cert ../../../testpfx /pass test");
      Console.WriteLine("Press any key to exit...");
      Console.ReadKey();
    } else {
      dtlsserver.OnConnected += dtlsserver_OnConnected;
      dtlsserver.OnDataIn += dtlsserver_OnDataIn;
      dtlsserver.OnDisconnected += dtlsserver_OnDisconnected;
      dtlsserver.OnError += dtlsserver_OnError;
      dtlsserver.OnSSLStatus += dtlsserver_OnSSLStatus;

      try {
        // Parse command line arguments
        Dictionary<string, string> myArgs = ConsoleDemo.ParseArgs(args);

        // Set all command line arguments
        string certPath = "";
        string certPassword = "";
        if (myArgs.TryGetValue("port", out string temp)) dtlsserver.LocalPort = Int32.Parse(temp);
        if (myArgs.TryGetValue("cert", out temp)) certPath = temp;
        if (myArgs.TryGetValue("pass", out temp)) certPassword = temp;

        // Set certificate
        dtlsserver.SSLCert = new Certificate(CertStoreTypes.cstAuto, certPath, certPassword, "*");

        // Start server and listen. Ctrl + C to escape
        dtlsserver.StartListening();
        Console.WriteLine("Successfully started server. Listening for incoming connections on " + dtlsserver.LocalHost + ":" + dtlsserver.LocalPort);

        while (true) {
          dtlsserver.DoEvents();
        }
      } catch (Exception e) {
        Console.WriteLine(e.Message);
      }
      Console.WriteLine("Press any key to exit...");
      Console.ReadKey();
    }
  }
}





class ConsoleDemo
{
  /// <summary>
  /// Takes a list of switch arguments or name-value arguments and turns it into a dictionary.
  /// </summary>
  public static System.Collections.Generic.Dictionary<string, string> ParseArgs(string[] args)
  {
    System.Collections.Generic.Dictionary<string, string> dict = new System.Collections.Generic.Dictionary<string, string>();

    for (int i = 0; i < args.Length; i++)
    {
      // Add an key to the dictionary for each argument
      if (args[i].StartsWith("/"))
      {
        // If the next argument does NOT start with a "/" then it is a value.
        if (i + 1 < args.Length && !args[i + 1].StartsWith("/"))
        {
          // Save the value and skip the next entry in the list of arguments.
          dict.Add(args[i].ToLower().TrimStart('/'), args[i + 1]);
          i++;
        }
        else
        {
          // If the next argument starts with a "/", then we assume the current one is a switch.
          dict.Add(args[i].ToLower().TrimStart('/'), "");
        }
      }
      else
      {
        // If the argument does not start with a "/", store the argument based on the index.
        dict.Add(i.ToString(), args[i].ToLower());
      }
    }
    return dict;
  }
  /// <summary>
  /// Asks for user input interactively and returns the string response.
  /// </summary>
  public static string Prompt(string prompt, string defaultVal)
  {
    Console.Write(prompt + (defaultVal.Length > 0 ? " [" + defaultVal + "]": "") + ": ");
    string val = Console.ReadLine();
    if (val.Length == 0) val = defaultVal;
    return val;
  }
}