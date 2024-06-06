<?php
/*
 * IPWorks DTLS 2024 PHP Edition - Sample Project
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
require_once('../include/ipworksdtls_dtlsclient.php');
require_once('../include/ipworksdtls_const.php');
?>
<?php
global $receivedData;
$receivedData = "";

class MyDTLSClient extends IPWorksDTLS_DTLSClient
{
  function FireSSLServerAuthentication($param) {
    $param['accept'] = true;
    return $param;
  }
  function FireDataIn($param) {
    global $receivedData;
    echo "Received: '" . $param['datagram'] . "'\n";
    $receivedData = $param['datagram'];
  }
  function FireLog($param) {
    echo $param['message'] . "\n";
  }
}

function input($prompt) {
  echo $prompt;
  $handle = fopen("php://stdin", "r");
  $data = trim(fgets($handle));
  fclose($handle);
  return $data;
}

try {
  $dtlsclient = new MyDTLSClient();
  if ($argc < 3) {
    echo "Usage: php dtls_echo_client.php host port\n\n";
    echo "  host:    the address of the remote host\n"; 
    echo "  port:    the UDP port of the remote host\n\n";
    echo "Example: php dtls_echo_client.php 192.1.1.123 777\n";
    return;
  } else {
    $dtlsclient->setRemoteHost($argv[1]);
    $dtlsclient->setRemotePort($argv[2]);
  }
  $dtlsclient->doConnect();
  $dtlsclient->doEvents();
  echo "Type \"?\" for a list of commands.\n";
  while (true) {
    try {
      $data = input("dtlsclient> ");
      $arguments = explode(" ", $data);
      $command = $arguments[0];

      if ($command == "?" || $command == "help") {
        echo "Commands: \n";
        echo "  ?             display the list of valid commands\n";
        echo "  help          display the list of valid commands\n";
        echo "  send <text>   send text data to the remote host\n";
        echo "  quit          exit the application\n";
      } elseif ($command == "quit" || $command == "exit" ) {
        $dtlsclient->doDisconnect();
        return;
      } elseif ($command == "send") {
        if (count($arguments) > 1) {
          global $receivedData;
          $receivedData = "";
          $dtlsclient->doSendText(trim(substr($data, strpos($data, " "))));
          while($receivedData == "")
          {
            $dtlsclient->doEvents();
          }
        } else {
          echo "Usage: send <text>\n";
        }
      } elseif ($command == "") {
        // do nothing
      } else {
        echo "Invalid command.\n";
      }
    } catch (Exception $ex) {
      echo 'Error: ',  $ex->getMessage(), "\n";  
    }
    $dtlsclient->doEvents();
  }
} catch (Exception $ex) {
  echo 'Error: ',  $ex->getMessage(), "\n";
}
?>