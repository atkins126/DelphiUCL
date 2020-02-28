object Form85: TForm85
  Left = 0
  Top = 0
  Caption = 'Demo UCL'
  ClientHeight = 500
  ClientWidth = 700
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object UPanel1: TUPanel
    Left = 30
    Top = 110
    Width = 250
    Height = 100
    Hint = 'This is a hint'
    Caption = 'Demo panel'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    CustomBackColor.Enabled = False
    CustomBackColor.Color = clBlack
    CustomBackColor.LightColor = 15132390
    CustomBackColor.DarkColor = 2039583
  end
  object ComboBox1: TComboBox
    Left = 30
    Top = 50
    Width = 121
    Height = 21
    Style = csDropDownList
    ItemIndex = 0
    TabOrder = 1
    Text = 'System theme'
    OnSelect = ComboBox1Select
    Items.Strings = (
      'System theme'
      'Light theme'
      'Dark theme')
  end
  object Button1: TButton
    Left = 160
    Top = 50
    Width = 121
    Height = 41
    Caption = 'Reload'
    TabOrder = 2
    OnClick = Button1Click
  end
  object UCaptionBar1: TUCaptionBar
    Left = 0
    Top = 0
    Width = 700
    Caption = '   Caption bar'
    TabOrder = 3
    CustomBackColor.Enabled = False
    CustomBackColor.Color = clBlack
    CustomBackColor.LightColor = 15921906
    CustomBackColor.DarkColor = 2829099
  end
  object Button2: TButton
    Left = 320
    Top = 70
    Width = 201
    Height = 41
    Caption = 'Random progress bar'
    TabOrder = 4
    OnClick = Button2Click
  end
  object UProgressBar1: TUProgressBar
    Left = 320
    Top = 50
    Width = 200
    Caption = 'UProgressBar1'
    AniSet.AniKind = akOut
    AniSet.AniFunctionKind = afkQuartic
    AniSet.DelayStartTime = 0
    AniSet.Duration = 250
    AniSet.Step = 25
    CustomBackColor.Enabled = False
    CustomBackColor.Color = 15132390
    CustomBackColor.LightColor = 13421772
    CustomBackColor.DarkColor = 3355443
  end
end
