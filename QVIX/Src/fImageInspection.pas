unit fImageInspection;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, dxSkinsCore, dxSkinOffice2010Silver,
  Vcl.StdCtrls, foButton, foButtonEdit, cxButtons, Vcl.Mask, foEdit,
  elExplorerBar,
  foStringUtils,

  uAligner,
  uEquipment,
  uEquipmentConsts,

  voInspection,

  foDataServer,
  TypInfo,
  CodeSiteLogging,
  foWinUtils, Vcl.ExtDlgs, Vcl.ExtCtrls, foIndicator, foControls;

type
  TfrmImageInspection = class(TForm)
    ImageDlg: TOpenPictureDialog;
    Panel4: TPanel;
    tmrAlignTest: TTimer;
    edtDir: TfoLabeledButtonEdit;
    listDateTime: TListBox;
    btnLoad: TcxButton;
    btnInspect: TcxButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtDirButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnLoadClick(Sender: TObject);
    procedure btnInspectClick(Sender: TObject);
  private
    { Private declarations }
    FFolderName : String;

    FAlignStepNo : Integer;
    procedure TackAlignTestProc(Sender: TObject; AChNo : Integer; AStep: Integer);
  public
    { Public declarations }
  end;

var
  frmImageInspection: TfrmImageInspection;

implementation

{$R *.dfm}

uses dmMachine, dmHAL;

procedure TfrmImageInspection.FormCreate(Sender: TObject);
var
  I : Integer;
begin
  tmrAlignTest.Enabled := False;

  FAlignStepNo := 0;
end;

procedure TfrmImageInspection.FormShow(Sender: TObject);
var
  szDir : String;
  szFileName : AnsiString;
  I : Integer;
begin
  Machine.FImageInspection := True;

  szDir := Trim(HAL.SysServer.AsString[S_PRODUCT_LOG_FILE_PATH]);
  if szDir = '' then szDir := 'D:\DATA\' else szDir := szDir + '\';

  szDir := szDir + formatDateTime('yyyy\MM\DD', now);

  listDateTime.Clear;
  edtDir.Text := szDir;
  edtDirButtonClick(nil);

  tmrAlignTest.Enabled := True;
end;

procedure TfrmImageInspection.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Machine.FImageInspection := False;
  tmrAlignTest.Enabled := False;
end;

procedure TfrmImageInspection.btnInspectClick(Sender: TObject);
var
  I : Integer;
  N: Integer;
  nChNo : Integer;
begin
  nChNo := 0;
  Machine.VisionInspectionStart(nChNo, 0);

  Equipment.BroadcastMessage(UM_REPORT_UPDATE, 0, 0);
end;

procedure TfrmImageInspection.btnLoadClick(Sender: TObject);
var
  nIndex : Integer;
  szDateTime : String;
  szFileName, szTemp : String;
  I : Integer;
begin
  nIndex := listDateTime.ItemIndex;

  if nIndex > -1 then
  begin
    szDateTime := listDateTime.Items[nIndex];

    szTemp := edtDir.Text + '\IMAGE\CAM1\' + szDateTime;
    for I := 0 to HAL.JobServer.AsInteger[J_DEVICE_COUNT_X]-1 do
    begin
      szFileName := Format('%s_%.02d.jpg',[szTemp, I+1]);
      if FileExists(szFileName) then
      begin
        Aligner(0).LoadFromImage(szFileName);
      end;
    end;

    szTemp := edtDir.Text + '\IMAGE\CAM2\' + szDateTime;
    for I := 0 to HAL.JobServer.AsInteger[J_DEVICE_COUNT_X]-1 do
    begin
      szFileName := Format('%s_%.02d.jpg',[szTemp, I+1]);
      if FileExists(szFileName) then
      begin
        Aligner(1).LoadFromImage(szFileName);
      end;
    end;
  end;

end;

procedure TfrmImageInspection.edtDirButtonClick(Sender: TObject);
var
  i : Integer;

  FileAttrs : Integer;
  sr: TSearchRec;

  nCamNo : Integer;

  szFileName : String;
  slReport : TStrings;
  slLine : TStrings;
  szTemp, szTemp1, szTemp2 : String;
begin
  listDateTime.Clear;

  FFolderName := edtDir.Text;

  FileAttrs := faAnyFile;
  szFileName := '';
  if FindFirst(FFolderName + '\*', FileAttrs, sr) = 0 then
  begin
    repeat
      if (sr.Attr and FileAttrs) = sr.Attr then
      begin
        if (sr.Name <> '.') and (sr.Name <> '..') then
        begin
          if Copy(sr.Name, 1, 6) = 'report' then
          begin
            szFileName := edtDir.Text + '\' + sr.Name;
          end;
        end;
      end;
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;

  if FileExists(szFileName) then
  begin
    slReport := TStringList.Create;
    slReport.LoadFromFile(szFileName);

    for I := 1 to slReport.Count-1 do
    begin
      szTemp := slReport[I];

      slLine := TStringList.Create;
      foSplitWord(szTemp, [','], slLine);

      if slLine.Count > 2 then
      begin
        szTemp1 := slLine[0];
        szTemp2 := slLine[1];

        szTemp := Copy(szTemp1, 1, 4) + '_' + Copy(szTemp1, 6, 2) + '_' + Copy(szTemp1, 9, 2) + '_' +
                  Copy(szTemp2, 1, 2) + '_' + Copy(szTemp2, 4, 2) + '_' + Copy(szTemp2, 7, 2);
        listDateTime.Items.Add(szTemp);
      end;
      FreeAndNil(slLine);
    end;
    FreeAndNil(slReport);
  end;

end;

procedure TfrmImageInspection.TackAlignTestProc(Sender: TObject; AChNo : Integer; AStep: Integer);
begin
end;

end.
