unit fObjectInspector;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs,
  StdCtrls,
  ExtCtrls,
  ImgList,
  Menus,

  dxSkinsCore,
  dxSkinOffice2010Silver,
  dxSkinscxPCPainter,
  dxBarBuiltInMenu,
  cxGraphics,
  cxControls,
  cxLookAndFeels,
  cxLookAndFeelPainters,
  cxContainer,
  cxEdit,
  cxStyles,
  cxInplaceContainer,
  cxVGrid,
  cxOI,
  cxCheckBox,
  cxButtons,
  cxPC,

  elBase,
  elPropSaver,

  foTypes,
  foDataServer,
  foDataServerUtils,
  uEquipmentUtils, System.ImageList, cxImageList;

type
  TfrmObjectInspector = class(TForm)
    pcViewers: TcxPageControl;
    pnlCommand: TPanel;
    btnClose: TcxButton;
    ImageList: TcxImageList;
    btnRefresh: TcxButton;
    PropSaver: TelPropSaver;
    btnSyncTo: TcxButton;
    OpenDialog: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSyncToClick(Sender: TObject);
  private
    FRowHeaderWidth: Integer;
    { Private declarations }
    procedure DoInspectorPropertyChanged(Sender: TObject);
    procedure CreateInspectorPage(ATitle : string; const AObject : TPersistent);
  public
    { Public declarations }
    procedure Setup(ADataList : TStrings); overload;
    procedure Setup(ATitle : string; const AObject : TPersistent); overload;

    property RowHeaderWidth : Integer read FRowHeaderWidth write FRowHeaderWidth;
  end;


procedure ShowObjectInspector(ADataList : TStrings); overload;
procedure ShowObjectInspector(const ATitle : string; const AObject : TPersistent); overload;

implementation

{$R *.dfm}

procedure ShowObjectInspector(ADataList : TStrings);
var
  F : TfrmObjectInspector;
begin
  F := TfrmObjectInspector.Create(nil);
  try
    F.Setup(ADataList);
    F.ShowModal;
  finally
    FreeAndNil(F);
  end;
end;

procedure ShowObjectInspector(const ATitle : string; const AObject : TPersistent); overload;
var
  F : TfrmObjectInspector;
begin
  F := TfrmObjectInspector.Create(nil);
  try
    F.Setup(ATitle, AObject);
    F.ShowModal;
  finally
    FreeAndNil(F);
  end;
end;


function SynchronizeChannels(SrcServer, DestServer : TfoCustomDataServer) : Boolean;
var
  nIndex : Integer;
  DestIndex : Integer;
  TmpServer : TfoDataServer;
  OrgDataType, DestDataType : TfoChannelDataType;

begin
  SrcServer.ChannelsChanged;
  DestServer.ChannelsChanged;

  nIndex := Pred(DestServer.Channels.Count);
  while nIndex >= 0 do
  begin
    if SrcServer.Channels.IndexOf(DestServer.Channels[nIndex].Name) = -1 then
    begin
      DestServer.Channels[nIndex].Free;
    end;
    Dec(nIndex);
  end;

  DestServer.Channels.Sort;

  TmpServer := TfoDataServer.Create(nil);
  try
    nIndex := 0;
    while nIndex < SrcServer.Channels.Count do
    begin
      DestIndex := DestServer.Channels.IndexOf(SrcServer.Channels[nIndex].Name);
      if DestIndex = -1 then
      begin
        // 속도를 위해 새로 추가된 채널은 별도의 서버에 보관한다.
        with TmpServer.Channels.Add do
        begin
          Assign(SrcServer.Channels[nIndex]);
        end;
      end
      else
      begin
        OrgDataType := SrcServer.Channels[nIndex].DataType;
        DestDataType := DestServer.Channels[DestIndex].DataType;
        DestServer.Channels[DestIndex].Assign(SrcServer.Channels[nIndex]);
        if DestDataType <> OrgDataType then
          DestServer.Channels[DestIndex].DataType := DestDataType;
      end;
      Inc(nIndex);
    end;

    nIndex := 0;
    while nIndex < TmpServer.Channels.Count do
    begin
      with DestServer.Channels.Add do
      begin
        Assign(TmpServer.Channels[nIndex]);
      end;
      Inc(nIndex);
    end;

    DestServer.ChannelsChanged;
  finally
    FreeAndNil(TmpServer);
  end;
  Result := True;
end;

procedure TfrmObjectInspector.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmObjectInspector.btnRefreshClick(Sender: TObject);
var
  I : Integer;
begin
  for I := 0 to ComponentCount - 1 do
  begin
    if Components[I] is TcxRTTIInspector then
    begin
      TcxRTTIInspector(Components[I]).RefreshInspectedProperties;
    end;
  end;
end;

procedure TfrmObjectInspector.btnSyncToClick(Sender: TObject);
var
  DS : TfoDataServer;
  OrgDS : TfoDataServer;
begin
  if OpenDialog.Execute then
  begin
    if pcViewers.ActivePage <> nil then
    begin
      DS := TfoDataServer.Create(nil);
      OrgDS := TfoDataServer.Create(nil);
      try
        foObjectSyncTo(TcxRTTIInspector(pcViewers.ActivePage.Tag).InspectedObject, DS);
        if FileExists(OpenDialog.FileName) then
        begin
          OrgDS.LoadFromCSVFile(OpenDialog.FileName);
          SynchronizeChannels(OrgDS, DS);
          DS.SaveToCSVFile(OpenDialog.FileName);
        end
        else
          DS.SaveToCSVFile(OpenDialog.FileName);
      finally
        OrgDS.Free;
        DS.Free;
      end;
    end;
  end;
end;

procedure TfrmObjectInspector.CreateInspectorPage(ATitle: string;
  const AObject: TPersistent);
var
  TS : TcxTabSheet;
  Inspector : TcxRTTIInspector;
begin
  TS := TcxTabSheet.Create(Self);
  TS.Caption := ATitle;
  TS.Hint := ATitle;
  TS.PageControl := pcViewers;
  Inspector := TcxRTTIInspector.Create(Self);
  Inspector.Parent := TS;
  Inspector.Align := alClient;
  Inspector.OptionsView.RowHeaderWidth := FRowHeaderWidth;
  Inspector.OnPropertyChanged := DoInspectorPropertyChanged;

  TS.Tag := LongInt(Inspector);

  if (AObject <> nil) then
  begin
    Inspector.InspectedObject := AObject;
  end;
end;

procedure TfrmObjectInspector.DoInspectorPropertyChanged(Sender: TObject);
begin
  FRowHeaderWidth := TcxRTTIInspector(Sender).OptionsView.RowHeaderWidth;
end;

procedure TfrmObjectInspector.FormCreate(Sender: TObject);
begin
  DesktopFont := True;
  PropSaver.INIFileName := ChangeFileExt(Application.ExeName, '.ini');
  FRowHeaderWidth := PropSaver.ReadInteger(PropSaver.FormStateSection, 'RowHeaderWidth', 200);
end;

procedure TfrmObjectInspector.FormDestroy(Sender: TObject);
begin
  PropSaver.WriteInteger(PropSaver.FormStateSection, 'RowHeaderWidth', FRowHeaderWidth);
end;

procedure TfrmObjectInspector.Setup(ATitle: string; const AObject: TPersistent);
begin
  Self.Caption := ATitle;
  CreateInspectorPage(ATitle, AObject);
end;

procedure TfrmObjectInspector.Setup(ADataList: TStrings);
var
  I : Integer;
begin
  for I := 0 to ADataList.Count - 1 do
  begin
    if (ADataList.Objects[I] <> nil) and (ADataList.Objects[I] is TPersistent) then
    begin
      CreateInspectorPage(ADataList[I], TPersistent(ADataList.Objects[I]));
    end;
  end;
end;

end.
