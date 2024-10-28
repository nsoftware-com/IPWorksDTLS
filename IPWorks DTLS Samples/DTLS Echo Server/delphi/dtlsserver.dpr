(*
 * IPWorks DTLS 2024 Delphi Edition - Sample Project
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
 *)

program dtlsserver;

uses
  Forms,
  dtlsserverf in 'dtlsserverf.pas' {FormDtlsserver};

begin
  Application.Initialize;

  Application.CreateForm(TFormDtlsserver, FormDtlsserver);
  Application.Run;
end.


         
