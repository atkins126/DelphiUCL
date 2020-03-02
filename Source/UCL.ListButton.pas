﻿unit UCL.ListButton;

interface

uses
  Classes, SysUtils, Types, Messages, Controls, ExtCtrls, ImgList, Graphics, Windows,
  UCL.Classes, UCL.ThemeManager, UCL.Colors, UCL.Graphics, UCL.Utils;

type
  TUListButton = class(TPanel, IUControl)
    private
      var BackColor, TextColor, DetailColor: TColor;
      var ImgRect, TextRect, DetailRect: TRect;

      FIconFont: TFont;
      FCustomBackColor: TUStateColorSet;
      
      FButtonState: TUControlState;
      FOrientation: TUOrientation;

      FImageKind: TUImageKind;
      FImages: TCustomImageList;
      FImageIndex: Integer;
      FFontIcon: string;
      
      FImageSpace: Integer;
      FSpacing: Integer;

      FDetail: string;
      FAllowSelected: Boolean;

      //  Internal
      procedure UpdateColors;
      procedure UpdateRects;
      
      //  Setters
      procedure SetButtonState(const Value: TUControlState);
      procedure SetOrientation(const Value: TUOrientation);
      procedure SetImageKind(const Value: TUImageKind);
      procedure SetImages(const Value: TCustomImageList);
      procedure SetImageIndex(const Value: Integer);
      procedure SetFontIcon(const Value: string);

      procedure SetImageSpace(const Value: Integer);
      procedure SetSpacing(const Value: Integer);

      procedure SetDetail(const Value: string);
      procedure SetAllowSelected(const Value: Boolean);

      //  Child events
      procedure CustomBackColor_OnChange(Sender: TObject);
      
      //  Messages
      procedure WM_SetFocus(var Msg: TWMSetFocus); message WM_SETFOCUS;
      procedure WM_KillFocus(var Msg: TWMKillFocus); message WM_KILLFOCUS;
      procedure WM_LButtonDblClk(var Msg: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
      procedure WM_LButtonDown(var Msg: TWMLButtonDown); message WM_LBUTTONDOWN;
      procedure WM_LButtonUp(var Msg: TWMLButtonUp); message WM_LBUTTONUP;

      procedure CM_MouseEnter(var Msg: TMessage); message CM_MOUSEENTER;
      procedure CM_MouseLeave(var Msg: TMessage); message CM_MOUSELEAVE;
      procedure CM_EnabledChanged(var Msg: TMessage); message CM_ENABLEDCHANGED;
      procedure CM_TextChanged(var Msg: TMessage); message CM_TEXTCHANGED;

    protected
      procedure Paint; override;
      procedure Resize; override;
      procedure CreateWindowHandle(const Params: TCreateParams); override;
      procedure ChangeScale(M, D: Integer{$IF CompilerVersion > 29}; isDpiChange: Boolean{$ENDIF}); override;

    public
      constructor Create(aOwner: TComponent); override;
      destructor Destroy; override;
      procedure Loaded; override;

      //  Interface
      function IsContainer: Boolean;
      procedure UpdateTheme(const UpdateChildren: Boolean);

    published
      property IconFont: TFont read FIconFont write FIconFont;
      property CustomBackColor: TUStateColorSet read FCustomBackColor write FCustomBackColor;
    
      property ButtonState: TUControlState read FButtonState write SetButtonState default csNone;
      property Orientation: TUOrientation read FOrientation write SetOrientation default oHorizontal;

      property ImageKind: TUImageKind read FImageKind write SetImageKind default ikFontIcon;
      property Images: TCustomImageList read FImages write SetImages;
      property ImageIndex: Integer read FImageIndex write SetImageIndex default -1;
      property FontIcon: string read FFontIcon write SetFontIcon;

      property ImageSpace: Integer read FImageSpace write SetImageSpace default 40;
      property Spacing: Integer read FSpacing write SetSpacing default 10;
      
      property Detail: string read FDetail write SetDetail;
      property AllowSelected: Boolean read FAllowSelected write SetAllowSelected default true;

      //  Modify default props
      property BevelOuter default bvNone;
      property ParentBackground default false;
      property TabStop default true;
  end;

implementation

{ TUListButton }

//  INTERFACE

function TUListButton.IsContainer: Boolean;
begin
  Result := false;
end;

procedure TUListButton.UpdateTheme(const UpdateChildren: Boolean);
begin
  UpdateColors;
  UpdateRects;
  Repaint;

  //  Do not update children
end;

//  INTERNAL

procedure TUListButton.UpdateColors;
var 
  TM: TUThemeManager;
  _BackColor: TUStateColorSet;
  AccentColor: TColor;
  Selected: Boolean;
  IsDark: Boolean;
begin
  TM := SelectThemeManager(Self);
  _BackColor := SelectColorSet(TM, CustomBackColor, LISTBUTTON_BACK);

  if TM = nil then
    AccentColor := $D77800
  else 
    AccentColor := TM.AccentColor;
  IsDark := (TM <> nil) and (TM.Theme = utDark);

  //  Disabled
  if not Enabled then
    begin
      if IsDark then
        BackColor := $333333
      else
        BackColor := $CCCCCC;
      TextColor := $666666;
      DetailColor := $808080;
    end

  //  Enabled
  else
    begin
      Selected := AllowSelected and Focused;
      if not Selected then
        //  Get color from colorset
        BackColor := _BackColor.GetColor(TM, ButtonState, Selected)
      else
        //  Change lightness of color
        BackColor := ColorChangeLightness(AccentColor, _BackColor.GetColor(TM, ButtonState, Selected));

      TextColor := GetTextColorFromBackground(BackColor);
      if not Selected then
        DetailColor := $808080    //  Detail on grayed color
      else
        DetailColor := $D0D0D0;   //  Detail on background color
    end;
end;

procedure TUListButton.UpdateRects;
begin
  //  Image rect
  if Orientation = oHorizontal then
    ImgRect := Rect(0, 0, ImageSpace, Height)
  else 
    ImgRect := Rect(0, 0, Width, ImageSpace);

  //  Text rect
  if Orientation = oHorizontal then
    TextRect := Rect(ImageSpace, 0, Width - Spacing, Height)
  else
    TextRect := Rect(0, ImageSpace, Width, Height - Spacing);

  //  Detail rect
  if Orientation = oHorizontal then
    DetailRect := Rect(ImageSpace, 0, Width - Spacing, Height)
  else
    DetailRect := Rect(0, ImageSpace, Width, Height - Spacing);
end;

//  SETTERS

procedure TUListButton.SetButtonState(const Value: TUControlState);
begin
  if Value <> FButtonState then
    begin
      FButtonState := Value;
      UpdateColors;
      Repaint;
    end;
end;

procedure TUListButton.SetOrientation(const Value: TUOrientation);
begin
  if Value <> FOrientation then
    begin
      FOrientation := Value;
      UpdateRects;
      Repaint;
    end;
end;

procedure TUListButton.SetImageKind(const Value: TUImageKind);
begin
  if Value <> FImageKind then
    begin
      FImageKind := Value;
      Repaint;
    end;
end;

procedure TUListButton.SetImages(const Value: TCustomImageList);
begin
  if Value <> FImages then
    begin
      FImages.Assign(Value);
      Repaint;
    end;
end;

procedure TUListButton.SetImageIndex(const Value: Integer);
begin
  if Value <> FImageIndex then
    begin
      FImageIndex := Value;
      Repaint;
    end;
end;

procedure TUListButton.SetFontIcon(const Value: string);
begin
  if Value <> FFontIcon then
    begin
      FFontIcon := Value;
      Repaint;
    end;
end;

procedure TUListButton.SetImageSpace(const Value: Integer);
begin
  if Value <> FImageSpace then
    begin
      FImageSpace := Value;
      UpdateRects;
      Repaint;
    end;
end;

procedure TUListButton.SetSpacing(const Value: Integer);
begin
  if Value <> FSpacing then
    begin
      FSpacing := Value;
      UpdateRects;
      Repaint;
    end;
end;

procedure TUListButton.SetDetail(const Value: string);
begin
  if Value <> FDetail then
    begin
      FDetail := Value;
      UpdateRects;
      Repaint;
    end;
end;

procedure TUListButton.SetAllowSelected(const Value: Boolean);
begin
  if Value <> FAllowSelected then
    begin
      FAllowSelected := Value;
      UpdateColors;
      Repaint;
    end;
end;

//  CHILD EVENTS

procedure TUListButton.CustomBackColor_OnChange(Sender: TObject);
begin
  UpdateColors;
  Repaint;
end;

//  MAIN CLASS

constructor TUListButton.Create(aOwner: TComponent);
begin
  inherited;
  FButtonState := csNone;
  FImageKind := ikFontIcon;
  FImageIndex := -1;
  FFontIcon := '';
  FOrientation := oHorizontal;
  FImageSpace := 40;
  FSpacing := 10;
  FDetail := 'Detail';
  FAllowSelected := true;

  FIconFont := TFont.Create;
  IconFont.Name := 'Segoe MDL2 Assets';
  IconFont.Size := 12;

  FCustomBackColor := TUStateColorSet.Create;
  FCustomBackColor.OnChange := CustomBackColor_OnChange;
  FCustomBackColor.Assign(LISTBUTTON_BACK);

//  UpdateColors;
//  UpdateRects;

  //  Modify default props
  BevelOuter := bvNone;
  ParentBackground := false;
  TabStop := true;
end;

destructor TUListButton.Destroy;
begin
  FIconFont.Free;
  FCustomBackColor.Free;
  inherited;
end;

procedure TUListButton.Loaded;
begin
  inherited;
  UpdateColors;
  UpdateRects;
end;

//  CUSTOM METHODS

procedure TUListButton.Paint;
var 
  ImgX, ImgY: Integer;
begin
  //  Paint background
  Canvas.Brush.Style := bsSolid;
  Canvas.Brush.Handle := CreateSolidBrushWithAlpha(BackColor, 255);
  Canvas.FillRect(Rect(0, 0, Width, Height));
  Canvas.Brush.Style := bsClear;

  //  Draw image
  if ImageKind = ikFontIcon then
    begin
      //  Set up icon font
      Canvas.Font.Assign(IconFont);
      Canvas.Font.Color := TextColor;

      //  Draw font icon
      DrawTextRect(Canvas, taCenter, taVerticalCenter, ImgRect, FontIcon, false);      
    end
  else if (Images <> nil) and (ImageIndex >= 0) then
    begin
      GetCenterPos(ImgRect.Width, ImgRect.Height, ImgRect, ImgX, ImgY);
      Images.Draw(Canvas, ImgX, ImgY, ImageIndex, Enabled);
    end;
  
  //  Draw text
  Canvas.Font.Assign(Font);
  Canvas.Font.Color := TextColor;
  if Orientation = oHorizontal then
    DrawTextRect(Canvas, taLeftJustify, taVerticalCenter, TextRect, Caption, false)
  else 
    DrawTextRect(Canvas, taCenter, taAlignTop, TextRect, Caption, false);
    
  //  Detail
  Canvas.Font.Color := DetailColor;
  if Orientation = oHorizontal then
    DrawTextRect(Canvas, taRightJustify, taVerticalCenter, DetailRect, Detail, false)
  else 
    DrawTextRect(Canvas, taCenter, taAlignBottom, DetailRect, Detail, false);
end;

procedure TUListButton.Resize;
begin
  inherited;
  UpdateRects;
end;

procedure TUListButton.CreateWindowHandle(const Params: TCreateParams);
begin
  inherited;
  UpdateColors;
  UpdateRects;
end;

procedure TUListButton.ChangeScale(M, D: Integer{$IF CompilerVersion > 29}; isDpiChange: Boolean{$ENDIF});
begin
  inherited;
  FImageSpace := MulDiv(ImageSpace, M, D);
  FSpacing := MulDiv(Spacing, M, D);
  IconFont.Height := MulDiv(IconFont.Height, M, D);
  UpdateRects;
end;

//  MESSAGES

procedure TUListButton.WM_SetFocus(var Msg: TWMSetFocus);
begin
  if not Enabled then exit;
  UpdateColors;
  Repaint;
end;

procedure TUListButton.WM_KillFocus(var Msg: TWMKillFocus);
begin
  if not Enabled then exit;
  UpdateColors;
  Repaint;
end;

procedure TUListButton.WM_LButtonDblClk(var Msg: TWMLButtonDblClk);
begin
  if not Enabled then exit;
  ButtonState := csPress;
  inherited;
end;

procedure TUListButton.WM_LButtonDown(var Msg: TWMLButtonDown);
begin
  if not Enabled then exit;
  ButtonState := csPress;
  inherited;
end;

procedure TUListButton.WM_LButtonUp(var Msg: TWMLButtonUp);
begin
  if not Enabled then exit;
  ButtonState := csHover;   //  True, SetFocus does not call UpdateColors
  SetFocus;
  inherited;
end;

procedure TUListButton.CM_MouseEnter(var Msg: TMessage);
begin
  if not Enabled then exit;
  ButtonState := csHover;
  inherited;
end;

procedure TUListButton.CM_MouseLeave(var Msg: TMessage);
begin
  if not Enabled then exit;
  ButtonState := csNone;
  inherited;
end;

procedure TUListButton.CM_EnabledChanged(var Msg: TMessage);
begin
  UpdateColors;
  Repaint;
  inherited;
end;

procedure TUListButton.CM_TextChanged(var Msg: TMessage);
begin
  UpdateRects;
  Repaint;
  inherited;  
end;

end.