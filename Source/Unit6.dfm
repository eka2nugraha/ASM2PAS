object Form6: TForm6
  Left = 0
  Top = 0
  Caption = 'DELIST the Predator : Preview VCL Style'
  ClientHeight = 382
  ClientWidth = 616
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MM
  OldCreateOrder = False
  Position = poDesigned
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 22
    Width = 456
    Height = 360
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'TabSheet'
      object SynEdit: TSynEdit
        Left = 0
        Top = 0
        Width = 448
        Height = 332
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Consolas'
        Font.Style = []
        Font.Quality = fqClearTypeNatural
        TabOrder = 0
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
        Gutter.Font.Name = 'Consolas'
        Gutter.Font.Style = []
        Gutter.ModificationColorSaved = clWindow
        Gutter.ShowLineNumbers = True
        Gutter.ShowModification = True
        InsertCaret = ctVerticalLine2
        FontSmoothing = fsmNone
      end
    end
  end
  object Panel1: TPanel
    Left = 456
    Top = 22
    Width = 160
    Height = 360
    Align = alRight
    Caption = 'Panel1'
    TabOrder = 1
    object TreeView1: TTreeView
      Left = 1
      Top = 23
      Width = 158
      Height = 336
      Align = alClient
      HideSelection = False
      Indent = 19
      MultiSelect = True
      MultiSelectStyle = [msControlSelect, msShiftSelect]
      TabOrder = 0
      Items.NodeData = {
        03030000002A0000000000000000000000FFFFFFFFFFFFFFFF00000000000000
        0000000000010646006F006C006400650072002A0000000000000000000000FF
        FFFFFFFFFFFFFF000000000000000004000000010646006F006C006400650072
        00340000000000000000000000FFFFFFFFFFFFFFFF0000000000000000020000
        00010B6300680069006C00640046006F006C0064006500720034000000000000
        0000000000FFFFFFFFFFFFFFFF000000000000000000000000010B6300680069
        006C00640046006F006C00640065007200280000000000000000000000FFFFFF
        FFFFFFFFFF0000000000000000000000000105460069006C0065003100280000
        000000000000000000FFFFFFFFFFFFFFFF000000000000000000000000010546
        0069006C0065003100280000000000000000000000FFFFFFFFFFFFFFFF000000
        0000000000000000000105460069006C00650032002800000000000000000000
        00FFFFFFFFFFFFFFFF0000000000000000000000000105460069006C00650033
        00280000000000000000000000FFFFFFFFFFFFFFFF0000000000000000000000
        000105460069006C0065003100}
    end
    object ToolBar1: TToolBar
      Left = 1
      Top = 1
      Width = 158
      Height = 22
      Caption = 'ToolBar1'
      TabOrder = 1
      object ToolButton1: TToolButton
        Left = 0
        Top = 0
        Caption = 'ToolButton1'
        ImageIndex = 0
      end
      object ToolButton2: TToolButton
        Left = 23
        Top = 0
        Caption = 'ToolButton2'
        ImageIndex = 1
      end
    end
  end
  object ToolBar2: TToolBar
    Left = 0
    Top = 0
    Width = 616
    Height = 22
    Caption = 'ToolBar2'
    Images = Form1.ImageList1
    TabOrder = 2
    object ToolButton4: TToolButton
      Left = 0
      Top = 0
      ImageIndex = 7
    end
    object ToolButton5: TToolButton
      Left = 23
      Top = 0
      ImageIndex = 8
    end
  end
  object MM: TMainMenu
    Left = 271
    Top = 128
    object File1: TMenuItem
      Caption = 'File'
      object eXit1: TMenuItem
        Caption = 'eXit'
        OnClick = eXit1Click
      end
    end
  end
end
