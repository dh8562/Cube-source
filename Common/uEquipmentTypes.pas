unit uEquipmentTypes;

interface

uses
  Windows,
  Messages,
  Classes,
  SysUtils;

type
  TEquipmentAutoMode = (
    amIdle,
    amOriginAll,
    amManualRun,
    amRun,
    amPaused
  );

  TEquipmentHardware = (
    ehDigitalIO,
    ehAnalogIO,
    ehMotion,
    ehVision,
    ehOther
  );

  TEquipmentHardwareEvent = procedure (Sender : TObject; AHardware : TEquipmentHardware; var AResult : Boolean) of object;

  TRingFrameUpdateMessage = record
    Msg: Cardinal;
    CassetteIndex : WPARAM;
    SlotIndex : LPARAM;
    Result: LRESULT
  end;

  TChipTestedMessage = record
    Msg: Cardinal;
    ChipIndex : WPARAM;
    BinNo : LPARAM;
    Result: LRESULT
  end;

  TChipSortedMessage = record
    Msg: Cardinal;
    Column : WPARAM;
    Row : LPARAM;
    Result: LRESULT
  end;

implementation

end.
