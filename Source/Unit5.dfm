object EditorOpt: TEditorOpt
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'ASM2PAS : Editor Options ...'
  ClientHeight = 509
  ClientWidth = 779
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object bOK: TButton
    Left = 560
    Top = 476
    Width = 75
    Height = 25
    Caption = 'OK'
    Enabled = False
    TabOrder = 1
    OnClick = bOKClick
  end
  object bCancel: TButton
    Left = 640
    Top = 476
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object PageControl1: TPageControl
    Left = 2
    Top = 2
    Width = 772
    Height = 462
    ActivePage = T1
    TabOrder = 0
    object T1: TTabSheet
      Caption = 'Editor Skin Color'
      object Label2: TLabel
        Left = 3
        Top = 126
        Width = 26
        Height = 13
        AutoSize = False
        Caption = 'Skin :'
      end
      object Label3: TLabel
        Left = 263
        Top = 3
        Width = 41
        Height = 13
        Caption = 'Sample :'
      end
      object Label4: TLabel
        Left = 220
        Top = 356
        Width = 63
        Height = 13
        AutoSize = False
        Caption = 'Gutter Text :'
      end
      object Label5: TLabel
        Left = 518
        Top = 356
        Width = 66
        Height = 13
        AutoSize = False
        Caption = 'Active Line :'
      end
      object Label6: TLabel
        Left = 212
        Top = 386
        Width = 69
        Height = 13
        AutoSize = False
        Caption = 'Modified Line :'
      end
      object Label1: TLabel
        Left = 247
        Top = 414
        Width = 31
        Height = 13
        Caption = 'Style :'
      end
      object Label9: TLabel
        Left = 518
        Top = 386
        Width = 59
        Height = 13
        AutoSize = False
        Caption = 'Saved Line :'
      end
      object Label12: TLabel
        Left = 2
        Top = 3
        Width = 121
        Height = 13
        Caption = 'Programming languages :'
      end
      object LB1: TListBox
        Left = 2
        Top = 143
        Width = 202
        Height = 261
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ItemHeight = 13
        ParentFont = False
        TabOrder = 1
        OnClick = LB1Click
      end
      object SynEdit1: TSynEdit
        Left = 210
        Top = 19
        Width = 553
        Height = 331
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
        Font.Quality = fqClearTypeNatural
        TabOrder = 3
        CodeFolding.GutterShapeSize = 11
        CodeFolding.CollapsedLineColor = clGrayText
        CodeFolding.FolderBarLinesColor = clGrayText
        CodeFolding.IndentGuidesColor = clGray
        CodeFolding.IndentGuides = True
        CodeFolding.ShowCollapsedLine = False
        CodeFolding.ShowHintMark = True
        UseCodeFolding = False
        Gutter.Color = clWindow
        Gutter.BorderColor = clSilver
        Gutter.Font.Charset = DEFAULT_CHARSET
        Gutter.Font.Color = clWindowText
        Gutter.Font.Height = -11
        Gutter.Font.Name = 'Courier New'
        Gutter.Font.Style = []
        Gutter.Font.Quality = fqClearTypeNatural
        Gutter.ModificationColorSaved = clWindow
        Gutter.ShowLineNumbers = True
        Gutter.ShowModification = True
        ReadOnly = True
        OnStatusChange = SynEdit1StatusChange
        FontSmoothing = fsmNone
      end
      object bAddColors: TButton
        Left = 2
        Top = 408
        Width = 60
        Height = 25
        Caption = 'Add Skin'
        TabOrder = 2
      end
      object clrB1: TColorBox
        Left = 284
        Top = 352
        Width = 145
        Height = 22
        Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeNone, cbCustomColor]
        TabOrder = 4
        OnClick = clrB1Click
        OnSelect = clrB1Select
      end
      object clrB2: TColorBox
        Left = 580
        Top = 352
        Width = 145
        Height = 22
        Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeNone, cbCustomColor]
        TabOrder = 5
        OnClick = clrB1Click
        OnSelect = clrB1Select
      end
      object clrB3: TColorBox
        Left = 284
        Top = 382
        Width = 145
        Height = 22
        TabOrder = 6
        OnClick = clrB1Click
        OnSelect = clrB1Select
      end
      object bPrvw: TButton
        Left = 500
        Top = 408
        Width = 54
        Height = 25
        Caption = 'Preview'
        Enabled = False
        TabOrder = 9
        OnClick = bPrvwClick
      end
      object CB1: TComboBox
        Left = 284
        Top = 410
        Width = 216
        Height = 22
        Style = csOwnerDrawFixed
        DropDownCount = 10
        Sorted = True
        TabOrder = 8
        OnClick = CB1Click
        OnDrawItem = CB1DrawItem
        OnSelect = CB1Select
      end
      object clrB4: TColorBox
        Left = 580
        Top = 382
        Width = 145
        Height = 22
        TabOrder = 7
        OnClick = clrB1Click
        OnSelect = clrB1Select
      end
      object LBPS1: TListBox
        Left = 2
        Top = 19
        Width = 202
        Height = 97
        ItemHeight = 13
        MultiSelect = True
        TabOrder = 0
        OnClick = LBPSLClick
      end
    end
    object T2: TTabSheet
      Caption = 'Theme Style'
      ImageIndex = 1
    end
    object T3: TTabSheet
      Caption = 'Syntax Colors'
      ImageIndex = 2
      object Label7: TLabel
        Left = 2
        Top = 8
        Width = 156
        Height = 13
        AutoSize = False
        Caption = 'Programming Syntax Language :'
      end
      object Label8: TLabel
        Left = 4
        Top = 131
        Width = 45
        Height = 13
        Caption = 'Element :'
      end
      object Label10: TLabel
        Left = 2
        Top = 282
        Width = 55
        Height = 13
        Caption = 'Fore color :'
      end
      object Label11: TLabel
        Left = 2
        Top = 314
        Width = 55
        Height = 13
        Caption = 'Back color :'
      end
      object LBPSL: TListBox
        Left = 3
        Top = 27
        Width = 202
        Height = 97
        ItemHeight = 13
        TabOrder = 0
        OnClick = LBPSLClick
      end
      object lbElement: TListBox
        Left = 2
        Top = 148
        Width = 202
        Height = 122
        ItemHeight = 13
        TabOrder = 1
        OnClick = lbElementClick
      end
      object SynEdit2: TSynEdit
        Left = 211
        Top = 27
        Width = 551
        Height = 404
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
        Font.Quality = fqClearTypeNatural
        TabOrder = 8
        CodeFolding.GutterShapeSize = 11
        CodeFolding.CollapsedLineColor = clGrayText
        CodeFolding.FolderBarLinesColor = clGrayText
        CodeFolding.IndentGuidesColor = clGray
        CodeFolding.IndentGuides = True
        CodeFolding.ShowCollapsedLine = False
        CodeFolding.ShowHintMark = True
        UseCodeFolding = False
        Gutter.Color = clWindow
        Gutter.BorderColor = clSilver
        Gutter.Font.Charset = DEFAULT_CHARSET
        Gutter.Font.Color = clWindowText
        Gutter.Font.Height = -11
        Gutter.Font.Name = 'Courier New'
        Gutter.Font.Style = []
        Gutter.Font.Quality = fqClearTypeNatural
        Gutter.ModificationColorSaved = clWindow
        Gutter.ShowLineNumbers = True
        Gutter.ShowModification = True
        ReadOnly = True
        OnStatusChange = SynEdit1StatusChange
        FontSmoothing = fsmNone
      end
      object cbFg: TColorBox
        Left = 60
        Top = 278
        Width = 145
        Height = 22
        Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeNone, cbCustomColor]
        TabOrder = 2
        OnClick = cbFgSelect
        OnSelect = cbFgSelect
      end
      object cbBg: TColorBox
        Left = 60
        Top = 310
        Width = 145
        Height = 22
        Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeNone, cbCustomColor]
        TabOrder = 3
        OnClick = cbFgSelect
        OnSelect = cbFgSelect
      end
      object GroupBox1: TGroupBox
        Left = 2
        Top = 338
        Width = 204
        Height = 56
        Caption = 'Text attributes :'
        TabOrder = 4
        object ctabold: TCheckBox
          Left = 8
          Top = 14
          Width = 97
          Height = 17
          Caption = 'Bold'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          OnClick = ctaboldClick
        end
        object ctaul: TCheckBox
          Left = 112
          Top = 14
          Width = 97
          Height = 17
          Caption = 'Underline'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsUnderline]
          ParentFont = False
          TabOrder = 1
          OnClick = ctaboldClick
        end
        object ctaitalic: TCheckBox
          Left = 8
          Top = 32
          Width = 97
          Height = 17
          Caption = 'Italic'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsItalic]
          ParentFont = False
          TabOrder = 2
          OnClick = ctaboldClick
        end
        object ctastrike: TCheckBox
          Left = 112
          Top = 32
          Width = 97
          Height = 17
          Caption = 'Strike out'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsStrikeOut]
          ParentFont = False
          TabOrder = 3
          OnClick = ctaboldClick
        end
      end
      object bResetElm: TButton
        Left = 4
        Top = 404
        Width = 90
        Height = 25
        Caption = 'Reset Element'
        TabOrder = 5
        OnClick = bResetElmClick
      end
      object bResetallElm: TButton
        Left = 100
        Top = 404
        Width = 109
        Height = 25
        Caption = 'Reset all Elements'
        TabOrder = 6
        OnClick = bResetElmClick
      end
      object Button3: TButton
        Left = 164
        Top = 2
        Width = 149
        Height = 25
        Caption = 'Reset all Language Colors'
        TabOrder = 7
        OnClick = Button3Click
      end
    end
  end
end
