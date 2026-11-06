unit uFactoryOnControlDevExSkinner;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Graphics,
  Controls,
  Forms,
  Types,

  dxSkinsForm,
  cxLookAndFeels,
  cxLookAndFeelPainters,
  cxGraphics,
  cxGeometry,

  elGraphicUtils,
  elExplorerBar;

implementation

type
  TdxSkinExplorerBarController = class(TdxSkinCustomControlController)
  public
    procedure Draw(DC: HDC = 0); override;
  end;

  TdxSkinExplorerBarGroupController = class(TdxSkinCustomControlController)
  public
    procedure Draw(DC: HDC = 0); override;
  end;

  TdxSkinCustomControlPainterAccess = class(TdxSkinCustomControlController);
  TelebGroupAccess = class(TelebGroup);

function dxMySkinGetControllerClassForWindow(AWnd: HWND): TdxSkinWinControllerClass;
var
  AControl: TControl;
begin
  Result := nil;
  if TdxSkinWinController.IsMDIClientWindow(AWnd) then
    Result := TdxSkinFormMDIClientController
  else
  begin
    AControl := FindControl(AWnd);
    if AControl <> nil then
    begin
      if AControl is TCustomForm then
        Result := TdxSkinFormController;
      if AControl is TCustomFrame then
        Result := TdxSkinFrameController;
      if SameText(AControl.ClassName, 'TButton') then
        Result := TdxSkinButtonController;
      if SameText(AControl.ClassName, 'TPanel') or
         SameText(AControl.ClassName, 'TGridPanel') or
         SameText(AControl.ClassName, 'TFlowPanel') then
        Result := TdxSkinPanelController;
      if SameText(AControl.ClassName, 'TelExplorerBar') then
        Result := TdxSkinExplorerBarController;
      if SameText(AControl.ClassName, 'TelebGroup') then
        Result := TdxSkinExplorerBarGroupController;
    end;
  end;
end;

{ TdxSkinExplorerBarController }

procedure TdxSkinExplorerBarController.Draw(DC: HDC);
var
  AControl: TWinControl;
begin
  AControl := WinControl;
  if Assigned(AControl) then
  begin
    cxPaintCanvas.BeginPaint(DC);
    try
      cxPaintCanvas.SaveClipRegion;
      try
        ViewInfo.LookAndFeelPainter.DrawPanelBackground(cxPaintCanvas, AControl, ViewInfo.ClientRect);
      finally
        cxPaintCanvas.RestoreClipRegion;
      end;
    finally
      cxPaintCanvas.EndPaint;
    end;
  end;
end;

{ TdxSkinExplorerBarGroupController }

procedure ExcludeOpaqueChildren(AControl: TWinControl; DC: HDC);
var
  AChildControl: TControl;
  I: Integer;
begin
  if AControl <> nil then
    for I := 0 to AControl.ControlCount - 1 do
    begin
      AChildControl := AControl.Controls[I];
      if AChildControl.Visible and (csOpaque in AChildControl.ControlStyle) then
      begin
        with AChildControl.BoundsRect do
          ExcludeClipRect(DC, Left, Top, Right, Bottom);
      end;
    end;
end;

procedure TdxSkinExplorerBarGroupController.Draw(DC: HDC);
var
  AControl: TelebGroup;
  AFlags: Integer;
  rIcon, rCaption : TRect;
  TextColor : TColor;

  procedure DrawButtonText(const AFont : TFont; const ACaption : TCaption;
    const R: TRect; AFlags: Integer; ATextColor: TColor);
  begin
    cxPaintCanvas.Canvas.Font := AFont;
    if AControl.MouseInTitle then
      cxPaintCanvas.Canvas.Font.Style := AControl.GetVisualStyle.TitleHotFontStyles
    else
      cxPaintCanvas.Canvas.Font.Style := AControl.GetVisualStyle.TitleFontStyles;
    cxPaintCanvas.Canvas.Font.Color := ATextColor;
    cxPaintCanvas.DrawText(ACaption, R, AFlags, True);
  end;

begin
  AControl := TelebGroup(WinControl);
  if Assigned(AControl) then
  begin
    cxPaintCanvas.BeginPaint(DC);
    try
      cxPaintCanvas.SaveClipRegion;
      try
        if not (csPaintCopy in AControl.ControlState) then
          ExcludeOpaqueChildren(AControl, cxPaintCanvas.Canvas.Handle);

        AControl.Color := ViewInfo.LookAndFeelPainter.DefaultContentColor;
        LookAndFeelPainter.DrawGroupBoxBackground(cxPaintCanvas, AControl.BoundsRect, ViewInfo.ClientRect);
        LookAndFeelPainter.DrawGroupBoxFrame(cxPaintCanvas, ViewInfo.ClientRect, True, cxgpTop);

        rCaption := ViewInfo.ClientRect;
        rCaption.Bottom := AControl.GetGroupTitleHeight;
        LookAndFeelPainter.DrawGroupBoxCaption(cxPaintCanvas, rCaption, ViewInfo.ClientRect, cxgpTop);

        LookAndFeelPainter.DrawBorder(cxPaintCanvas, ViewInfo.ClientRect);

        if not (goHideTitle in AControl.Options) then
        begin
          rIcon := AControl.GetTitleIconRect;
          AControl.DrawTitleIcon(cxPaintCanvas.Canvas, rIcon);

          rCaption.Left := rIcon.Right + 4;
          AFlags := cxAlignLeft or cxAlignVCenter or cxShowPrefix or cxSingleLine;
          TextColor := ViewInfo.LookAndFeelPainter.PanelTextColor;
          DrawButtonText(AControl.Font, AControl.Caption, rCaption, AFlags, TextColor);

          if not (goHideOpenClose in AControl.Options) then
          begin
            rIcon := AControl.GetOpenCloseIconRect;

            if AControl.MouseInTitle then
              elDrawChevron(cxPaintCanvas.Canvas, rIcon.Left, rIcon.Top, elLighten(TextColor, -30), AControl.Expanded)
            else
              elDrawChevron(cxPaintCanvas.Canvas, rIcon.Left, rIcon.Top, TextColor, AControl.Expanded);
          end;

          if (goShowMaximize in AControl.Options) and AControl.Expanded then
          begin
            rIcon := AControl.GetMaximizeIconRect;

            if AControl.MouseInTitle then
              elDrawMaximizeIcon(cxPaintCanvas.Canvas, rIcon.Left, rIcon.Top, elLighten(TextColor, -30), AControl.FullSize)
            else
              elDrawMaximizeIcon(cxPaintCanvas.Canvas, rIcon.Left, rIcon.Top, TextColor, AControl.FullSize);
          end;
        end;
      finally
        cxPaintCanvas.RestoreClipRegion;
      end;

      TelebGroupAccess(AControl).PaintControls(cxPaintCanvas.Canvas.Handle, nil);
    finally
      cxPaintCanvas.EndPaint;
    end;
  end;
end;

initialization
  dxSkinGetControllerClassForWindowProc := dxMySkinGetControllerClassForWindow;

end.
