program nOLS;

uses
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  Windows,
  ComObj,
  ActiveX,
  fMain in 'fMain.pas' {frmMain},
  dmData in 'dmData.pas' {Data: TDataModule},
  uFactoryOnControlDevExSkinner in 'uFactoryOnControlDevExSkinner.pas',
  uCommonUtils in 'uCommonUtils.pas',
  fSetup in 'fSetup.pas' {frmSetup},
  foCommEx in '..\..\Common\Communication\Core\foCommEx.pas',
  fEditPeakItem in 'fEditPeakItem.pas' {frmEditPeakItem},
  USB_RELAY_DEVICE in '..\..\Common\Communication\Devices\USB_RELAY_DEVICE.pas';

{$R *.res}

begin
  Application.Initialize;

  Application.MainFormOnTaskbar := True;
  Application.ShowMainForm := True;

  Application.Title := 'nOLS v1.0.0';
  Application.CreateForm(TData, Data);
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmSetup, frmSetup);
  Application.CreateForm(TfrmEditPeakItem, frmEditPeakItem);
  Application.Run;
end.




