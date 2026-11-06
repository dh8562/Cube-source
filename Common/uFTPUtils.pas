unit uFTPUtils;

interface

uses
  Windows,
  Classes,
  SysUtils,
  Graphics,
  ExtCtrls,
  TypInfo,
  Forms,
  IniFiles,
  DateUtils,

  elIniFiles,
  elRttiUtils,

  IdGlobal,
  IdAntiFreezeBase,
  IdAntiFreeze,
  IdBaseComponent,
  IdComponent,
  IdTCPConnection,
  IdTCPClient,
  IdExplicitTLSClientServerBase,
  IdFTPCommon,
  IdFTPList,
  IdFTP,
  IdFTPListParseAS400,
  IdFTPListParseBullGCOS7,
  IdFTPListParseCiscoIOS,
  IdFTPListParseDistinctTCPIP,
  IdFTPListParseEPLF,
  IdFTPListParseHellSoft,
  IdFTPListParseKA9Q,
  IdFTPListParseMicrowareOS9,
  IdFTPListParseMPEiX,
  IdFTPListParseMusic,
  IdFTPListParseMVS,
  IdFTPListParseNCSAForDOS,
  IdFTPListParseNovellNetware,
  IdFTPListParseNovellNetwarePSU,
  IdFTPListParseOS2,
  IdFTPListParseStercomOS390Exp,
  IdFTPListParseStercomUnixEnt,
  IdFTPListParseTOPS20,
  IdFTPListParseUnix,
  IdFTPListParseVM,
  IdFTPListParseVMS,
  IdFTPListParseVSE,
  IdFTPListParseVxWorks,
  IdFTPListParseWindowsNT,
  IdFTPListParseWinQVTNET,
  IdFTPListParseXecomMicroRTOS,
  IdException,
  IdExceptionCore,
  IdReply,
  IdReplyRFC,
  IdIntercept,
  IdLogBase,
  IdLogEvent,
  IdIOHandler,
  IdIOHandlerSocket,
  IdIOHandlerStack,
  IdCustomTransparentProxy,
  IdSocks;

type
  TFTPOnMessage = procedure(Sender : TObject; const AMsg : string; const AColor : TColor) of object;

  TFTP = class(TComponent)
  private

    FFTPClient : TIdFTP;
    FLogEvent : TIdLogEvent;
    FSocksInfo : TIdSocksInfo;
    FIOHandler : TIdIOHandlerStack;
    FOnMessage: TFTPOnMessage;
    FTransferAborted : Boolean;
    FInTransfer: Boolean;

    FLastSentTime : TDateTime;
    FLastRecvTime : TDateTime;
    FBusy : Boolean;

    FOnDisconnected: TNotifyEvent;

    procedure FireMsg(const AMsg : string; const AColor : TColor);
    procedure LogEventSend(ASender: TIdConnectionIntercept; var ABuffer: TIdBytes);
    procedure LogEventSent(ASender: TComponent; const AText, AData: String);
    procedure LogEventReceive(ASender: TIdConnectionIntercept; var ABuffer: TIdBytes);
    procedure LogEventReceived(ASender: TComponent; const AText, AData: String);

    procedure DoAfterClientLogin(Sender: TObject);
    procedure DoStatus(ASender: TObject; const AStatus: TIdStatus; const AStatusText: String);
    procedure DoDisconnected(Sender: TObject);
  protected
    procedure CheckForDisconnect;
    procedure FireAndDisconnect(const AMsg : string);
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;

    procedure Abort;
    function ChangeDirTo(const ADirName : string) : Boolean;
    procedure ChangeDirUp;
    procedure ChangeTransferType(const ATransferType : TIdFTPTransferType);
    procedure Connect(const AHost : string; const AUserName, APassword : string; const APort : Word = 21; const APassive : Boolean = False); overload;
    procedure Connect; overload;
    function Connected : Boolean;
    function Delete(const AFileName : string) : Boolean;
    procedure Disconnect;
    function Get(const ASourceFile: string; ADest: TStream) : Boolean;
    function List(ADest: TStrings; const ASpecifier: string = ''; const ADetails: Boolean = True) : Boolean;
    function MakeDir(const ADirName : string) : Boolean;
    function Put(const ASource: TStream; const ADestFile: string) : Boolean;
    procedure Quit;
    function RemoveDir(const ADirName : string) : Boolean;
    function Rename(const ASourceFile, ADestFile: string) : Boolean;
    function RetrieveCurrentDir : string;
    function Size(const AFileName : string) : Integer;

    function FileExists(const FileName : string) : Boolean;
    function RenameInListing(const OldFileName, NewFileName : string) : Boolean;

    procedure LoadSetting(const AIniFileName : string);
    procedure SaveSetting(const AIniFileName : string);

    property TransferAborted : Boolean read FTransferAborted write FTransferAborted;

    property FTPClient : TIdFTP read FFTPClient;

    property InTransfer : Boolean read FInTransfer write FInTransfer;
    property OnMessage : TFTPOnMessage read FOnMessage write FOnMessage;
    property OnDisconnected : TNotifyEvent read FOnDisconnected write FOnDisconnected;
  end;

implementation

const
  S_FTP_PROXY = 'FTP Proxy';
  S_SOCKS_PROXY = 'SOCKS Proxy';
  S_PROXY_TYPE = 'ProxyType';
  S_HOST = 'Host';
  S_PORT = 'Port';
  S_USER = 'User';
  S_PASSWORD = 'Password';
  S_USE_UP = 'UseUsernamePassword';

{ TFTP }

procedure TFTP.Abort;
begin
  if FFTPClient = nil then Exit;
  try
    FTransferAborted := True;
    FInTransfer := False;
    FFTPClient.Abort;
  except
    on E:EIdReplyRFCError do CheckForDisconnect;
    on E:EIdConnClosedGracefully do CheckForDisconnect;
    on E:EIdException do FireAndDisconnect(E.Message);
  end;
end;

function TFTP.ChangeDirTo(const ADirName: string) : Boolean;
begin
  Result := False;
  if FFTPClient = nil then Exit;
  try
    FFTPClient.ChangeDir(ADirName);
    Result := True;
  except
    on E:EIdReplyRFCError do CheckForDisconnect;
    on E:EIdConnClosedGracefully do CheckForDisconnect;
    on E:EIdException do FireAndDisconnect(E.Message);
  end;
end;

procedure TFTP.ChangeDirUp;
begin
  if FFTPClient = nil then Exit;
  try
    FFTPClient.ChangeDirUp;
  except
    on E:EIdReplyRFCError do CheckForDisconnect;
    on E:EIdConnClosedGracefully do CheckForDisconnect;
    on E:EIdException do FireAndDisconnect(E.Message);
  end;
end;

procedure TFTP.ChangeTransferType(
  const ATransferType: TIdFTPTransferType);
begin
  if FFTPClient = nil then Exit;
  try
    FFTPClient.TransferType := ATransferType;
  except
    on E:EIdReplyRFCError do CheckForDisconnect;
    on E:EIdConnClosedGracefully do CheckForDisconnect;
    on E:EIdException do FireAndDisconnect(E.Message);
  end;
end;

procedure TFTP.Connect(const AHost : string; const AUserName, APassword : string; const APort : Word; const APassive : Boolean);
begin
  if FFTPClient = nil then Exit;

  FFTPClient.Host := AHost;
  FFTPClient.Username := AUserName;
  FFTPClient.Password := APassword;
  FFTPClient.Port := APort;
  FFTPClient.Passive := APassive;

  Connect;
end;

procedure TFTP.Connect;
begin
  if FFTPClient = nil then Exit;
  try
    if Connected then
    begin
      Disconnect;
    end;

    FFTPClient.Connect;
  except
    on E:EIdReplyRFCError do CheckForDisconnect;
    on E:EIdConnClosedGracefully do CheckForDisconnect;
    on E:EIdException do
    begin
      FireAndDisconnect(E.Message);
    end;
  end;
end;

function TFTP.Connected: Boolean;
begin
  Result := False;
  if FFTPClient = nil then Exit;
  try
    Result := FFTPClient.Connected;
  except
    on E:EIdReplyRFCError do CheckForDisconnect;
    on E:EIdConnClosedGracefully do CheckForDisconnect;
    on E:EIdException do FireAndDisconnect(E.Message);
  end;
end;

constructor TFTP.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  FLogEvent := TIdLogEvent.Create(Self);
  FLogEvent.Active := True;
  FLogEvent.LogTime := False;
  FLogEvent.ReplaceCRLF := False;
  FLogEvent.OnSend := LogEventSend;
  FLogEvent.OnSent := LogEventSent;
  FLogEvent.OnReceive := LogEventReceive;
  FLogEvent.OnReceived := LogEventReceived;

  FSocksInfo := TIdSocksInfo.Create(Self);

  FIOHandler := TIdIOHandlerStack.Create(Self);
  FIOHandler.Intercept := FLogEvent;
  FIOHandler.TransparentProxy := FSocksInfo;

  FTransferAborted := False;

  FFTPClient := TIdFTP.Create(nil);
  FFTPClient.IOHandler := FIOHandler;
  FFTPClient.OnAfterClientLogin := DoAfterClientLogin;
  FFTPClient.OnDisconnected := DoDisconnected;
  FFTPClient.OnStatus := DoStatus;

  FLastSentTime := Now;
  FLastRecvTime := Now;
  FBusy := False;
end;

function TFTP.Delete(const AFileName: string) : Boolean;
begin
  Result := False;
  if FFTPClient = nil then Exit;
  try
    FFTPClient.Delete(AFileName);
    Result := True;
  except
    on E:EIdReplyRFCError do CheckForDisconnect;
    on E:EIdConnClosedGracefully do CheckForDisconnect;
    on E:EIdException do FireAndDisconnect(E.Message);
  end;
end;

destructor TFTP.Destroy;
begin
  FFTPClient.OnAfterClientLogin := nil;
  FFTPClient.OnDisconnected := nil;
  FFTPClient.OnStatus := nil;
  FFTPClient.OnWork := nil;
  FFTPClient.OnWorkBegin := nil;
  FFTPClient.OnWorkEnd := nil;

  FLogEvent.OnSent := nil;
  FLogEvent.OnReceived := nil;

  FreeAndNil(FSocksInfo);
  FreeAndNil(FIOHandler);
  FreeAndNil(FLogEvent);
  FreeAndNil(FFTPClient);

  inherited;
end;

procedure TFTP.Disconnect;
begin
  if FFTPClient = nil then Exit;
  try
    DoDisconnected(FFTPClient);
    if FIOHandler.InputBuffer <> nil then
      FIOHandler.InputBuffer.Clear;
    FIOHandler.CloseGracefully;
    FFTPClient.Disconnect;
  except
    on E:EIdException do
    begin
      FireMsg(E.Message, clRed);
    end;
  end;
end;

function TFTP.FileExists(const FileName: string): Boolean;
var
  I : Integer;
begin
  Result := False;
  if FFTPClient = nil then Exit;

  I := 0;
  while I < FFTPClient.DirectoryListing.Count do
  begin
    if FFTPClient.DirectoryListing[I].FileName = FileName then
    begin
      Result := True;
      break;
    end;
    Inc(I);
  end;
end;

procedure TFTP.FireMsg(const AMsg: string; const AColor: TColor);
begin
  if Assigned(FOnMessage) then
    FOnMessage(Self, AMsg, AColor);
end;

function TFTP.Get(const ASourceFile: string;
  ADest: TStream): Boolean;
begin
  Result := False;
  if FFTPClient = nil then Exit;
  try
    FTransferAborted := False;
    FFTPClient.Get(ASourceFile, ADest);
    Result := (FFTPClient.LastCmdResult.NumericCode = 226);
  except
    on E:EIdReplyRFCError do CheckForDisconnect;
    on E:EIdConnClosedGracefully do
    begin
      if FTransferAborted then
      begin
        FFTPClient.GetResponse([225, 226, 250, 426, 450, 451]);
        FFTPClient.GetResponse([225, 226, 250, 426, 450, 451, 500, 501, 502]);
      end
      else
        Disconnect;
    end;

    on E:EIdException do FireAndDisconnect(E.Message);
  end;
end;

function TFTP.List(ADest: TStrings; const ASpecifier: string;
  const ADetails: Boolean) : Boolean;
begin
  Result := False;
  if FFTPClient = nil then Exit;
  try
    FFTPClient.List(ADest, ASpecifier, ADetails);
    Result := True;
  except
    on E:EIdReplyRFCError do CheckForDisconnect;
    on E:EIdConnClosedGracefully do
    begin
      if not FInTransfer then
      begin
        FFTPClient.GetResponse([225, 226, 250, 426, 450, 451]);
        FFTPClient.GetResponse([225, 226, 250, 426, 450, 451, 500, 501, 502]);
      end
      else
        Disconnect;
    end;

    on E:EIdException do FireAndDisconnect(E.Message);
  end;
end;

procedure TFTP.LogEventReceived(ASender: TComponent; const AText,
  AData: String);
begin
  FBusy := False;
  FLastRecvTime := Now;
  if Length(AData) > 0 then
  begin
    // 서버족에서 연결을 끊었으면
    if Pos('421', AData) = 1 then
    begin
      FireMsg('< ' + AData, clRed);
      Disconnect;
    end
    else
      FireMsg('< ' + AData, clGreen);
  end;
end;

procedure TFTP.LogEventSent(ASender: TComponent; const AText,
  AData: String);
begin
  FBusy := False;
  FLastSentTime := Now;
  if Length(AData) > 0 then
  begin
    if Pos('PASS', AData) > 0 then
      FireMsg('> PASS', clBlue)
    else
      FireMsg('> ' + AData, clBlue);
  end;
end;

procedure TFTP.LogEventReceive(ASender: TIdConnectionIntercept;
  var ABuffer: TIdBytes);
begin
  FBusy := True;
end;

procedure TFTP.LogEventSend(ASender: TIdConnectionIntercept;
  var ABuffer: TIdBytes);
begin
  FBusy := True;
end;

function TFTP.MakeDir(const ADirName: string) : Boolean;
begin
  Result := False;
  if FFTPClient = nil then Exit;
  try
    FFTPClient.MakeDir(ADirName);
    Result := True;
  except
    on E:EIdReplyRFCError do CheckForDisconnect;
    on E:EIdConnClosedGracefully do CheckForDisconnect;
    on E:EIdException do FireAndDisconnect(E.Message);
  end;
end;

function TFTP.RenameInListing(const OldFileName,
  NewFileName: string): Boolean;
var
  I : Integer;
begin
  Result := False;
  if FFTPClient = nil then Exit;
  if (OldFileName = NewFileName) then Exit;

  I := 0;
  while I < FFTPClient.DirectoryListing.Count do
  begin
    if FFTPClient.DirectoryListing[I].FileName = OldFileName then
    begin
      FFTPClient.DirectoryListing[I].FileName := NewFileName;
      Result := True;
      break;
    end;
    Inc(I);
  end;
end;

function TFTP.Put(const ASource: TStream;
  const ADestFile: string): Boolean;
begin
  Result := False;
  if FFTPClient = nil then Exit;
  try
    FTransferAborted := False;
    FFTPClient.Put(ASource, ADestFile);
    Result := (FFTPClient.LastCmdResult.NumericCode = 226);
  except
    on E:EIdReplyRFCError do CheckForDisconnect;
    on E:EIdConnClosedGracefully do
    begin
      if FTransferAborted then
      begin
        FFTPClient.GetResponse([225, 226, 250, 426, 450, 451]);
        FFTPClient.GetResponse([225, 226, 250, 426, 450, 451, 500, 501, 502]);
      end
      else
        Disconnect;
    end;

    on E:EIdException do FireAndDisconnect(E.Message);
  end;
end;

procedure TFTP.Quit;
begin
  if FFTPClient = nil then Exit;
  try
    FFTPClient.Quit;
  except
    on E:EIdConnClosedGracefully do CheckForDisconnect;
    on E:EIdException do FireAndDisconnect(E.Message);
  end;
end;

function TFTP.RemoveDir(const ADirName: string) : Boolean;
begin
  Result := False;
  if FFTPClient = nil then Exit;
  try
    FFTPClient.RemoveDir(ADirName);
    Result := True;
  except
    on E:EIdReplyRFCError do CheckForDisconnect;
    on E:EIdConnClosedGracefully do CheckForDisconnect;
    on E:EIdException do FireAndDisconnect(E.Message);
  end;
end;

function TFTP.Rename(const ASourceFile, ADestFile: string) : Boolean;
begin
  Result := False;
  if FFTPClient = nil then Exit;
  try
    FFTPClient.Rename(ASourceFile, ADestFile);
    Result := True;
  except
    on E:EIdReplyRFCError do CheckForDisconnect;
    on E:EIdConnClosedGracefully do CheckForDisconnect;
    on E:EIdException do FireAndDisconnect(E.Message);
  end;
end;

function TFTP.RetrieveCurrentDir: string;
begin
  Result := '';
  if FFTPClient = nil then Exit;
  try
    Result := FFTPClient.RetrieveCurrentDir;
  except
    on E:EIdReplyRFCError do CheckForDisconnect;
    on E:EIdConnClosedGracefully do CheckForDisconnect;
    on E:EIdException do FireAndDisconnect(E.Message);
  end;
end;

procedure TFTP.SaveSetting(const AIniFileName: string);
begin
  elIniSaveComponentProperties(FFTPClient.ProxySettings, AIniFileName, S_FTP_PROXY);
  elIniSaveComponentProperties(FSocksInfo, AIniFileName, S_SOCKS_PROXY);
end;

function TFTP.Size(const AFileName: string): Integer;
begin
  Result := -1;
  if FFTPClient = nil then Exit;
  try
    Result := FFTPClient.Size(AFileName);
  except
    on E:EIdReplyRFCError do CheckForDisconnect;
    on E:EIdConnClosedGracefully do CheckForDisconnect;
    on E:EIdException do FireAndDisconnect(E.Message);
  end;
end;

procedure TFTP.LoadSetting(const AIniFileName : string);
begin
  if FFTPClient = nil then Exit;

  elIniLoadComponentProperties(FFTPClient.ProxySettings, AIniFileName, S_FTP_PROXY);
  elIniLoadComponentProperties(FSocksInfo, AIniFileName, S_SOCKS_PROXY);
end;

procedure TFTP.DoAfterClientLogin(Sender: TObject);
begin
;
end;

procedure TFTP.DoDisconnected(Sender: TObject);
begin
  FireMsg('', clBlack);
  if Assigned(FOnDisconnected) then FOnDisconnected(Self);
end;

procedure TFTP.DoStatus(ASender: TObject; const AStatus: TIdStatus;
  const AStatusText: String);
begin
  FInTransfer := (AStatus = ftpTransfer);
end;

procedure TFTP.CheckForDisconnect;
var
  nIndex : Integer;
begin
  if FFTPClient = nil then Exit;
  // 421은 서버쪽에서 연결을 끊을 때 보내주는 코드임.
  // 소켓 수신 버퍼에 내용이 들어오자마자 LastCmdResult에 데이터가 들어오지 않고
  // 임의의 명령이 송신되고 나서야 수신 버퍼에 있는 내용을 읽어들이기 때문에 여러 라인 중에
  // 421 메시지가 있을 수 있기 때문에 모든 라인을 검색해 본다.
  for nIndex := 0 to Pred(FFTPClient.LastCmdResult.FormattedReply.Count) do
  begin
    if Pos('421', FFTPClient.LastCmdResult.FormattedReply[nIndex]) = 1 then
    begin
      Disconnect;
      Break;
    end;
  end;
end;

procedure TFTP.FireAndDisconnect(const AMsg: string);
begin
  FireMsg(AMsg, clRed);
  Disconnect;
end;

end.
