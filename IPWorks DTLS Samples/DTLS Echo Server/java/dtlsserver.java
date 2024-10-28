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

public class dtlsserver extends ConsoleDemo {
  
  private static DTLSServer dtlsserver;

  public static void main(String[] args) {
    if (args.length < 2) {
      System.out.println("usage: dtlsserver port cert_path [cert_pass]");
      System.out.println("");
      System.out.println("port:        the UDP port to listen on (required)");
      System.out.println("cert_path:   the path to the certificate file (required)");
      System.out.println("cert_pass:   the password to the specified certificate");
      System.out.println("\r\nExample: dtlsserver 1234 ./test.pfx test");
    } else {
      try {
        dtlsserver = new DTLSServer();
        System.out.println("******************************************************************");
        System.out.println("* This demo shows how to set up an echo server on your computer. *");
        System.out.println("******************************************************************\n");

        dtlsserver.addDTLSServerEventListener(new DefaultDTLSServerEventListener() {
          public void connected(DTLSServerConnectedEvent e) {
            if (e.statusCode == 0) {
              System.out.println("\nClient successfully connected from: " + e.sourceAddr + ": " + e.sourcePort);
              System.out.println("ConnectionId: " + e.connectionId);
            } else {
              System.out.println("\nError connecting: " + e.statusCode + ": " + e.description);
            }
          }

          public void dataIn(DTLSServerDataInEvent e) {
            System.out.println("Received packet from " + e.connectionId);
            String packet = new String(e.datagram);
            System.out.println("Echoing packet back to client: " + packet);
            try {
              dtlsserver.sendText(e.connectionId, packet);
            } catch (IPWorksDTLSException ex) {
              System.out.println("Error encountered sending data: " + ex.getCode() + ": " + ex.getMessage());
            }
          }

          public void disconnected(DTLSServerDisconnectedEvent e) {
            System.out.println("Client disconnecting. ConnectionId: " + e.connectionId);
            if (e.statusCode != 0) {
              System.out.println("Error while disconnecting, removing connection. Error: " + e.statusCode + ":" + e.description);
            }
          }

          public void SSLStatus(DTLSServerSSLStatusEvent e) {
            System.out.println("[SSL Status] " + e.message);
          }
        });

        dtlsserver.setLocalPort(Integer.parseInt(args[0]));
        String certPassword = "";
        if (args.length > 2) certPassword = args[2];
        dtlsserver.setSSLCert(new Certificate(Certificate.cstPFXFile, args[1], certPassword, "*"));
        dtlsserver.startListening();

        System.out.println("Successfully started server. Listening for incoming connections on " + dtlsserver.getLocalHost() + ":" + dtlsserver.getLocalPort());

        while (true) {
          dtlsserver.doEvents();
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



