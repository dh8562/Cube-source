unit uEquipmentUtils;

interface

uses
  Windows, Classes, SysUtils, TypInfo, Graphics, Menus, Forms, Controls,

  OmniXml,
  OmniXmlPersistent,
  OmniXml_Types,

  foStringUtils,
  foGraphicUtils,
  foRTTIUtils,
  foTypes,
  foMotion,
  foDataServer,
  foDataServerUtils;

type
  CategoryAttribute = class(TCustomAttribute)
  private
    FCategory : string;
  public
    constructor Create(ACategory : string);
    property Category : string read FCategory write FCategory;
  end;

  DescriptionAttribute = class(TCustomAttribute)
  private
    FDescription : string;
  public
    constructor Create(ADescription : string);
    property Description : string read FDescription write FDescription;
  end;

procedure foLoadAxisInfo(Axis: TfoCustomAxis; ADataServer : TfoCustomDataServer);
procedure foLoadAxisSpeed(Axis: TfoCustomAxis; ADataServer : TfoCustomDataServer);
procedure foChangeLoadAxisSpeed(Axis: TfoCustomAxis; ADataServer : TfoCustomDataServer);

procedure foObjectSyncTo(AObject : TPersistent; ADataServer : TfoCustomDataServer);
procedure foObjectSyncFrom(AObject : TPersistent; ADataServer : TfoCustomDataServer);

procedure foObjectToXmlFile(AObject : TPersistent; const AFileName : string);
procedure foObjectFromXmlFile(AObject : TPersistent; const AFileName : string);

procedure foObjectFromXmlStream(AObject: TPersistent; AStream: TStream);
procedure foObjectToXmlStream(AObject: TPersistent; AStream: TStream);

procedure foLoadAndSync(AStream : TStream; ADataServer : TfoDataServer);

procedure foSendMessage(AControl : TWinControl; Msg: UINT; WordParam: WPARAM; LongParam: LPARAM; const AAsync : Boolean = False; const ATimeout : Integer = 1000);
procedure foBroadcastMessage(Msg: UINT; WordParam: WPARAM; LongParam: LPARAM; const AAsync : Boolean = False; const ATimeout : Integer = 1000);

implementation

{ CategoryAttribute }

constructor CategoryAttribute.Create(ACategory: string);
begin
  FCategory := ACategory;
end;

{ DescriptionAttribute }

constructor DescriptionAttribute.Create(ADescription: string);
begin
  FDescription := ADescription;
end;

procedure foChangeLoadAxisSpeed(Axis: TfoCustomAxis; ADataServer : TfoCustomDataServer);
var
  CH : TfoChannel;
begin
  with Axis do
  begin
    Velocity := ADataServer.AsDouble[ChannelPrefix + 'ATTACH_VEL'];
    Acceleration := ADataServer.AsDouble[ChannelPrefix + 'ACCEL'];
    OriginVelocity := ADataServer.AsDouble[ChannelPrefix + 'ORG_VEL'];
    OriginAccel := ADataServer.AsDouble[ChannelPrefix + 'ORG_ACCEL'];
    JogVelocity := ADataServer.AsDouble[ChannelPrefix + 'JOG_VEL'];
    JogAccel := ADataServer.AsDouble[ChannelPrefix + 'JOG_ACCEL'];
    StartUpVelocity := ADataServer.AsDouble[ChannelPrefix + 'STARTUP_VEL'];

    CH := ADataServer.Channels.SilentFind(ChannelPrefix + 'DECEL');
    if CH <> nil then
      Deceleration := CH.AsDouble
    else
      Deceleration := Acceleration;

    CH := ADataServer.Channels.SilentFind(ChannelPrefix + 'JERK');
    if CH <> nil then
      Jerk := CH.AsDouble;
    CH := ADataServer.Channels.SilentFind(ChannelPrefix + 'JOG_JERK');
    if CH <> nil then
      JogJerk := CH.AsDouble;
  end;
end;

procedure foLoadAxisSpeed(Axis: TfoCustomAxis; ADataServer : TfoCustomDataServer);
var
  CH : TfoChannel;
begin
  with Axis do
  begin
    Velocity := ADataServer.AsDouble[ChannelPrefix + 'VEL'];
    Acceleration := ADataServer.AsDouble[ChannelPrefix + 'ACCEL'];
    OriginVelocity := ADataServer.AsDouble[ChannelPrefix + 'ORG_VEL'];
    OriginAccel := ADataServer.AsDouble[ChannelPrefix + 'ORG_ACCEL'];
    JogVelocity := ADataServer.AsDouble[ChannelPrefix + 'JOG_VEL'];
    JogAccel := ADataServer.AsDouble[ChannelPrefix + 'JOG_ACCEL'];
    StartUpVelocity := ADataServer.AsDouble[ChannelPrefix + 'STARTUP_VEL'];

    CH := ADataServer.Channels.SilentFind(ChannelPrefix + 'DECEL');
    if CH <> nil then
      Deceleration := CH.AsDouble
    else
      Deceleration := Acceleration;

    CH := ADataServer.Channels.SilentFind(ChannelPrefix + 'JERK');
    if CH <> nil then
      Jerk := CH.AsDouble;
    CH := ADataServer.Channels.SilentFind(ChannelPrefix + 'JOG_JERK');
    if CH <> nil then
      JogJerk := CH.AsDouble;
  end;
end;

procedure foLoadAxisInfo(Axis: TfoCustomAxis; ADataServer : TfoCustomDataServer);
var
  CH: TfoChannel;
begin
  with Axis do
  begin
    AxisNo := ADataServer.AsInteger[ChannelPrefix + 'AXIS_NO'];
    DistancePerPulse := ADataServer.AsDouble[ChannelPrefix + 'DPR'];
    SetSetProp(Axis, 'OutputsActiveLogic', ADataServer.AsString[ChannelPrefix + 'OUTPUTS_LOGIC']);
    SetSetProp(Axis, 'SensorsActiveLogic', ADataServer.AsString[ChannelPrefix + 'SENSORS_LOGIC']);
    SetSetProp(Axis, 'Options', ADataServer.AsString[ChannelPrefix + 'OPTIONS']);
    SetSetProp(Axis, 'OriginOptions', ADataServer.AsString[ChannelPrefix + 'ORIGIN_OPTIONS']);

    CH := ADataServer.Channels.SilentFind(ChannelPrefix + 'INPOSITION_TOLERANCE');
    if CH <> nil then
      InPositionTolerance := CH.AsDouble;

    CH := ADataServer.Channels.SilentFind(ChannelPrefix + 'ORIGIN_OFFSET');
    if CH <> nil then
      OriginOffset := CH.AsDouble;

    CH := ADataServer.Channels.SilentFind(ChannelPrefix + 'ORIGIN_DIRECTION');
    if CH <> nil then
      OriginDirection :=  TfoAxisDirection(CH.AsInteger);

    CH := ADataServer.Channels.SilentFind(ChannelPrefix + 'PULSE_OUTPUT_METHOD');
    if CH <> nil then
      PulseOutputMethod := TfoPulseOutputMethod(CH.AsInteger);

    CH := ADataServer.Channels.SilentFind(ChannelPrefix + 'PULSE_DIRECTION');
    if CH <> nil then
      PulseOutputDirection := TfoPulseOutputDirection(CH.AsInteger);

    CH := ADataServer.Channels.SilentFind(ChannelPrefix + 'CW_SW_LIMIT');
    if CH <> nil then
    begin
      CWEndPos := CH.AsDouble;
      CWSWLimit := CH.AsDouble;
    end;

    CH := ADataServer.Channels.SilentFind(ChannelPrefix + 'CCW_SW_LIMIT');
    if CH <> nil then
    begin
      CCWEndPos := CH.AsDouble;
      CCWSWLimit := CH.AsDouble;
    end;

    CH := ADataServer.Channels.SilentFind(ChannelPrefix + 'POS_ERROR_LIMIT');
    if CH <> nil then
      PositionErrorLimit := CH.AsDouble;

//    CH := IOServer.Channels.SilentFind(ChannelPrefix + 'CW');
//    if CH <> nil then
//    begin
//      CH.ErrorCode := ERR_CW_LIMIT_TR + Axis.AxisNo;
//    end;
//
//    CH := IOServer.Channels.SilentFind(ChannelPrefix + 'CCW');
//    if CH <> nil then
//    begin
//      CH.ErrorCode := ERR_CCW_LIMIT_TR + Axis.AxisNo;
//    end;
//
//    CH := IOServer.Channels.SilentFind(ChannelPrefix + 'TIMEOUT');
//    if CH <> nil then
//    begin
//      CH.ErrorCode := ERR_MOVE_TIMEOUT_TR + Axis.AxisNo;
//    end;
//
//    CH := IOServer.Channels.SilentFind(ChannelPrefix + 'POSITION_ERROR');
//    if CH <> nil then
//    begin
//      CH.ErrorCode := ERR_POSITION_ERROR_TR + Axis.AxisNo;
//    end;
//
//    CH := IOServer.Channels.SilentFind(ChannelPrefix + 'ENCODER_FAULT');
//    if CH <> nil then
//    begin
//      CH.ErrorCode := ERR_ENCODER_ERROR_TR + Axis.AxisNo;
//    end;
//
//    CH := IOServer.Channels.SilentFind(ChannelPrefix + 'FAULT');
//    if CH <> nil then
//    begin
//      CH.ErrorCode := ERR_DRIVER_FAULT_TR + Axis.AxisNo;
//    end;
  end;
  foLoadAxisSpeed(Axis, ADataServer);
end;

procedure foObjectSyncTo(AObject : TPersistent; ADataServer : TfoCustomDataServer);
var
  PropCount : Integer;
  PropList : PPropList;
  Propinfo : PPropinfo;
  I : Integer;

  function AddChannel(ADataServer : TfoCustomDataServer; const AChannelName : string; const ADataType : TfoChannelDataType; const AValue : Variant; const ADesc : string = '') : TfoChannel;
  begin
    Result := ADataServer.Channels.Add;
    Result.Name := AChannelName;
    Result.DataType := ADataType;
    Result.Value := AValue;
    Result.ZDescription := ADesc;
  end;

begin
  ADataServer.Clear;
  ADataServer.BeginUpdate;

  PropCount := GetPropList(AObject, PropList);
  try
    for I := 0 to Pred(PropCount) do
    begin
      PropInfo := PropList^[I];
      if Propinfo^.PropType^.Kind in foDefaultTypeKinds then
      begin
        case Propinfo^.PropType^.Kind of

          tkInteger :
          begin
            if (Propinfo^.PropType^.Name = 'TColor') then
              AddChannel(ADataServer, Propinfo^.Name, dtString, foColorToHex(TColor(GetOrdProp(AObject, PropInfo))))
            else if (Propinfo^.PropType^.Name = 'TShortCut') then
              AddChannel(ADataServer, Propinfo^.Name, dtString, ShortCutToText(TShortCut(GetOrdProp(AObject, PropInfo))))
            else
              AddChannel(ADataServer, Propinfo^.Name, dtInteger, GetOrdProp(AObject, PropInfo));
          end;
          tkString,
          tkUString,
          tkLString,
          tkWString :
          begin
            AddChannel(ADataServer, Propinfo^.Name, dtString, GetStrProp(AObject, PropInfo));
          end;
          tkEnumeration :
          begin
            if Propinfo^.PropType^ = System.TypeInfo(Boolean) then
              AddChannel(ADataServer, Propinfo^.Name, dtBoolean, Boolean(GetOrdProp(AObject, PropInfo)), '')
            else
              AddChannel(ADataServer, Propinfo^.Name, dtString, GetEnumProp(AObject, PropInfo), '');
          end;
          tkChar,
          tkWChar :
          begin
            AddChannel(ADataServer, Propinfo^.Name, dtInteger, GetOrdProp(AObject, PropInfo));
          end;
          tkSet :
          begin
            AddChannel(ADataServer, Propinfo^.Name, dtString, SetToString(PropInfo, GetOrdProp(AObject, PropInfo)));
          end;
          tkFloat :
          begin
            AddChannel(ADataServer, Propinfo^.Name, dtDouble, GetFloatProp(AObject, PropInfo));
          end;
        end;
      end;
    end;
  finally
    ADataServer.EndUpdate;
    FreeMem(PropList);
  end;
end;

procedure foObjectSyncFrom(AObject : TPersistent; ADataServer : TfoCustomDataServer);
var
  PropCount : Integer;
  PropList : PPropList;
  Propinfo : PPropinfo;
  I : Integer;
begin
  PropCount := GetPropList(AObject, PropList);
  try
    for I := 0 to Pred(PropCount) do
    begin
      PropInfo := PropList^[I];
      if Propinfo^.PropType^.Kind in foDefaultTypeKinds then
      begin
        if ADataServer.ChannelExist(PropInfo^.Name) then
        begin
          with Propinfo^ Do
          begin
            case PropType^.Kind of
              tkInteger :
              begin
                if (PropType^.Name = 'TColor') then
                  SetOrdProp(AObject, PropInfo, foHexToColor(ADataServer.AsString[Name]))
                else if (PropType^.Name = 'TShortCut') then
                  SetOrdProp(AObject, PropInfo, TextToShortCut(ADataServer.AsString[Name]))
                else
                  SetOrdProp(AObject, PropInfo, ADataServer.AsInteger[Name]);
              end;
              tkString,
              tkUString,
              tkLString,
              tkWString :
              begin
                SetStrProp(AObject, PropInfo, ADataServer.AsString[Name]);
              end;
              tkEnumeration :
              begin
                if PropType^ = System.TypeInfo(Boolean) then
                  SetOrdProp(AObject, PropInfo, Ord(ADataServer.AsBoolean[Name]))
                else
                  SetEnumProp(AObject, PropInfo, ADataServer.AsString[Name]);
              end;
              tkChar,
              tkWChar :
              begin
                SetOrdProp(AObject, PropInfo, ADataServer.AsInteger[Name]);
              end;
              tkSet :
              begin
                SetOrdProp(AObject, PropInfo, StringToSet(PropInfo, ADataServer.AsString[Name]));
              end;
              tkFloat :
              begin
                SetFloatProp(AObject, PropInfo, ADataServer.AsDouble[Name]);
              end;
            end;
          end;
        end;
      end;
    end;
  finally
    FreeMem(PropList);
  end;
end;

procedure foObjectToXmlFile(AObject : TPersistent; const AFileName : string);
begin
  TOmniXmlWriter.SaveToFile(AObject, AFileName, pfAuto, ofIndent);
end;

procedure foObjectFromXmlFile(AObject : TPersistent; const AFileName : string);
begin
  TOmniXmlReader.LoadFromFile(AObject, AFileName);
end;


procedure DoLoad(var XMLDoc: IXMLDocument; var XMLRoot: IXMLElement;
  var PropsFormat: TPropsFormat);
const
  PropFormatValues: array[TPropsFormat] of string = ('auto', 'attr', 'node');
var
  i: TPropsFormat;
  PropFormatValue: XmlString;
begin
  // set root element
  XMLRoot := XMLDoc.documentElement;
  PropsFormat := pfNodes;

  if XMLRoot = nil then
    Exit;

  PropFormatValue := XMLRoot.GetAttribute('PropFormat');

  for i := Low(TPropsFormat) to High(TPropsFormat) do begin
    if SameText(PropFormatValue, PropFormatValues[i]) then begin
      PropsFormat := i;
      Break;
    end;
  end;
end;

procedure DoLoadDocumentFromStream(const AStream: TStream; var XMLDoc: IXMLDocument;
  var XMLRoot: IXMLElement; var PropsFormat: TPropsFormat);
begin
  XMLDoc := CreateXMLDoc;
  { TODO : implement and test preserveWhiteSpace }
  XMLDoc.preserveWhiteSpace := True;
  AStream.Position := 0;
  XMLDoc.LoadFromStream(AStream);

  DoLoad(XMLDoc, XMLRoot, PropsFormat);
end;


procedure foObjectFromXmlStream(AObject: TPersistent; AStream: TStream);
var
  XMLDoc: IXMLDocument;
  XMLRoot: IXMLElement;
  Reader: TOmniXMLReader;
  PropsFormat: TPropsFormat;
begin
  // read document
  DoLoadDocumentFromStream(AStream, XMLDoc, XMLRoot, PropsFormat);

  Reader := TOmniXMLReader.Create(PropsFormat);
  try
    if AObject is TCollection then
      Reader.ReadCollection(TCollection(AObject), XMLRoot)
    else
      Reader.Read(AObject, XMLRoot, True);
  finally
    Reader.Free;
  end;
end;

procedure DoCreateDocument(var XMLDoc: IXMLDocument; var Root: IXMLElement;
  RootNodeName: XmlString);
begin
  XMLDoc := CreateXMLDoc;
  Root := XMLDoc.CreateElement(RootNodeName);
  XMLDoc.DocumentElement := Root;
end;

procedure foObjectToXmlStream(AObject: TPersistent; AStream: TStream);
var
  XMLDoc: IXMLDocument;
  Root: IXMLElement;
  Writer: TOmniXMLWriter;
begin
  if AObject is TCollection then
    DoCreateDocument(XMLDoc, Root, AObject.ClassName)
  else
    DoCreateDocument(XMLDoc, Root, 'data');

  Writer := TOmniXMLWriter.Create(XMLDoc, pfAuto);
  try
    if AObject is TCollection then
      Writer.WriteCollection(TCollection(AObject), Root)
    else
      Writer.Write(AObject, Root);
  finally
    Writer.Free;
  end;

  XMLDoc.SaveToStream(AStream);
end;

function ImportChannelsFromCSV(Strs : TStrings; Channels : TfoChannels) : Boolean;
var
  TmpItem : TfoChannel;
  PropNameList : TStrings;
  ValueList : TStrings;
  nIndex, nPropIndex, nPropCount : Integer;
  bMissingAction : Boolean;
  szMissingActionName : string;
begin
  PropNameList := TStringList.Create;
  ValueList := TStringList.Create;
  try
    nPropCount := 0;
    nIndex := 0;
    while nIndex < Strs.Count do
    begin
      if nIndex = 0 then
      begin
        // ���ϴ� Collection�� ���� CSV �����ΰ�?
        if Strs[nIndex] <> Channels.ClassName then
        begin
          Break;
        end;
      end
      else if nIndex = 1 then
      begin
        foSplitWord(Strs[nIndex], [','], PropNameList);
        nPropCount := PropNameList.Count;
      end
      else
      begin
        foSplitWord(Strs[nIndex], [','], ValueList);
        if ValueList.Count = nPropCount then
        begin
          TmpItem := Channels.Add;
          bMissingAction := False;
          nPropIndex := 0;
          while nPropIndex < nPropCount do
          begin
            if (PropNameList[nPropIndex] <> 'Action') then
              foSetPropertyValue(TmpItem, PropNameList[nPropIndex], ValueList[nPropIndex]);
            Inc(nPropIndex);
          end;
        end;
      end;
      Inc(nIndex);
    end;
    Result := True;
  finally
    ValueList.Free;
    PropNameList.Free;
  end;
end;

function SynchronizeChannelValues(SrcServer, DestServer : TfoCustomDataServer) : Boolean;
var
  nIndex : Integer;
  DestIndex : Integer;
  TmpServer : TfoDataServer;
begin
  TmpServer := TfoDataServer.Create(nil);
  try
    nIndex := 0;
    while nIndex < SrcServer.Channels.Count do
    begin
      DestIndex := DestServer.Channels.IndexOf(SrcServer.Channels[nIndex].Name);
      if DestIndex = -1 then
      begin
        // �ӵ��� ���� ���� �߰��� ä���� ������ ������ �����Ѵ�.
        with TmpServer.Channels.Add do
        begin
          Assign(SrcServer.Channels[nIndex]);
        end;
      end
      else
      begin
        DestServer.Channels[DestIndex].Value := SrcServer.Channels[nIndex].Value;
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

    if TmpServer.Channels.Count > 0 then
      DestServer.ChannelsChanged;
  finally
    FreeAndNil(TmpServer);
  end;
  Result := True;
end;

procedure foLoadAndSync(AStream : TStream; ADataServer : TfoDataServer);
var
  DS : TfoDataServer;
  Strs : TStrings;
begin
  Strs := TStringList.Create;
  try
    AStream.Position := 0;
    Strs.LoadFromStream(AStream);
    DS := TfoDataServer.Create(nil);
    try
      ImportChannelsFromCSV(Strs, DS.Channels);
      SynchronizeChannelValues(DS, ADataServer);
    finally
      DS.Free;
    end;
  finally
    Strs.Free;
  end;
end;

procedure foSendMessage(AControl : TWinControl; Msg: UINT; WordParam: WPARAM; LongParam: LPARAM; const AAsync : Boolean; const ATimeout : Integer);
var
  I : Integer;
  // SendMessageTimeout result is pointer-sized on Win64.
  dwResult : DWORD_PTR;
begin
  if csDestroying in Application.ComponentState then Exit;

  if AControl.HandleAllocated then
  begin
    if AAsync then
      PostMessage(AControl.Handle, Msg, WordParam, LongParam)
    else
      SendMessageTimeout(AControl.Handle, Msg, WordParam, LongParam, SMTO_NORMAL, ATimeout, @dwResult);
  end;
end;

procedure foBroadcastMessage(Msg: UINT; WordParam: WPARAM; LongParam: LPARAM; const AAsync : Boolean; const ATimeout : Integer);
var
  I : Integer;
  dwResult : DWORD;
begin
  if csDestroying in Application.ComponentState then Exit;

  foSendMessage(Application.MainForm, Msg, WordParam, LongParam, AAsync, ATimeout);

  for I := Pred(Screen.FormCount) downto 0 do
  begin
    if Screen.Forms[I] <> Application.MainForm then
    begin
      foSendMessage(Screen.Forms[I], Msg, WordParam, LongParam, AAsync, ATimeout);
    end;
  end;
end;

end.
