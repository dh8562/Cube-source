unit fFTPProgress;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  StdCtrls,
  TypInfo,
  ComCtrls,
  ExtCtrls,
  IniFiles,

  Codesitelogging,

  elLabel,
  elStringUtils,

  IdComponent,
  IdFTP,
  IdFTPCommon,

  uEquipmentBase,
  uEquipment,
  uFTPUtils;

type
  TfrmFTPProgress = class(TForm)
    lblFileNameLabel: TLabel;
    PB: TProgressBar;
    lblProgressLabel: TLabel;
    lblFileSizeLabel: TLabel;
    lblTransferredSizeLabel: TLabel;
    btnCancel: TButton;
    tmrFTP: TTimer;
    lblTotalTimeLabel: TLabel;
    lblRemainingTimeLabel: TLabel;
    lblAvrSpeedLabel: TLabel;
    lblFileName: TEdit;
    lblFileSIze: TEdit;
    lblTransferredSize: TEdit;
    lblTotalTime: TEdit;
    lblRemainingTime: TEdit;
    lblAvrSpeed: TEdit;
    reMessage: TRichEdit;
    procedure FormCreate(Sender: TObject);
    procedure tmrFTPTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    // Preserved Event Handler;
    OnWork: TWorkEvent;
    OnWorkBegin: TWorkBeginEvent;
    OnWorkEnd: TWorkEndEvent;
    PrevFTPMessage : TFTPOnMessage;

    UploadNameList : TStrings;
    RemoteNameList : TStrings;

    // Event Handler to assign
    procedure FTPClientWorkBegin(Sender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Int64);
    procedure FTPClientWork(Sender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
    procedure FTPClientWorkEnd(Sender: TObject; AWorkMode: TWorkMode);

    procedure AddFTPMessage(Msg : string; AColor : TColor);
    procedure DoFTPMessage(Sender : TObject; const AMsg : string; const AColor : TColor);
  public
    { Public declarations }
    FSourceName : String;
    FDestName : String;
    nSrcSize : LongInt;
    bUpload : Boolean;
    bUpList : Boolean;

    FFTP : TFTP;

    bTransferring : Boolean;
    TransferStartTime : TDateTime;

    function Get(const Src, Dest : String) : Boolean;
    function Put(const Src, Dest : String) : Boolean;
    function StreamGet(const Src : String; Dest : TStream) : Boolean;
    function StreamPut(Src : TStream; const Dest : String) : Boolean;

    procedure AssignNewEventHandler(AFTP : TIdFTP);
    procedure AssignPreservedEventHandler(AFTP : TIdFTP);
  end;

function LoadFromFTP(const AHost : string; const AUserName, APassword : string; const APort : Word; const APassive : Boolean; const Src, Dest : string) : Boolean;
function SaveToFTP(const AHost : string; const AUserName, APassword : string; const APort : Word; const APassive : Boolean; const Src, Dest : string) : Boolean; overload;
function SaveToFTP(const Src, Dest : string) : Boolean; overload;
function SaveToFTPList(const SrcList : TStrings; DestList : TStrings) : Boolean; overload;

implementation

{$R *.dfm}

function LoadFromFTP(const AHost : string; const AUserName, APassword : string; const APort : Word; const APassive : Boolean; const Src, Dest : string) : Boolean;
var
  F : TfrmFTPProgress;
begin
  F := TfrmFTPProgress.Create(Application);
  try
    F.FFTP.FTPClient.Host := AHost;
    F.FFTP.FTPClient.Username := AUserName;
    F.FFTP.FTPClient.Password := APassword;
    F.FFTP.FTPClient.Port := APort;
    F.FFTP.FTPClient.Passive := APassive;

    F.FSourceName := Src;
    F.FDestName := Dest;

    F.bUpload := False;
    F.bUpList := False;
    Result := (F.ShowModal = mrOK);
  finally
    FreeAndNil(F);
  end;
end;

function SaveToFTP(const AHost : string; const AUserName, APassword : string; const APort : Word; const APassive : Boolean; const Src, Dest : string) : Boolean;
var
  F : TfrmFTPProgress;
begin
  F := TfrmFTPProgress.Create(Application);
  try
    F.FFTP.FTPClient.Host := AHost;
    F.FFTP.FTPClient.Username := AUserName;
    F.FFTP.FTPClient.Password := APassword;
    F.FFTP.FTPClient.Port := APort;
    F.FFTP.FTPClient.Passive := APassive;

    F.FSourceName := Src;
    F.FDestName := Dest;

    F.bUpload := True;
    F.bUpList := False;
    Result := (F.ShowModal = mrOK);
  finally
    FreeAndNil(F);
  end;
end;

function SaveToFTP(const Src, Dest : string) : Boolean;
var
  F : TfrmFTPProgress;
  INI : TIniFile;
begin
  F := TfrmFTPProgress.Create(Application);
  try
    INI := TIniFile.Create(Equipment.IniFileName);
    try
      F.FFTP.FTPClient.Host := INI.ReadString('FTP', 'Host', '127.0.0.1');
      F.FFTP.FTPClient.Username := INI.ReadString('FTP', 'User', 'dat');
      F.FFTP.FTPClient.Password := INI.ReadString('FTP', 'Password', 'dat');
      F.FFTP.FTPClient.Port := INI.ReadInteger('FTP', 'Port', 21);
      F.FFTP.FTPClient.Passive := INI.ReadBool('FTP', 'Passive', True);
    finally
      INI.Free;
    end;

    F.FSourceName := Src;
    F.FDestName := Dest;

    F.bUpload := True;
    F.bUpList := False;
    Result := (F.ShowModal = mrOK);
  finally
    FreeAndNil(F);
  end;
end;

function SaveToFTPList(const SrcList : TStrings; DestList : TStrings) : Boolean;
var
  F : TfrmFTPProgress;
  INI : TIniFile;
begin
  F := TfrmFTPProgress.Create(Application);
  try
    INI := TIniFile.Create(Equipment.IniFileName);
    try
      F.FFTP.FTPClient.Host := INI.ReadString('FTP', 'Host', '127.0.0.1');
      F.FFTP.FTPClient.Username := INI.ReadString('FTP', 'User', 'dat');
      F.FFTP.FTPClient.Password := INI.ReadString('FTP', 'Password', 'dat');
      F.FFTP.FTPClient.Port := INI.ReadInteger('FTP', 'Port', 21);
      F.FFTP.FTPClient.Passive := INI.ReadBool('FTP', 'Passive', True);
    finally
      INI.Free;
    end;

    F.UploadNameList := srcList;
    F.RemoteNameList := DestList;

    F.bUpload := True;
    F.bUpList := True;
    Result := (F.ShowModal = mrOK);
  finally
    FreeAndNil(F);
  end;
end;

{ UNIX 스타일 파일에 대한 추출 기능 추가 }
function aeExtractFileName(const FileName: string): string;
var
  I: Integer;
begin
  I := LastDelimiter(PathDelim + DriveDelim + '/', FileName);
  Result := Copy(FileName, I + 1, MaxInt);
end;

function aeExtractFilePath(const FileName: string): string;
var
  I: Integer;
begin
  I := LastDelimiter(PathDelim + DriveDelim + '/', FileName);
  Result := Copy(FileName, 1, I);
end;

procedure TfrmFTPProgress.FormCreate(Sender: TObject);
begin
  DesktopFont := True;
  nSrcSize := 0;
  FFTP := TFTP.Create(Self);
end;

procedure TfrmFTPProgress.FormShow(Sender: TObject);
begin
  tmrFTP.Enabled := True;
end;

procedure TfrmFTPProgress.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FFTP);
end;

procedure TfrmFTPProgress.tmrFTPTimer(Sender: TObject);
var
  szSrc, szDest : String;
  bResult : Boolean;
begin
  tmrFTP.Enabled := False;
  if FFTP <> nil then
  begin
    PrevFTPMessage := FFTP.OnMessage;
    FFTP.OnMessage := DoFTPMessage;
    try
      if bUpload then
      begin
        if bUpList then
        begin
          while (UploadNameList.Count > 0) and not FFTP.TransferAborted do
          begin
            szSrc := UploadNameList[0];
            szDest := RemoteNameList[0];

            bResult := Put(szSrc, szDest);

            UploadNameList.Delete(0);
            RemoteNameList.Delete(0);

            Application.ProcessMessages;
          end;
        end
        else
        begin
          bResult := Put(FSourceName, FDestName);
        end;
      end
      else
        bResult := Get(szSrc, szDest);
    finally
      FFTP.OnMessage := PrevFTPMessage;
    end;
    if FFTP.TransferAborted then
    begin
      ModalResult := mrCancel;
    end
    else
    begin
      if bResult then
        ModalResult := mrOK;
    end;
  end
  else
    ModalResult := mrCancel;
end;

procedure TfrmFTPProgress.FTPClientWorkBegin(Sender: TObject;
  AWorkMode: TWorkMode; AWorkCountMax: Int64);
begin
  if FFTP = nil then Exit;

  FFTP.InTransfer := True;
  if AWorkCountMax <> 0 then
    PB.Max := AWorkCountMax
  else
    PB.Max := nSrcSize;
  TransferStartTime := Now;
end;

procedure TfrmFTPProgress.FTPClientWork(Sender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Int64);
Var
  TotalTime: TDateTime;
  H, M, Sec, MS: Word;
  ElapsedTime: Double;
  AverageSpeed : Double;
begin
  if FFTP = nil then Exit;

  if FFTP.TransferAborted then
  begin
    Exit;
  end;
  if AWorkCount > 0 then
  begin
    TotalTime :=  Now - TransferStartTime;
    DecodeTime(TotalTime, H, M, Sec, MS);
    Sec := Sec + M * 60 + H * 3600;
    ElapsedTime := Sec + MS / 1000;
    if ElapsedTime > 0 then
    begin
      AverageSpeed := (AWorkCount / 1024) / ElapsedTime;
      lblAvrSpeed.Text := Format('%f KB', [AverageSpeed]);
      lblTotalTime.Text := Format('%.2d:%.2d:%.2d', [Sec div 3600, (Sec div 60) mod 60, Sec mod 60]);
    end
    else
    begin
      AverageSpeed := 0;
      lblAvrSpeed.Text := '0 KB';
      lblTotalTime.Text := Format('%.2d:%.2d:%.2d', [0, 0, 0]);
    end;

    if AverageSpeed > 0 then
    begin
      Sec := Trunc(((PB.Max - AWorkCount) / 1024) / AverageSpeed);
      lblRemainingTime.Text := Format('%.2d:%.2d:%.2d', [Sec div 3600, (Sec div 60) mod 60, Sec mod 60]);
    end
    else
    begin
      lblRemainingTime.Text := '';
    end;

    lblTransferredSize.Text := Format('%f KB', [AWorkCount / 1000]);
  end;

  PB.Position := AWorkCount;
  Application.ProcessMessages;
end;

procedure TfrmFTPProgress.FTPClientWorkEnd(Sender: TObject;
  AWorkMode: TWorkMode);
begin
  if FFTP = nil then Exit;
  FFTP.InTransfer := False;
end;

procedure TfrmFTPProgress.AssignNewEventHandler(AFTP: TIdFTP);
begin
  // Preserve Event Handler;
  OnWork := AFTP.OnWork;
  OnWorkBegin := AFTP.OnWorkBegin;
  OnWorkEnd := AFTP.OnWorkEnd;

  // Assign New Event Handler
  AFTP.OnWork := FTPClientWork;
  AFTP.OnWorkBegin := FTPClientWorkBegin;
  AFTP.OnWorkEnd := FTPClientWorkEnd;
end;

procedure TfrmFTPProgress.AssignPreservedEventHandler(AFTP: TIdFTP);
begin
  // Assign Preserved Event Handler
  AFTP.OnWork := OnWork;
  AFTP.OnWorkBegin := OnWorkBegin;
  AFTP.OnWorkEnd := OnWorkEnd;
end;

function TfrmFTPProgress.Get(const Src, Dest: String) : Boolean;
var
  Stream : TFileStream;
begin
  Result := False;

  Stream := TFileStream.Create(Dest, fmCreate);
  try
    Result := StreamGet(Src, Stream);
  finally
    FreeAndNil(Stream);
  end;
end;

function TfrmFTPProgress.Put(const Src, Dest: String) : Boolean;
var
  Stream : TFileStream;
begin
  Result := False;
  if FileExists(Src) then
  begin
    Stream := TFileStream.Create(Src, fmOpenRead or fmShareDenyNone);
    try
      Result := StreamPut(Stream, Dest);
    finally
      FreeAndNil(Stream);
    end;
  end;
end;

function TfrmFTPProgress.StreamGet(const Src: String;
  Dest: TStream): Boolean;
var
  szFile, szRemoteDir, szPrevDir : string;
begin
  Result := False;
  if FFTP = nil then Exit;

  if Dest <> nil then
  begin
    FFTP.TransferAborted := False;

    szFile := Src;

    AssignNewEventHandler(FFTP.FTPClient);
    try
      if not FFTP.Connected then
      begin
        FFTP.Connect;
      end;

      if FFTP.Connected then
      begin
        lblFileName.Text := szFile;
        szRemoteDir := aeExtractFilePath(szFile);
        szPrevDir := FFTP.RetrieveCurrentDir;
        if (szRemoteDir <> '') and (szRemoteDir <> szPrevDir) then
          FFTP.ChangeDirTo(szRemoteDir);
        FFTP.ChangeTransferType(ftBinary);

        nSrcSize := FFTP.Size(aeExtractFileName(szFile));
        if nSrcSize <> -1 then
        begin
          lblFileSize.Text := Format('%.2f KB', [nSrcSize / 1000]);
          Result := FFTP.Get(aeExtractFileName(szFile), Dest);
        end
        else
        begin
          nSrcSize := 0;
          FFTP.List(nil);
          if FFTP.FileExists(aeExtractFileName(szFile)) then
            Result := FFTP.Get(aeExtractFileName(szFile), Dest);
        end;

        if szRemoteDir <> szPrevDir then
          FFTP.ChangeDirTo(szPrevDir);

        if FFTP.TransferAborted then
          Result := False;
      end;
    finally
      if FFTP.Connected then
      begin
        FFTP.Quit;
      end;
      AssignPreservedEventHandler(FFTP.FTPClient);
    end;
  end;
end;

function TfrmFTPProgress.StreamPut(Src: TStream;
  const Dest: String): Boolean;
var
  szFile, szRemoteDir, szPrevDir : string;
begin
  Result := False;
  if FFTP = nil then Exit;

  FFTP.TransferAborted := False;

  szFile := Dest;

  nSrcSize := Src.Size;
  lblFileSize.Text := Format('%.2f KB', [nSrcSize / 1000]);

  AssignNewEventHandler(FFTP.FTPClient);
  try
    if not FFTP.Connected then
    begin
      FFTP.Connect;
    end;

    if FFTP.Connected then
    begin
      lblFileName.Text := szFile;
      szRemoteDir := aeExtractFilePath(szFile);
      szPrevDir := FFTP.RetrieveCurrentDir;

      FFTP.MakeDir(szRemoteDir);
      if (szRemoteDir <> '') and (szRemoteDir <> szPrevDir) then
      begin
        FFTP.ChangeDirTo(szRemoteDir);
      end;

      FFTP.ChangeTransferType(ftBinary);
      Result := FFTP.Put(Src, aeExtractFileName(szFile));

      if szRemoteDir <> szPrevDir then
        FFTP.ChangeDirTo(szPrevDir);

      if FFTP.TransferAborted then
        Result := False;
    end;
  finally
    if FFTP.Connected then
    begin
      FFTP.Quit;
    end;
    AssignPreservedEventHandler(FFTP.FTPClient);
  end;
end;

procedure TfrmFTPProgress.AddFTPMessage(Msg: string; AColor: TColor);
var
  nIndex : Integer;
begin
  nIndex := Length(Msg);
  while nIndex > 0 do
  begin
    if CharInSet(Msg[nIndex], [#10, #13]) then
      Delete(Msg, nIndex, 1)
    else
      Break;
    Dec(nIndex);
  end;
  reMessage.SelAttributes.Color := AColor;
  reMessage.SelText := Msg + #10;
  reMessage.Perform(EM_SCROLLCARET, 0, 0);
end;

procedure TfrmFTPProgress.DoFTPMessage(Sender: TObject; const AMsg: string;
  const AColor: TColor);
begin
  AddFTPMessage(AMsg, AColor);
  if Assigned(PrevFTPMessage) then
    PrevFTPMessage(Sender, AMsg, AColor);
end;

procedure TfrmFTPProgress.btnCancelClick(Sender: TObject);
begin
  if FFTP.InTransfer then FFTP.Abort;

  ModalResult := mrCancel;
end;

end.
