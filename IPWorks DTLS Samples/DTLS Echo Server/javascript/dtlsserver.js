/*
 * IPWorks DTLS 2024 JavaScript Edition - Sample Project
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
 
const readline = require("readline");
const ipworksdtls = require("@nsoftware/ipworksdtls");

if(!ipworksdtls) {
  console.error("Cannot find ipworksdtls.");
  process.exit(1);
}
let rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

main();


async function main() {
  const argv = process.argv;
  if (argv.length < 4) {
    console.log("Usage: node dtlsserver.js port cert_path cert_pass");
    console.log("")
    console.log("  port:        the UDP port to listen on (required)")
    console.log("  cert_path:   the path to the certificate file (required)")
    console.log("  cert_pass:   the password to the specified certificate")
    console.log("\nExample: node dtlsserver.js 1234 ./test.pfx test")
    return;
  }

  const dtlsserver = new ipworksdtls.dtlsserver();

  dtlsserver.on("Disconnected", function (e) {
    console.log("Client disconnecting. ConnectionId: " + e.connectionId);
    if (e.statusCode != 0) {
      console.log("Error while disconnecting, removing connection. Error: " + e.statusCode + ":" + e.description);
    }
  })
  .on("SSLStatus", function (e) {
    console.log("[SSLSTATUS]: " + e.message);
  })
  .on("Log", function (e) {
    console.log("[LOG]: " + e.logType + ": " + e.message);
  })
  .on("Connected", function (e) {
    if (e.statusCode == 0) {
      console.log("Client successfully connected from: " + e.sourceAddr + ":" + e.sourcePort);
      console.log("ConnectionId: " + e.connectionId);
    } else {
      console.log("Error connecting: " + e.statusCode + ": " + e.description);
    }
  })
  .on("ConnectionRequest", function (e) {
    console.log("Connection request");
  })
  .on("DataIn", function (e) {
    console.log("Received packet from " + e.connectionId);
    console.log("Echoing packet back to client: " + e.datagram);
    dtlsserver.sendText(e.connectionId, e.datagram);
  });
  const cert = new ipworksdtls.Certificate(ipworksdtls.CertStoreTypes.cstPFXFile, argv[3], argv[4], "*");

  dtlsserver.setLocalPort(parseInt(argv[2]));
  dtlsserver.setSSLCert(cert);
  dtlsserver.setDefaultIdleTimeout(120);
  await dtlsserver.config("LogLevel=3");

  await dtlsserver.startListening().catch(err => {
    console.log("Error starting: " + err.message);
  });

  console.log("Started Listening.");

  while (true) {
    await dtlsserver.doEvents(function (err) {
      if (err) {
        console.log(err);
        return;
      }
    });
  }
}



function prompt(promptName, label, punctuation, defaultVal)
{
  lastPrompt = promptName;
  lastDefault = defaultVal;
  process.stdout.write(`${label} [${defaultVal}] ${punctuation} `);
}
