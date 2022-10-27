object Form3: TForm3
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Segment Options'
  ClientHeight = 256
  ClientWidth = 257
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 73
    Top = 202
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 6
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 159
    Top = 202
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 7
  end
  object RadioGroup1: TRadioGroup
    Left = 26
    Top = 16
    Width = 208
    Height = 53
    Caption = 'CODE Segment'
    Items.Strings = (
      'default'
      'set to :')
    TabOrder = 0
  end
  object Edit1: TEdit
    Left = 93
    Top = 46
    Width = 121
    Height = 21
    TabOrder = 1
  end
  object RadioGroup2: TRadioGroup
    Left = 26
    Top = 74
    Width = 208
    Height = 53
    Caption = 'DATA Segment'
    Items.Strings = (
      'default'
      'set to :')
    TabOrder = 2
  end
  object RadioGroup3: TRadioGroup
    Left = 26
    Top = 132
    Width = 208
    Height = 53
    Caption = 'BSS Segment'
    Items.Strings = (
      'default'
      'set to :')
    TabOrder = 4
  end
  object Edit2: TEdit
    Left = 93
    Top = 104
    Width = 121
    Height = 21
    TabOrder = 3
  end
  object Edit3: TEdit
    Left = 93
    Top = 162
    Width = 121
    Height = 21
    TabOrder = 5
  end
end
