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
require_once('../include/ipworksdtls_dtlsserver.php');
require_once('../include/ipworksdtls_const.php');
?>
<?php
global $dtlsserver;

class MyDTLSServer extends IPWorksDTLS_DTLSServer
{
  function FireConnected($param) {
    global $dtlsserver;
    echo $dtlsserver->getConnectionRemoteHost($param['connectionid']) . " has connected.\n";
  }
  function FireDisconnected($param) {
    echo "Remote host disconnected: " . $param['description'] . "\n";
  }
  function FireDataIn($param) {
    global $dtlsserver;
    echo "Received '" . $param['datagram'] . "' from " . $dtlsserver->getConnectionRemoteHost($param['connectionid']) . "\n";
    echo "Echoing message back...\n";
    $dtlsserver->doSendText($param['connectionid'], $param['datagram']);
  }
}

$dtlsserver = new MyDTLSServer();

if ($argc < 4) {
  echo "Usage: php dtls_echo_server.php port [certFile certPassword]\n\n";
  echo "  port:          the port on which the server will listen\n"; 
  echo "  certFile:      the path to the certiticate file\n";
  echo "  certPassword:  the password for the certificate file\n\n";
  echo "Example: php dtls_echo_server.php 777 test.pfx test\n";
  return;
} else {
  echo "*******************************************************************\n";
  echo "* This demo shows how to set up an echo server using DTLSServer.  *\n";
  echo "*******************************************************************\n";
  $dtlsserver->setLocalPort($argv[1]);
  try {
    $dtlsserver->setSSLCertStoreType(99); // auto
    $dtlsserver->setSSLCertStore($argv[2]);
    $dtlsserver->setSSLCertStorePassword($argv[3]);
    $dtlsserver->setSSLCertSubject("*");
  } catch (Exception $ex) {
    echo "Error loading certificate: " . $ex->getMessage() . "\n";
    return;
  }
}

try {
  $dtlsserver->doStartListening();
  echo "Listening on port " . $dtlsserver->getLocalPort() . "... press Ctrl-C to shutdown.\n";

  while (true) {
    $dtlsserver->doEvents();
  }
} catch (Exception $ex) {
  echo 'Error: ',  $ex->getMessage(), "\n";
}
?>