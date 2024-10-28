object FormDtlsclient: TFormDtlsclient
  Left = 318
  Top = 119
  Caption = 'DTLS Echo Client'
  ClientHeight = 321
  ClientWidth = 446
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  TextHeight = 13
  object header: TLabel
    Left = 8
    Top = 8
    Width = 422
    Height = 39
    Caption = 
      'This is a demo to show how to connect to a remote DTLS server, s' +
      'end data, and receive the echoed response. Simply fill in the se' +
      'rver to connect to and the port it is using. Then input the data' +
      ' you would like to send.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Label1: TLabel
    Left = 8
    Top = 63
    Width = 62
    Height = 13
    Caption = 'Echo Server:'
  end
  object Label2: TLabel
    Left = 290
    Top = 63
    Width = 22
    Height = 13
    Caption = 'Port:'
  end
  object Label3: TLabel
    Left = 8
    Top = 94
    Width = 52
    Height = 13
    Caption = 'Echo Text:'
  end
  object Label4: TLabel
    Left = 8
    Top = 118
    Width = 125
    Height = 13
    Caption = 'Data received from server:'
  end
  object ButtonConnect: TButton
    Left = 373
    Top = 59
    Width = 65
    Height = 22
    Caption = '&Connect'
    TabOrder = 0
    OnClick = ButtonConnectClick
  end
  object ButtonSend: TButton
    Left = 373
    Top = 90
    Width = 65
    Height = 22
    Caption = '&Send'
    TabOrder = 1
    OnClick = ButtonSendClick
  end
  object EditServer: TEdit
    Left = 76
    Top = 60
    Width = 208
    Height = 21
    TabOrder = 2
    Text = 'localhost'
  end
  object EditPort: TEdit
    Left = 318
    Top = 60
    Width = 49
    Height = 21
    TabOrder = 3
    Text = '1234'
  end
  object EditEcho: TEdit
    Left = 76
    Top = 91
    Width = 291
    Height = 21
    TabOrder = 4
    Text = 'Echo this text.'
  end
  object Memo1: TMemo
    Left = 8
    Top = 137
    Width = 430
    Height = 176
    TabOrder = 5
  end
  object ipdDTLSClient1: TipdDTLSClient
    SSLCertStore = 'MY'
    OnConnected = ipdDTLSClient1Connected
    OnDataIn = ipdDTLSClient1DataIn
    OnDisconnected = ipdDTLSClient1Disconnected
    OnSSLServerAuthentication = ipdDTLSClient1SSLServerAuthentication
    OnSSLStatus = ipdDTLSClient1SSLStatus
    Left = 232
    Top = 32
  end
end


