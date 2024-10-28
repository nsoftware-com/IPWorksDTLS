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
unit dtlsclientf;

interface

uses
  SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, ipdcore, ipdtypes,
  {$IF CompilerVersion >= 24 } //XE3 or higher
  Winapi.Windows, ipddtlsclient;
  {$ELSE}
  Windows, ipddtlsclient;
  {$IFEND}

type
  TFormDtlsclient = class(TForm)
    header: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    ButtonConnect: TButton;
    ButtonSend: TButton;
    EditServer: TEdit;
    EditPort: TEdit;
    Label3: TLabel;
    EditEcho: TEdit;
    Label4: TLabel;
    Memo1: TMemo;
    ipdDTLSClient1: TipdDTLSClient;
    procedure ButtonConnectClick(Sender: TObject);
    procedure ButtonSendClick(Sender: TObject);
    procedure ipdDTLSClient1Connected(Sender: TObject; const Address: string;
      Port, StatusCode: Integer; const Description: string);
    procedure ipdDTLSClient1DataIn(Sender: TObject; Datagram: string;
      DatagramB: TBytes; const SourceAddress: string; SourcePort: Integer);
    procedure ipdDTLSClient1Disconnected(Sender: TObject; const Address: string;
      Port, StatusCode: Integer; const Description: string);
    procedure ipdDTLSClient1SSLServerAuthentication(Sender: TObject;
      const SourceAddress: string; SourcePort: Integer; CertEncoded: string;
      CertEncodedB: TBytes; const CertSubject, CertIssuer, Status: string;
      var Accept: Boolean);
    procedure ipdDTLSClient1SSLStatus(Sender: TObject; const Message: string);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormDtlsclient: TFormDtlsclient;

implementation

{$R *.DFM}

var
	gStartTime: Longint;
	bError: Boolean;

procedure TFormDtlsclient.ButtonConnectClick(Sender: TObject);
begin
  Screen.Cursor := crHourglass;
  try
    if CompareStr(ButtonConnect.Caption, '&Connect') = 0 then
    begin
      ipdDTLSClient1.RemoteHost := EditServer.Text;
      ipdDTLSClient1.RemotePort := StrToInt(EditPort.Text);
      ipdDTLSClient1.Connect;
      ButtonConnect.Caption := '&Disconnect';
    end
    else
    begin
      ipdDTLSClient1.Disconnect;
      ButtonConnect.Caption := '&Connect';
    end;
  except on ex: EIPWorksDTLS do
  begin
    ShowMessage('Error: ' + ex.Message);
    ButtonConnect.Caption := '&Connect';
  end
  end;
  Screen.Cursor := crDefault;
end;

procedure TFormDtlsclient.ButtonSendClick(Sender: TObject);
begin
  Screen.Cursor := crHourglass;
  try
    if ipdDTLSClient1.Connected then
      begin
        ipdDTLSClient1.SendText(EditEcho.Text);
        Memo1.Lines.Add('Sending: ' + EditEcho.Text);
      end
    else
      Memo1.Lines.Add('You are not connected.');
  except on ex: EIPWorksDTLS do
    ShowMessage('Error: ' + ex.Message);
  end;
  Screen.Cursor := crDefault;
end;

procedure TFormDtlsclient.ipdDTLSClient1Connected(Sender: TObject;
  const Address: string; Port, StatusCode: Integer; const Description: string);
begin
  if StatusCode = 0 then
    Memo1.Lines.Add('Successfully connected.')
  else
    Memo1.Lines.Add('Error connecting: ' + IntToStr(StatusCode) + ': ' + Description);
end;

procedure TFormDtlsclient.ipdDTLSClient1DataIn(Sender: TObject;
  Datagram: string; DatagramB: TArray<System.Byte>; const SourceAddress: string;
  SourcePort: Integer);
begin
  Memo1.Lines.Add('Received echo from ' + SourceAddress + ':' + IntToStr(SourcePort));
  Memo1.Lines.Add('Packet: ' + Datagram);
end;

procedure TFormDtlsclient.ipdDTLSClient1Disconnected(Sender: TObject;
  const Address: string; Port, StatusCode: Integer; const Description: string);
begin
  ButtonConnect.Caption := '&Connect';
  if StatusCode <> 0 then
    Memo1.Lines.Add('Error encountered while disconnecting: ' + IntToStr(StatusCode) + ':' + Description);
  Memo1.Lines.Add('Disconnected from server.');
end;

procedure TFormDtlsclient.ipdDTLSClient1SSLServerAuthentication(Sender: TObject;
  const SourceAddress: string; SourcePort: Integer; CertEncoded: string;
  CertEncodedB: TArray<System.Byte>; const CertSubject, CertIssuer,
  Status: string; var Accept: Boolean);
var
 s: String;
begin
  if not Accept then
  begin
    s := 'Server provided the following certificate:' + #13#10 +
      '   Subject: ' + CertSubject + #13#10 +
      '   Issuer:' + CertIssuer + #13#10 +
      'The following problems have been determined for this certificate: ' + Status + #13#10 +
      'Would you like to continue the connection?';
    Accept := Dialogs.MessageDlg(s, mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrYes;
  end;
end;

procedure TFormDtlsclient.ipdDTLSClient1SSLStatus(Sender: TObject; const Message: string);
begin
  Memo1.Lines.Add('[SSL Status] ' + Message);
end;

end.



