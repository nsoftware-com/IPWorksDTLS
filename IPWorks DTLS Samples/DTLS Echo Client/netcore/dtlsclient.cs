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

class dtlsclientDemo
{
  private static DTLSClient dtlsclient;

  private static void dtlsclient_OnConnected(object sender, DTLSClientConnectedEventArgs e) {
    if (e.StatusCode == 0) {
      Console.WriteLine("\nSuccessfully connected.");
    } else {
      Console.WriteLine("\nError connecting: " + e.StatusCode + ": " + e.Description);
    }
  }

  private static void dtlsclient_OnDataIn(object sender, DTLSClientDataInEventArgs e) {
    Console.WriteLine("Received echo from " + e.SourceAddress + ":" + e.SourcePort);
    Console.WriteLine("Packet: " + e.Datagram);
    Console.Write("> ");
  }

  private static void dtlsclient_OnDisconnected(object sender, DTLSClientDisconnectedEventArgs e) {
    if (e.StatusCode != 0) {
      Console.WriteLine("Error encountered while disconnecting: " + e.StatusCode + ": " + e.Description);
    }
    Console.WriteLine("Disconnected from server.");
  }

  private static void dtlsclient_OnError(object sender, DTLSClientErrorEventArgs e) {
    Console.WriteLine("Error: " + e.Description);
  }

  private static void dtlsclient_OnSSLServerAuthentication(object sender, DTLSClientSSLServerAuthenticationEventArgs e) {
    if (e.Accept) return;
    Console.Write("\nServer provided the following certificate:\nIssuer: " + e.CertIssuer + "\nSubject: " + e.CertSubject + "\n");
    Console.Write("The following problems have been determined for this certificate: " + e.Status + "\n");
    Console.Write("Would you like to continue anyways? [y/n] \n");
    if (Console.Read() == 'y') e.Accept = true;
  }

  private static void dtlsclient_OnSSLStatus(object sender, DTLSClientSSLStatusEventArgs e) {
    Console.WriteLine("[SSL Status] " + e.Message);
  }

  static void Main(string[] args)
  {
    dtlsclient = new DTLSClient();

    if (args.Length < 4) {
      Console.WriteLine("\nIncorrect arguments specified.");
      Console.WriteLine("usage: dtlsclient /host hostname /port port ");
      Console.WriteLine("host:       The address of of the remote host (required)");
      Console.WriteLine("port:       The UDP port of the remote host (required)");
      Console.WriteLine("\r\nExample: dtlsclient /host 192.1.1.123 /port 1234");
      Console.WriteLine("Press any key to exit...");
      Console.ReadKey();
    }
    else {
      dtlsclient.OnConnected += dtlsclient_OnConnected;
      dtlsclient.OnDataIn += dtlsclient_OnDataIn;
      dtlsclient.OnDisconnected += dtlsclient_OnDisconnected;
      dtlsclient.OnError += dtlsclient_OnError;
      dtlsclient.OnSSLServerAuthentication += dtlsclient_OnSSLServerAuthentication;
      dtlsclient.OnSSLStatus += dtlsclient_OnSSLStatus;

      try {
        // Parse command line arguments
        Dictionary<string, string> myArgs = ConsoleDemo.ParseArgs(args);

        // Set all command line arguments
        if (myArgs.TryGetValue("host", out string temp)) dtlsclient.RemoteHost = temp;
        if (myArgs.TryGetValue("port", out temp)) dtlsclient.RemotePort = Int32.Parse(temp);

        // Attempt to connect to the remote server.
        dtlsclient.Connect();

        // Process user commands.
        Console.WriteLine("Type \"?\" or \"help\" for a list of commands.");
        string command;
        string[] arguments;

        while (true) {
          if (!dtlsclient.Connected) {
            break;
          }

          command = Console.ReadLine();
          arguments = command.Split();

          if (arguments[0].Equals("?") || arguments[0].Equals("help")) {
            Console.WriteLine("Commands: ");
            Console.WriteLine("  ?                            display the list of valid commands");
            Console.WriteLine("  help                         display the list of valid commands");
            Console.WriteLine("  send <text>                  send data to the remote host");
            Console.WriteLine("  quit                         exit the application");
          }
          else if (arguments[0].Equals("send")) {
            if (arguments.Length > 1) {
              string textToSend = "";
              for (int i = 1; i < arguments.Length; i++) {
                if (i < arguments.Length - 1) textToSend += arguments[i] + " ";
                else textToSend += arguments[i];
              }
              dtlsclient.SendText(textToSend);
            }
            else {
              Console.WriteLine("Please supply the text that you would like to send.");
            }
          }
          else if (arguments[0].Equals("quit")) {
            dtlsclient.Disconnect();
            break;
          }
          else if (arguments[0].Equals("")) {
            // Do nothing.
          }
          else {
            Console.WriteLine("Invalid command.");
          }
          Console.Write("> ");
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