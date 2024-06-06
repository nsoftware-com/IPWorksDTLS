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
    console.log("Usage: node dtlsclient.js host port");
    console.log("")
    console.log("  host    the address of the remote host (required)")
    console.log("  port    the UDP port in the remote host (required)")
    console.log("\r\nExample: node dtlsclient.js localhost 1234")
    process.exit();
  }

  const dtlsclient = new ipworksdtls.dtlsclient();

  function clientprompt() {
    process.stdout.write(' ');
  }

  dtlsclient.on('SSLServerAuthentication', function (e) {
    e.accept = true; // Warning: this demo accepts the server's certificate by default.
  })
  .on('Connected', function (e) {
    if (e.statusCode == 0) {
      console.log("Successfully connected.");
    } else {
      console.log("Error connecting: " + e.statusCode + ":" + e.description);
    }
  })
  .on('Disconnected', function (e) {
    if (e.statusCode != 0) {
      console.log("Error encountered while disconnecting: " + e.statusCode + ": " + e.description);
    }
    console.log("Disconnected from server.");
  })
  .on("Log", function (e) {
    console.log("[LOG]: " + e.logType + ": " + e.message);
  })
  .on("SSLStatus", function (e) {
    console.log("[SSLSTATUS]: " + e.message);
  });

  dtlsclient.setRemoteHost(argv[2]);
  dtlsclient.setRemotePort(parseInt(argv[3]));
  
  await dtlsclient.connect().catch((err) => {
    console.log("Error connecting: " + err.message);
    process.exit();
  });

  clientprompt();

  await dtlsclient.doEvents().catch((err) => {
    console.log("Error: " + err.message);
    process.exit();
  });

  if (dtlsclient.isConnected()) {
    console.log("> Press 1 to input data \n > Press 2 to quit")
    rl.prompt()
    rl.on('line', command => {
      
      if ("1" === command) {
        rl.question("Type data to send: ", data => {
          dtlsclient.sendText(data);
          dtlsclient.on('DataIn', function (e) {
            console.log("Received data: " + e.datagram);
            clientprompt();
            rl.prompt()
          })
        })

      } else if ("2" === command) {
        rl.close()
      } else {
        console.log("\r\nInvalid input!");
        rl.prompt()
      }
    }).on('close', () => {
      dtlsclient.disconnect();
    })
  }

}



function prompt(promptName, label, punctuation, defaultVal)
{
  lastPrompt = promptName;
  lastDefault = defaultVal;
  process.stdout.write(`${label} [${defaultVal}] ${punctuation} `);
}
