program QRoBOT;

uses
  Vcl.Forms,
  qvMain in 'qvMain.pas' {frmMain},
  fOperation in 'fOperation.pas' {frmOperation},
  fStage in 'fStage.pas' {frmStage},
  fSpectrometer in 'fSpectrometer.pas' {frmSpectrometer},
  fPlasma in 'fPlasma.pas' {frmPlasma},
  fRecipes in 'fRecipes.pas' {frmRecipes},
  fAlarms in 'fAlarms.pas' {frmAlarms},
  fLogs in 'fLogs.pas' {frmLogs},
  fSettings in 'fSettings.pas' {frmSettings},
  fPeakDetectEdit in 'fPeakDetectEdit.pas' {frmPeakDetectEdit},
  uCommBase in '..\..\Common\Communication\Core\uCommBase.pas',
  uSerialDevice in '..\..\Common\Communication\Core\uSerialDevice.pas',
  foSyncObjs in '..\..\Common\Communication\Core\foSyncObjs.pas',
  foModbusDevice in '..\..\Common\Communication\Core\foModbusDevice.pas',
  uModbusRtuDevice in '..\..\Common\Communication\Core\uModbusRtuDevice.pas',
  uCommZMotion in '..\..\Common\Communication\Devices\uCommZMotion.pas',
  uCommSpectrometer in '..\..\Common\Communication\Devices\uCommSpectrometer.pas',
  uCommPlasma in '..\..\Common\Communication\Devices\uCommPlasma.pas',
  uCommWaterSensors in '..\..\Common\Communication\Devices\uCommWaterSensors.pas',
  uCommLevelSensor in '..\..\Common\Communication\Devices\uCommLevelSensor.pas',
  uCommDeferredDevice in '..\..\Common\Communication\Devices\uCommDeferredDevice.pas',
  uCommRemoteIO in '..\..\Common\Communication\Devices\uCommRemoteIO.pas',
  uCommMFM in '..\..\Common\Communication\Devices\uCommMFM.pas',
  uCommStageController in '..\..\Common\Communication\Devices\uCommStageController.pas',
  uCommunicationManager in 'uCommunicationManager.pas',
  uTouchInput in '..\..\Common\UI\uTouchInput.pas',
  uLogger in '..\..\Common\Core\uLogger.pas',
  fNumericKBD in '..\..\Common\UI\fNumericKBD.pas' {frmNumericKBD},
  fTouchKBD in '..\..\Common\UI\fTouchKBD.pas' {frmTouchKBD};

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'QRoBOT';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
