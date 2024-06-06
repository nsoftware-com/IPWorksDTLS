object FormDtlsserver: TFormDtlsserver
  Left = 321
  Top = 119
  Caption = 'DTLS Echo Server'
  ClientHeight = 389
  ClientWidth = 498
  Color = clBtnFace
  Constraints.MinHeight = 428
  Constraints.MinWidth = 514
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'System'
  Font.Style = []
  OnCreate = FormCreate
  DesignSize = (
    498
    389)
  TextHeight = 16
  object Label2: TLabel
    Left = 8
    Top = 56
    Width = 25
    Height = 13
    Caption = 'Port: '
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 8
    Top = 8
    Width = 476
    Height = 39
    Anchors = [akLeft, akTop, akRight]
    Caption = 
      'This demo shows how to set up a DTLS server on your computer usi' +
      'ng the DTLSServer component. You need to specify the port you wa' +
      'nt the server to listen on, start the server, and select a valid' +
      ' certificate containing a private key to begin.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Label1: TLabel
    Left = 8
    Top = 343
    Width = 164
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Send data to all connected clients:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object ButtonStart: TButton
    Left = 424
    Top = 53
    Width = 66
    Height = 23
    Anchors = [akTop, akRight]
    Caption = '&Start'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = ButtonStartClick
  end
  object EditLocalPort: TEdit
    Left = 39
    Top = 53
    Width = 105
    Height = 21
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    Text = '1234'
  end
  object EditMessage: TEdit
    Left = 8
    Top = 360
    Width = 401
    Height = 21
    Anchors = [akLeft, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    Text = 'Hello world!'
  end
  object Button1: TButton
    Left = 424
    Top = 358
    Width = 66
    Height = 23
    Anchors = [akRight, akBottom]
    Caption = 'S&end'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 8
    Top = 80
    Width = 482
    Height = 257
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
  end
  object ipdDTLSServer1: TipdDTLSServer
    SSLCertStore = 'MY'
    OnConnected = ipdDTLSServer1Connected
    OnDataIn = ipdDTLSServer1DataIn
    OnDisconnected = ipdDTLSServer1Disconnected
    OnSSLStatus = ipdDTLSServer1SSLStatus
    Left = 336
    Top = 48
  end
end


