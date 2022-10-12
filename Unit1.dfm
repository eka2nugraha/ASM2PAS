object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'ASM2PAS'
  ClientHeight = 604
  ClientWidth = 1008
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  DesignSize = (
    1008
    604)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 256
    Top = 8
    Width = 143
    Height = 13
    Caption = 'by Ubur-Ubut (1444H/2002M)'
  end
  object Button1: TButton
    Left = 16
    Top = 2
    Width = 75
    Height = 25
    Caption = 'Open'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 9
    Top = 28
    Width = 450
    Height = 575
    Anchors = [akLeft, akTop, akBottom]
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 1
    WantReturns = False
    WordWrap = False
  end
  object Button2: TButton
    Left = 925
    Top = 2
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Save'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Memo2: TSynMemo
    Left = 465
    Top = 28
    Width = 540
    Height = 575
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    TabOrder = 3
    CodeFolding.GutterShapeSize = 11
    CodeFolding.CollapsedLineColor = clGrayText
    CodeFolding.FolderBarLinesColor = clGrayText
    CodeFolding.IndentGuidesColor = clGray
    CodeFolding.IndentGuides = True
    CodeFolding.ShowCollapsedLine = False
    CodeFolding.ShowHintMark = True
    UseCodeFolding = False
    Gutter.Font.Charset = DEFAULT_CHARSET
    Gutter.Font.Color = clWindowText
    Gutter.Font.Height = -11
    Gutter.Font.Name = 'Courier New'
    Gutter.Font.Style = []
    Gutter.RightOffset = 17
    Gutter.ShowLineNumbers = True
    Gutter.ShowModification = True
    Highlighter = SynPasSyn1
    OnGutterGetText = Memo2GutterGetText
    OnStatusChange = Memo2StatusChange
    FontSmoothing = fsmNone
  end
  object SynPasSyn1: TSynPasSyn
    Options.AutoDetectEnabled = False
    Options.AutoDetectLineLimit = 0
    Options.Visible = False
    Left = 446
    Top = 10
  end
end
