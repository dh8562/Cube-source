unit uCommBase;

interface

uses
  System.Classes, System.SysUtils;

type
  TQVIXCommState = (qcsClosed, qcsOpening, qcsOpen, qcsError);
  TQVIXCommStatusEvent = procedure(Sender: TObject; const AState: TQVIXCommState;
    const AMessage: string) of object;
  TQVIXCommDataEvent = procedure(Sender: TObject; const AData: TBytes) of object;

  TQVIXCommConfig = record
    PortNo: Integer;
    BaudRate: Integer;
    SlaveAddress: Byte;
    TimeoutMs: Cardinal;
  end;

  TQVIXCommDevice = class(TComponent)
  private
    FConfig: TQVIXCommConfig;
    FState: TQVIXCommState;
    FLastMessage: string;
    FOnStatus: TQVIXCommStatusEvent;
    FOnData: TQVIXCommDataEvent;
  protected
    procedure SetState(const AState: TQVIXCommState;
      const AMessage: string = '');
    procedure NotifyData(const AData: TBytes);
  public
    constructor Create(AOwner: TComponent); override;
    procedure Configure(const AConfig: TQVIXCommConfig); virtual;
    function Open: Boolean; virtual; abstract;
    procedure Close; virtual; abstract;
    function Send(const AData: TBytes): Boolean; virtual; abstract;
    property Config: TQVIXCommConfig read FConfig;
    property State: TQVIXCommState read FState;
    property LastMessage: string read FLastMessage;
    property OnStatus: TQVIXCommStatusEvent read FOnStatus write FOnStatus;
    property OnData: TQVIXCommDataEvent read FOnData write FOnData;
  end;

implementation

procedure TQVIXCommDevice.Configure(const AConfig: TQVIXCommConfig);
begin
  if FState = qcsOpen then
    raise EInvalidOperation.Create('Close the communication before configuring it');
  FConfig := AConfig;
end;

constructor TQVIXCommDevice.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FConfig.PortNo := 1;
  FConfig.BaudRate := 9600;
  FConfig.SlaveAddress := 1;
  FConfig.TimeoutMs := 300;
  FState := qcsClosed;
end;

procedure TQVIXCommDevice.NotifyData(const AData: TBytes);
begin
  if Assigned(FOnData) then
    FOnData(Self, AData);
end;

procedure TQVIXCommDevice.SetState(const AState: TQVIXCommState;
  const AMessage: string);
begin
  FState := AState;
  FLastMessage := AMessage;
  if Assigned(FOnStatus) then
    FOnStatus(Self, AState, AMessage);
end;

end.
