/*
 * IPWorks DTLS 2024 Java Edition - Sample Project
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

import java.io.*;
import java.io.*;
import java.io.*;
import ipworksdtls.*;

public class dtlsclient extends ConsoleDemo {

  private static DTLSClient dtlsclient;

  public static void main(String[] args) {
    if (args.length < 2) {
      System.out.println("\r\nIncorrect arguments specified.");
      System.out.println("usage: dtlsclient host port");
      System.out.println("");
      System.out.println("host:    the address of the remote host (required)");
      System.out.println("port:    the UDP port in the remote host (required)");
      System.out.println("\r\nExample: dtlsclient localhost 1234");
    } else {
      try {
        dtlsclient = new DTLSClient();
        System.out.println("*************************************************************************************************************");
        System.out.println("* This is a demo to show how to connect to a remote DTLS server, send data, and receive the echoed response.*");
        System.out.println("*************************************************************************************************************\n");
        dtlsclient.addDTLSClientEventListener(new DefaultDTLSClientEventListener() {
          public void SSLServerAuthentication(DTLSClientSSLServerAuthenticationEvent e) {
            if (e.accept) return;
            System.out.println("\nServer provided the following certificate:\nIssuer: " + e.certIssuer + "\nSubject: " + e.certSubject + "\n");
            System.out.println("The following problems have been determined for this certificate: " + e.status + "\n");
            String p = prompt("Would you like to continue anyways? [y/n] \n");
            e.accept = p.equals("y") || p.equals("yes");
          }

          public void connected(DTLSClientConnectedEvent e) {
            if (e.statusCode == 0) {
              System.out.println("\nSuccessfully connected.");
            } else {
              System.out.println("\nError connecting: " + e.statusCode + ": " + e.description);
            }
          }

          public void dataIn(DTLSClientDataInEvent e) {
            System.out.println("Received echo from " + e.sourceAddress + ":" + e.sourcePort);
            String packet = new String(e.datagram);
            System.out.println("Packet: " + packet);
            System.out.print("> ");
          }

          public void disconnected(DTLSClientDisconnectedEvent e) {
            if (e.statusCode != 0) {
              System.out.println("Error while disconnecting: " + e.statusCode + ": " + e.description);
            }
            System.out.println("Disconnected from server.");
          }

          public void SSLStatus(DTLSClientSSLStatusEvent e) {
            System.out.println("[SSL Status] " + e.message);
          }
        });
        dtlsclient.setRemoteHost(args[0]);
        dtlsclient.setRemotePort(Integer.parseInt(args[1]));
        dtlsclient.connect();
        dtlsclient.doEvents();
        System.out.println("Type \"?\" for a list of commands.");
        System.out.print("> ");

        while (true) {
          if (!dtlsclient.isConnected()) {
            break;
          }
          if (System.in.available() > 0) {
            String command = String.valueOf(read());
            if (command.equals("?")) {
              System.out.println("  ?                  display the list of valid commands");
              System.out.println("  1                  send data to the remote host");
              System.out.println("  2                  exit the application");
            } else if (command.equals("1")) {
              dtlsclient.sendText(prompt("Please input sending data: ") + "\r\n");
              System.out.println("Sending success.");
            } else if (command.equals("2")) {
              break;
            } else {
              System.out.println("Invalid command.");
            }
            System.out.print("> ");
          }
        }
      } catch (Exception ex) {
        System.out.println(ex.getMessage());
      }
      System.out.println("Press any key to exit...");
      input();
    }
  }
}

class ConsoleDemo {
  private static BufferedReader bf = new BufferedReader(new InputStreamReader(System.in));

  static String input() {
    try {
      return bf.readLine();
    } catch (IOException ioe) {
      return "";
    }
  }
  static char read() {
    return input().charAt(0);
  }

  static String prompt(String label) {
    return prompt(label, ":");
  }
  static String prompt(String label, String punctuation) {
    System.out.print(label + punctuation + " ");
    return input();
  }
  static String prompt(String label, String punctuation, String defaultVal) {
      System.out.print(label + " [" + defaultVal + "]" + punctuation + " ");
      String response = input();
      if (response.equals(""))
        return defaultVal;
      else
        return response;
  }

  static char ask(String label) {
    return ask(label, "?");
  }
  static char ask(String label, String punctuation) {
    return ask(label, punctuation, "(y/n)");
  }
  static char ask(String label, String punctuation, String answers) {
    System.out.print(label + punctuation + " " + answers + " ");
    return Character.toLowerCase(read());
  }

  static void displayError(Exception e) {
    System.out.print("Error");
    if (e instanceof IPWorksDTLSException) {
      System.out.print(" (" + ((IPWorksDTLSException) e).getCode() + ")");
    }
    System.out.println(": " + e.getMessage());
    e.printStackTrace();
  }

  /**
   * Takes a list of switch arguments or name-value arguments and turns it into a map.
   */
  static java.util.Map<String, String> parseArgs(String[] args) {
    java.util.Map<String, String> map = new java.util.HashMap<String, String>();
    
    for (int i = 0; i < args.length; i++) {
      // Add a key to the map for each argument.
      if (args[i].startsWith("-")) {
        // If the next argument does NOT start with a "-" then it is a value.
        if (i + 1 < args.length && !args[i + 1].startsWith("-")) {
          // Save the value and skip the next entry in the list of arguments.
          map.put(args[i].toLowerCase().replaceFirst("^-+", ""), args[i + 1]);
          i++;
        } else {
          // If the next argument starts with a "-", then we assume the current one is a switch.
          map.put(args[i].toLowerCase().replaceFirst("^-+", ""), "");
        }
      } else {
        // If the argument does not start with a "-", store the argument based on the index.
        map.put(Integer.toString(i), args[i].toLowerCase());
      }
    }
    return map;
  }
}



