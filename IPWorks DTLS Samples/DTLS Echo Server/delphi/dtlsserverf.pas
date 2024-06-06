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
unit dtlsserverf;

interface

uses
  SysUtils, Classes, Graphics, Controls, System.Generics.Collections,
  Forms, Dialogs, StdCtrls, Spin, ExtCtrls, ipdcore, ipdtypes, Buttons,
  ipddtlsserver;

type
  TFormDtlsserver = class(TForm)
    ButtonStart: TButton;
    EditLocalPort: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label1: TLabel;
    EditMessage: TEdit;
    Button1: TButton;
    ipdDTLSServer1: TipdDTLSServer;
    Memo1: TMemo;
    procedure ButtonStartClick(Sender: TObject);
    procedure ipdDTLSServer1Connected(Sender: TObject; ConnectionId: Integer;
      const SourceAddr: string; SourcePort, StatusCode: Integer;
      const Description: string);
    procedure ipdDTLSServer1Disconnected(Sender: TObject; ConnectionId,
      StatusCode: Integer; const Description: string);
    procedure Button1Click(Sender: TObject);
    procedure ipdDTLSServer1DataIn(Sender: TObject; ConnectionId: Integer;
      Datagram: string; DatagramB: TBytes);
    procedure FormCreate(Sender: TObject);
    procedure ipdDTLSServer1SSLStatus(Sender: TObject; ConnectionId: Integer;
      const Message: string);
  private
    { Private declarations }
  public
    connectionIds: TList<Integer>;
  end;

var
  FormDtlsserver: TFormDtlsserver;

implementation

{$R *.DFM}

procedure TFormDtlsserver.ipdDTLSServer1Connected(Sender: TObject;
  ConnectionId: Integer; const SourceAddr: string; SourcePort,
  StatusCode: Integer; const Description: string);
begin
  if StatusCode = 0 then
  begin
    connectionIds.Add(ConnectionId);
    Memo1.Lines.Add('Client successfully connected from: ' + SourceAddr + ':' + IntToStr(SourcePort));
    Memo1.Lines.Add('ConnectionId: ' + IntToStr(ConnectionId));
  end
  else
    Memo1.Lines.Add('Error connecting: ' + IntToStr(StatusCode) + ': ' + Description);
end;

procedure TFormDtlsserver.ipdDTLSServer1DataIn(Sender: TObject;
  ConnectionId: Integer; Datagram: string; DatagramB: TBytes);
begin
  try
    Memo1.Lines.Add('Received packet from client. ConnectionId: ' + IntToStr(ConnectionId));
    Memo1.Lines.Add('Echoing packet: ' + Datagram);
    ipdDTLSServer1.SendText(ConnectionId, Datagram);
  except on ex: EIPWorksDTLS do
    Memo1.Lines.Add('Error echoing text in DataIn: ' + IntToStr(ex.Code) + ':' + ex.Message);
  end;
end;

procedure TFormDtlsserver.ipdDTLSServer1Disconnected(Sender: TObject;
  ConnectionId, StatusCode: Integer; const Description: string);
begin
  connectionIds.Remove(ConnectionId);
  Memo1.Lines.Add('Client disconnecting. ConnectionId: ' + IntToStr(ConnectionId));
  if StatusCode <> 0 then
    Memo1.Lines.Add('Error while disconnecting, removing connection. Error: ' + IntToStr(StatusCode) + ': ' + Description);
end;

procedure TFormDtlsserver.ipdDTLSServer1SSLStatus(Sender: TObject;
  ConnectionId: Integer; const Message: string);
begin
  Memo1.Lines.Add('[SSL Status] ' + Message);
end;

procedure TFormDtlsserver.Button1Click(Sender: TObject);
var
  i: Integer;
begin
  Screen.Cursor := crHourglass;
  try
  begin
    Memo1.Lines.Add('Broadcasting data to all connected clients.');
    for i := 0 to connectionIds.Count - 1 do
    begin
      ipdDTLSServer1.SendText(connectionIds.Items[i], EditMessage.Text);
      Memo1.Lines.Add('Broadcast sent to: ' + IntToStr(connectionIds.Items[i]));
    end;
  end;
  except on ex: EIPWorksDTLS do
    ShowMessage('Error: ' + ex.Message);
  end;
  Screen.Cursor := crDefault;
end;

procedure TFormDtlsserver.ButtonStartClick(Sender: TObject);
var CertPath: string;
begin
  Screen.Cursor := crHourglass;
  try
    if CompareStr(ButtonStart.Caption, '&Start') = 0 then
    begin
      // Sample certificate available for demo purposes.
      CertPath := '../../test.pfx';

      ipdDTLSServer1.SSLCertStoreType := TipdCertStoreTypes.cstPFXFile;
      ipdDTLSServer1.SSLCertStore := CertPath;
      ipdDTLSServer1.SSLCertStorePassword := 'test';
      ipdDTLSServer1.SSLCertSubject := '*';
      ipdDTLSServer1.LocalPort := StrToInt(EditLocalPort.Text);
      ipdDTLSServer1.DefaultIdleTimeout := 120;
      ipdDTLSServer1.StartListening;

      ButtonStart.Caption := '&Stop';

      Memo1.Clear;
      Memo1.Lines.Add('Successfully started server. Listening for incoming connections on ' + ipdDTLSServer1.LocalHost + ':' + IntToStr(ipdDTLSServer1.LocalPort) + #13#10);
    end
    else
    begin
      // To disconnect all clients:
      ipdDTLSServer1.Shutdown;
      ButtonStart.Caption := '&Start';
      Memo1.Lines.Add('Stopping server.' + #13#10);
    end;
  except on ex: EIPWorksDTLS do
  begin
    ButtonStart.Caption := '&Start';
    ShowMessage('Error: ' + ex.Message);
  end;
  end;
  Screen.Cursor := crDefault;
end;

procedure TFormDtlsserver.FormCreate(Sender: TObject);
begin
  connectionIds := TList<Integer>.Create;
end;

end.





