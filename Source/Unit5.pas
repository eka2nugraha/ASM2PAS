unit Unit5;
{$H+,O+,W-,C-}
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, vcl.themes, vcl.Styles, SynEdit,
  Vcl.ComCtrls, SynEditHighlighter, SynEditCodeFolding, SynHighlighterPas,
  Vcl.ExtCtrls, Vcl.Imaging.pngimage;

type
 TThemeType = (ttLight, ttDark);
 ThemeAttrs = record
   name:string;
   tt:TThemeType;
 end;

const
    LD: array[TThemeType] of string= ('Light','Dark');
    ArThemeAttrs : array[0..51-1] of ThemeAttrs = (


    (name:'Glossy'                  ; tt: ttDark),
    (name:'Iceberg Classico'        ; tt: ttLight),
    (name:'Lavender Classico'       ; tt: ttLight),
    (name:'Metropolis UI Blue'     ; tt: ttLight),
    (name:'Metropolis UI Dark'     ; tt: ttDark),
    (name:'Metropolis UI Green'     ; tt: ttLight),
    (name:'Silver'                 ; tt: ttLight),
    (name:'Sky'                     ; tt: ttLight),
    (name:'Windows'                 ; tt: ttLight),
    (name:'Aqua Light Slate'        ; tt: ttLight),
    (name:'Copper'                  ; tt: ttLight),
    (name:'CopperDark'              ; tt: ttDark),
    (name:'Coral'                   ; tt: ttLight),
    (name:'Diamond'                 ; tt: ttLight),
    (name:'Emerald'                 ; tt: ttLight),
    (name:'Glow'                    ; tt: ttDark),
    (name:'Slate Classico'          ; tt: ttLight),
    (name:'Sterling'                ; tt: ttLight),
    (name:'Tablet Dark'             ; tt: ttDark),
    (name:'Tablet Light'            ; tt: ttLight),
    (name:'Windows10'               ; tt: ttLight),
    (name:'Windows10 Blue'          ; tt: ttDark),
    (name:'Windows10 Dark'          ; tt: ttDark),
    (name:'Windows10 Green'         ; tt: ttDark),
    (name:'Windows10 Purple'        ; tt: ttDark),
    (name:'Windows10 SlateGray'     ; tt: ttDark),
    (name:'Windows10 BlackPearl'    ; tt: ttDark),
    (name:'Windows10 Blue Whale'    ; tt: ttDark),
    (name:'Windows10 Clear Day'     ; tt: ttLight),
    (name:'Windows10 Malibu'        ; tt: ttLight),
    (name:'Flat UI Light'           ; tt: ttLight),
    (name:'Windows11 Modern Light'  ; tt: ttLight),
    (name:'Windows11 Modern Dark'   ; tt: ttDark),
    (name:'Material Oxford Blue'    ; tt: ttDark),
    (name:'Material Oxford Blue SE' ; tt: ttDark),
    (name:'Puerto Rico'             ; tt: ttLight),
    (name:'Wedgewood Light'         ; tt: ttLight),

    //Non High DPI Themes
    (name:'Amakrits'                ; tt: ttDark),
    (name:'Amethyst Kamri'          ; tt: ttLight),
    (name:'Auric'                   ; tt: ttDark),
    (name:'Carbon'                  ; tt: ttDark),
    (name:'Cyan Dusk'               ; tt: ttLight),
    (name:'Charcoal Dark Slate'     ; tt: ttDark),
    (name:'Luna'                    ; tt: ttLight),
    (name:'Material Oxford Blue'    ; tt: ttDark),
    (name:'Onyx Blue'               ; tt: ttDark),
    (name:'Ruby Graphite'           ; tt: ttDark),
    (name:'Sapphire Kamri'          ; tt: ttLight),
    (name:'Smokey Quartz Kamri'     ; tt: ttLight),
    (name:'Turquoise Gray'          ; tt: ttLight),
    (name:'Windows10 Blue Whale LE' ; tt: ttDark));
type
  TEditorOpt = class(TForm)
    bOK: TButton;
    bCancel: TButton;
    LB1: TListBox;
    SynEdit1: TSynEdit;
    bAddColors: TButton;
    Label2: TLabel;
    Label3: TLabel;
    PageControl1: TPageControl;
    T1: TTabSheet;
    T2: TTabSheet;
    T3: TTabSheet;
    Label4: TLabel;
    Label5: TLabel;
    clrB1: TColorBox;
    clrB2: TColorBox;
    Label6: TLabel;
    clrB3: TColorBox;
    LBPSL: TListBox;
    Label7: TLabel;
    Label8: TLabel;
    lbElement: TListBox;
    SynEdit2: TSynEdit;
    Label10: TLabel;
    cbFg: TColorBox;
    cbBg: TColorBox;
    GroupBox1: TGroupBox;
    ctabold: TCheckBox;
    ctaul: TCheckBox;
    ctaitalic: TCheckBox;
    ctastrike: TCheckBox;
    Label11: TLabel;
    bResetElm: TButton;
    bResetallElm: TButton;
    Button3: TButton;
    bPrvw: TButton;
    CB1: TComboBox;
    Label1: TLabel;
    Label9: TLabel;
    clrB4: TColorBox;
    LBPS1: TListBox;
    Label12: TLabel;
    procedure bOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CB1Click(Sender: TObject);
    procedure CB1DrawItem(Control: TWinControl; Index: Integer; Rect: TRect;
      State: TOwnerDrawState);
    procedure LB1Click(Sender: TObject);
    procedure bPrvwClick(Sender: TObject);
    procedure CB1Select(Sender: TObject);
    procedure SynEdit1StatusChange(Sender: TObject; Changes: TSynStatusChanges);
    procedure clrB1Select(Sender: TObject);
    procedure LBPSLClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure lbElementClick(Sender: TObject);
    procedure clrB1Click(Sender: TObject);
    procedure cbFgSelect(Sender: TObject);
    procedure ctaboldClick(Sender: TObject);
    procedure bResetElmClick(Sender: TObject);
  private
    { Private declarations }
    procedure ChEdClr;
  public
    Berubah : integer;
    fOldCaretY : integer;
//    fHLs : TStringList;
    { Public declarations }
  end;

implementation

{$R *.dfm}
uses Unit1, System.RTTI, System.TypInfo, System.IniFiles,
System.UITypes, Unit6;

procedure TEditorOpt.bOKClick(Sender: TObject);
var
  s,DirName,FileName : string;
  i,j : integer;
  HL : TStringList;
  O,O2  : TSynCustomHighlighter;
begin
  DirName := getdirname;
  if (berubah and 33 <> 0) then
  begin
    HL := GetCDM.Highlighters;
    FileName := Dirname+'HL\';
    for j := 0 to HL.Count - 1 do
    begin
        O := TSynCustomHighlighter(HL.Objects[j]);
        O.BeginUpdate;
        for i := 0 to HL.Count-1 do
        begin
             O2 := TSynCustomHighlighter(LBPSL.items.Objects[i]);
             if O2.ClassType=O.ClassType then
             begin
                  O.Assign(O2);
                  break;
             end;
        end;
        O.SaveToFile(FileName + O.Name+'.HL');
        O.EndUpdate;
    end;
  end;
  FileName := GetIniName;
    i := clrB1.ItemIndex;
    if i >= 0 then
    begin
      if i = 0 then
        s := ColortoString(clrB1.Colors[0])
      else
        s := clrB1.ColorNames[i];
    end;
    WritePrivateProfileString('Editor', 'GutterText', pointer(s), pointer(FileName));
    getCDM.txtEditorGutterTextColor := s;
    GetCDM.EditorGutterTextColor := clrB1.Colors[i];
    i := clrB2.ItemIndex;
    if i >= 0 then
    begin
      if i = 0 then
        s := ColortoString(clrB2.Colors[0])
      else
        s := clrB1.ColorNames[i];
    end;
    WritePrivateProfileString('Editor', 'ActiveLineColor', pointer(s), pointer(FileName));
    getCDM.txtEditorActiveLineColor := s;
    GetCDM.EditorActiveLineColor := clrB2.Colors[i];
    i := clrB3.ItemIndex;
    if i >= 0 then
    begin
      if i = 0 then
        s := ColortoString(clrB3.Colors[0])
      else
        s := clrB3.ColorNames[i];
    end;
    WritePrivateProfileString('Editor', 'ModifiedLine', pointer(s), pointer(FileName));
    getCDM.txtEditorModifiedColor := s;
    GetCDM.EditorModifiedColor := clrB3.Colors[i];
    i := clrB4.ItemIndex;
    if i >= 0 then
    begin
      if i = 0 then
        s := ColortoString(clrB4.Colors[0])
      else
        s := clrB4.ColorNames[i];
    end;
    WritePrivateProfileString('Editor', 'SavedLine', pointer(s), pointer(FileName));
    getCDM.txtEditorSavedColor := s;
    GetCDM.EditorSavedColor := clrB4.Colors[i];

    if Sender <> nil then ModalResult := mrOK;
end;
type
 tstream2 = class(tstream)
   function Read(var Buffer; Count: Longint): Longint; override;
   function Write(const Buffer; Count: Longint): Longint; override;
   function GetSize: Int64; override;
   function Seek(Offset: Longint; Origin: Word): Longint; override;
 public
   s:ansistring;
 end;

function TStream2.Seek(Offset: Longint; Origin: Word): Longint;
begin
     result := Offset;
end;
function TStream2.GetSize: Int64;
begin
  Result := Length(s);
end;

function TStream2.Read(var Buffer; Count: Longint): Longint;
begin
  move(pointer(s)^, Buffer, Count);
  Result := Length(s);
end;

function TStream2.Write(const Buffer; Count: Longint): Longint;
begin
  Result := Count;
end;

procedure TEditorOpt.bPrvwClick(Sender: TObject);
var
 s : string;
 i : integer;
 tostream:tstream2;
 c: TColor;
 t: Tform6;
 HL:TSynCustomHighLighter;
begin
 i := CB1.ItemIndex;
 if i < 0 then exit;
 s := CB1.Items[i];
 t := TForm6.create(self);
 with t do
 begin
    SynEdit.BeginUpdate;
    Left := Self.Left+20;
    Top := Self.Top+90;
    StyleName := S;
    HL := SynEdit1.Highlighter;
    SynEdit.Highlighter := HL;
    s := HL.SampleSource;
    SynEdit.usecodefolding := true;
    @SynEdit.OnGutterGetText := @TForm1.GutterGetText;
    SynEdit.OnStatusChange := SynEdit1StatusChange;

    c := getSysColor(clWindow, t);
    SynEdit.Color := c;
    SynEdit.Gutter.Color := c;
//    SynEdit.Gutter.ModificationColorSaved := c;
    SynEdit.Font.Color := getSysColor(clWindowText, t);

    SynEdit.Gutter.Font.Color := SynEdit1.Gutter.Font.Color;
    SynEdit.ActiveLineColor := SynEdit1.ActiveLineColor;
    SynEdit.Gutter.ModificationColorModified := SynEdit1.Gutter.ModificationColorModified;
    SynEdit.Gutter.ModificationColorSaved := SynEdit1.Gutter.ModificationColorSaved;
    tostream := tstream2.create;
    tostream.s := s;
    SynEdit.LockUndo;
    SynEdit.Lines.LoadFromStream(tostream);
    SynEdit.UnlockUndo;
    tostream.free;
    s := SynEdit.Lines[5];
    SynEdit.Lines[5] := s;
    SynEdit.MarkModifiedLinesAsSaved;
    s := SynEdit.Lines[11];
    SynEdit.Lines[11] := s;
    SynEdit.EndUpdate;
    ShowModal;
    Free;
 end;
end;

type
  TSynHClass = class of TSynCustomHighlighter;


procedure TEditorOpt.bResetElmClick(Sender: TObject);
var
 o,o2 : TSynCustomHighlighter;
 t,t2 : TSynHighlighterAttributes;
 i : integer;
begin
 o := TSynCustomHighlighter(LBPSL.items.Objects[LBPSL.ItemIndex]);
 o2 := TSynHClass(o.ClassType).Create(nil);

 if sender=bResetElm then
 begin
    i := integer(lbElement.Items.Objects[lbElement.ItemIndex]);
    o.Attribute[i].Assign(o2.Attribute[i]);
 end
 else
 for i := 0 to o.AttrCount-1 do
    o.Attribute[i].Assign(o2.Attribute[i]);
 o2.Free;
 lbElementClick(lbElement);
 Berubah := Berubah or 32;
 bOK.Enabled := true;
end;

procedure TEditorOpt.Button3Click(Sender: TObject);
var
 i: integer;
 HL: tstrings;
 O, O2: TSynCustomHighlighter;
begin
   HL := LBPSL.Items;
   for i  := 0 to HL.Count-1 do
   begin
     o := TSynCustomHighlighter(HL.Objects[i]);
     o2 := TSynHClass(o.ClassType).Create(nil);
     HL.Objects[i] := o2;
     o.Free;
   end;
   LBPSL.OnClick(LBPSL);
   Berubah := Berubah + 32;
   bOK.Enabled := true;
end;

procedure TEditorOpt.ChEdClr;
var
 c : TColor;
begin
 c := GetSysColor(clWindow, SynEdit1);
 SynEdit1.Color := c;
 SynEdit1.Gutter.Color := c;
// SynEdit1.Gutter.ModificationColorSaved := c;
 SynEdit2.Color := c;
 SynEdit2.Gutter.Color := c;
// SynEdit2.Gutter.ModificationColorSaved := c;
 c := getSysColor(clWindowText, SynEdit1);
 SynEdit1.Font.Color := c;
 SynEdit2.Font.Color := c;

end;

procedure TEditorOpt.CB1Click(Sender: TObject);
var
 s : string;
 i : integer;
begin
 i := TCombobox(Sender).ItemIndex;
 if i < 0 then exit;
 s := TCombobox(Sender).Items[i];
 try
   bPrvw.StyleName := s;
   SynEdit1.StyleName := s;
   SynEdit2.StyleName := s;
   clrB1.StyleName := s;
   clrB2.StyleName := s;
   clrB3.StyleName := s;
   clrB4.StyleName := s;
//   LB1.StyleName := s;
//   SynEdit1.StyleName := s;
 except
  on Exception do ;
 end;
 ChEdClr;
 berubah := berubah or 64;
 bOK.Enabled := true;
end;


procedure TEditorOpt.CB1DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
s: string;
j: NativeInt;
a: string;
begin
    if Index <0 then exit;
    s := TComboBox(Control).Items[Index];
    a := '-';
    if s = '' then
    begin
       s := ' No Style';
    end
    else
    for j := 0 to 51-1 do
      if ArThemeAttrs[j].name=s then
      begin
          a := LD[ArThemeAttrs[j].tt];
          break;
      end;
    TComboBox(Control).Canvas.FillRect(Rect);
    TComboBox(Control).Canvas.TextOut(Rect.Left + 1, Rect.Top + 1, s);
    TComboBox(Control).Canvas.TextOut(Rect.Left + 160, Rect.Top + 1, a);
end;

procedure TEditorOpt.CB1Select(Sender: TObject);
var
 i : integer;
 f,s: string;
begin
  i := TComboBox(Sender).ItemIndex;
  if i < 0 then exit;
  s := TComboBox(Sender).Items[i];
  f := TStyleManager.ActiveStyle.Name;
  bPrvw.Enabled := s<>f;
end;

procedure TEditorOpt.clrB1Select(Sender: TObject);
var
 c : TColor;
 a : byte;
begin
  c := tcolorbox(sender).Selected;
  if Sender=clrB1 then
  begin
   SynEdit1.Gutter.Font.Color := c;
   a := 2;
  end
  else
  if Sender=clrB2 then
  begin
     SynEdit1.ActiveLineColor := c;
     a := 4;
  end
  else
  if Sender=clrB3 then
  begin
     SynEdit1.Gutter.ModificationColorModified := c;
     a := 8;
  end
  else
  begin
     SynEdit1.Gutter.ModificationColorSaved := c;
     a := 16;
  end;
  berubah := berubah or a;
  bOK.Enabled := true;
end;

procedure TEditorOpt.ctaboldClick(Sender: TObject);
var
 b : boolean;
 a : TFontStyle;
 o : TObject;
 t : TSynHighlighterAttributes;
 c : tcolor;
begin
  if Sender=ctaBold then
  begin
     a := fsBold;
  end else
  if Sender= ctaItalic then
  begin
     a := fsItalic;
  end  else
  if Sender=ctaUl then
  begin
     a := fsUnderline;
  end else
  begin
     a := fsStrikeOut;
  end;
  o := LBPSL.items.Objects[LBPSL.ItemIndex];
  t := TSynCustomHighlighter(o).Attribute[integer(lbElement.Items.Objects[lbElement.ItemIndex])];
  b := Tcheckbox(Sender).Checked;
  if b then
     t.style := t.style + [a]
  else
     t.style := t.style - [a];

  Berubah := Berubah or 32;
  bOK.Enabled := true;
end;

procedure TEditorOpt.cbFgSelect(Sender: TObject);
var
 o : TObject;
 t : TSynHighlighterAttributes;
 c : TColor;
begin
  c := tcolorbox(sender).Selected;
  o := LBPSL.items.Objects[LBPSL.ItemIndex];
  t := TSynCustomHighlighter(o).Attribute[integer(lbElement.Items.Objects[lbElement.ItemIndex])];
  if Sender=cbFG then
    t.Foreground := c
  else
    t.Background := c;
  Berubah := Berubah or 32;
  bOK.Enabled := true;
end;

procedure TEditorOpt.clrB1Click(Sender: TObject);
begin
  clrB1Select(Sender);
end;


procedure TEditorOpt.FormCreate(Sender: TObject);
var
 t: thandle;
 v: TWIN32FindDataW;
 s: string;
 r: trect;
 i: integer;
 j: NativeInt;
 tostream:tstream2;
 c: TColor;
 HL: tstringlist;
 O, O2: TSynCustomHighlighter;
begin
  cb1.AddItem('', nil);
  try
    for i := 0 to High(TStyleManager.StyleNames) do
    begin
       s := TStyleManager.StyleNames[i];
       cb1.AddItem(s, nil);
      end;
    s := TStyleManager.ActiveStyle.Name;
    CB1.ItemIndex := CB1.items.IndexOf(s);
  except
  end;
//  Application.openforms[0].
//  cb1.Enabled := getMainForm.MDIChildCount = 0;
  s := paramstr(0);
  s := extractfilepath(s)+'HL\*.ini';
   t := findfirstFileW( pointer(s), v);
   if t <> INVALID_HANDLE_VALUE then
   repeat
     s := v.cFileName;
     setlength(s, length(s)-4);
     LB1.Items.Add(s);
   until not findnextfilew(t, v);

   s := getCDM.txtEditorGutterTextColor;
   j := clrb1.items.IndexOf(s);
   if j < 0 then
   begin
      clrb1.items.Objects[0] := TObject(getCDM.EditorGutterTextColor);
      j := 0;
   end;
   clrb1.ItemIndex := j;

   s := getCDM.txtEditorActiveLineColor;
   j := clrb2.items.IndexOf(s);
   if j < 0 then
   begin
      clrb2.items.Objects[0] := TObject(GetCDM.EditorActiveLineColor);
      j := 0;
   end;
   clrb2.ItemIndex := j;

   s := getCDM.txtEditorModifiedColor;
   j := clrb3.items.IndexOf(s);
   if j < 0 then
   begin
      clrb3.items.Objects[0] := TObject(GetCDM.EditorModifiedColor);
      j := 0;
   end;
   clrb3.ItemIndex := j;

   s := getCDM.txtEditorSavedColor;
   j := clrb4.items.IndexOf(s);
   if j < 0 then
   begin
      clrb4.items.Objects[0] := TObject(GetCDM.EditorSavedColor);
      j := 0;
   end;
   clrb4.ItemIndex := j;

   SynEdit1.BeginUpdate;
   SynEdit2.BeginUpdate;
   HL := GetCDM.Highlighters;
   for i  := 0 to HL.Count-1 do
   begin
       o := TSynCustomHighlighter(HL.Objects[i]);
       s := o.FriendlyLanguageName;
       o2 := TSynHClass(o.ClassType).Create(nil);
       o2.Assign(o);
       LBPSL.AddItem(s, o2);
       LBPS1.AddItem(s, o2);
       if o2.ClassType=TSynPasSyn then
        SynEdit1.Highlighter := o2;
   end;
   s := SynEdit1.Highlighter.SampleSource;
   tostream := tstream2.create;
   tostream.s := s;
   SynEdit1.LockUndo;
   SynEdit1.Lines.LoadFromStream(tostream);
   SynEdit1.UnlockUndo;
   tostream.Free;
   @SynEdit1.OnGutterGetText := @TForm1.GutterGetText;
   @SynEdit2.OnGutterGetText := @TForm1.GutterGetText;

   ChEdClr;

   c := getCDM.EditorGutterTextColor;
   SynEdit1.Gutter.Font.Color := c;
   SynEdit2.Gutter.Font.Color := c;

   c := getCDM.EditorModifiedColor;
   SynEdit1.Gutter.ModificationColorModified := c;
   SynEdit2.Gutter.ModificationColorModified := c;

   c := getCDM.EditorSavedColor;
   SynEdit1.Gutter.ModificationColorSaved := c;
   SynEdit2.Gutter.ModificationColorSaved := c;

   c := GetCDM.EditorActiveLineColor;
   SynEdit1.ActiveLineColor := c;
   SynEdit2.ActiveLineColor := c;


   SynEdit1.UseCodeFolding := true;
   s := SynEdit1.Lines[5];
   SynEdit1.Lines[5] := s;
   s := SynEdit1.Lines[6];
   SynEdit1.Lines[6] := s;
   SynEdit1.MarkModifiedLinesAsSaved;
   s := SynEdit1.Lines[10];
   SynEdit1.Lines[10] := s;
   s := SynEdit1.Lines[11];
   SynEdit1.Lines[11] := s;
   SynEdit1.GotoLineAndCenter(12);

   SynEdit1.EndUpdate;
   SynEdit2.EndUpdate;

   LBPSL.itemindex := 0;
   LBPSL.OnClick(LBPSL);
end;

procedure TEditorOpt.FormDestroy(Sender: TObject);
var
 i:integer;
begin
  for i := 0 to LBPSL.Items.Count-1 do
  LBPSL.Items.Objects[i].Free;
end;

procedure TEditorOpt.LB1Click(Sender: TObject);
var
//  AppStorage : TJvAppIniFileStorage;
  FileName : string;
  s, SectionName : string;
  i,j : integer;
  c : tColor;
  O: TSynCustomHighlighter;
begin
    i := LB1.ItemIndex;
    if i < 0 then exit;
    FileName := paramstr(0);
    FileName := extractfilepath(FileName);
    FileName := FileName+'HL\'+LB1.items[i] + '.ini';
//    AppStorage := TJvAppIniFileStorage.Create(nil);
    try
{      AppStorage.FlushOnDestroy := False;
      AppStorage.Location := flCustom;
      AppStorage.FileName := FileName;
}
      SynEdit1.Highlighter.BeginUpdate;
//      try
        for j := 0 to LBPSL.Items.Count-1 do
        begin
            O := TSynCustomHighlighter(LBPSL.Items.Objects[j]);
            SectionName := 'HL\'+O.FriendlyLanguageName;
//            AppStorage.ReadPersistent(SectionName, O, true, false);
        end;
      finally
        SynEdit1.Highlighter.EndUpdate;
      end;
//    finally
//      AppStorage.Free;
//    end;

    Setlength(SectionName, 256);
    SetLength(SectionName, GetPrivateProfileString('HL\ActiveLine', 'ActiveLineColor', '-', pointer(SectionName), 255, pointer(FileName)));
    if SectionName <> '-' then
    begin
        s := SectionName;
        if SectionName='clNone' then
        SectionName := 'clWindow';
      c := StringToColor(SectionName);
      SynEdit1.ActiveLineColor := c;
      SynEdit2.ActiveLineColor := c;
      i := clrb2.items.IndexOf(s);
      if i < 0 then
      begin
        clrb2.items.Objects[0] := TObject(c);
        i := 0;
      end;
      clrb2.ItemIndex := i;
      clrb2.Update;
    end;

    Berubah := Berubah or 1;
    bOK.Enabled := true;
end;


procedure TEditorOpt.SynEdit1StatusChange(Sender: TObject; Changes: TSynStatusChanges);
var
 newCaretY : integer;
begin
  if (scCaretY in Changes)then
  begin
    NewCaretY := TSynEdit(Sender).CaretY;
    TSynEdit(Sender).InvalidateGutterLine(fOldCaretY);
    TSynEdit(Sender).InvalidateGutterLine(NewCaretY);
    fOldCaretY := NewCaretY;
  end;

end;

function GetValueRTTI(path:string; obj:TPersistent):tObject;
var
ctx : TRttiContext;
lt  : TRttiType;
lp  : TRttiProperty;
j   : integer;
s   : string;
V   : TObject;
O   : TObject;
begin
//    result :=  GetObjectProp(obj, path);
//    X := GetOrdProp(O, 'X');

    ctx := TRttiContext.create;
    lt  := ctx.GetType(obj.ClassType);
    j := 0;
    for lp in lt.GetProperties do
    begin
      inc(j);
      s := lp.Name;
    end;
    ctx.Free;
end;

procedure TEditorOpt.lbElementClick(Sender: TObject);
var
s : string;
i : integer;
o : TObject;
t : TSynHighlighterAttributes;
c : tcolor;
st: TFontStyles;
// wSynAttr : TSynHighlighterAttributes;

begin
    o := LBPSL.items.Objects[LBPSL.ItemIndex];
    t := TSynCustomHighlighter(o).Attribute[integer(lbElement.Items.Objects[lbElement.ItemIndex])];
    s := lbElement.Items.Strings[lbElement.ItemIndex];

    c := t.Foreground;
    s := ColortoString(c);
    i := cbFg.items.IndexOf(s);
    if i < 0 then
    begin
      cbFg.items.Objects[0] := TObject(c);
      i := 0;
    end;
    cbFg.ItemIndex := i;

    c := t.Background;
    s := ColortoString(c);
    i := cbBg.items.IndexOf(s);
    if i < 0 then
    begin
      cbBg.items.Objects[0] := TObject(c);
      i := 0;
    end;
    cbBg.ItemIndex := i;


    st := t.Style;
    ctaBold.Checked := fsBold in st;
    ctaitalic.Checked := fsItalic in st;
    ctaUl.Checked := fsUnderline in st;
    ctaStrike.Checked :=  fsStrikeOut in st;
end;

procedure TEditorOpt.LBPSLClick(Sender: TObject);
var
ctx : TRttiContext;
lt  : TRttiType;
lp  : TRttiProperty;
j   : integer;
s,e   : string;
V   : TObject;
o   : TSynCustomHighlighter;
HA  : TSynHighlighterAttributes;
tostream : tstream2;
begin
   o := TSynCustomHighlighter(LBPSL.items.Objects[LBPSL.ItemIndex]);

   SynEdit2.Highlighter := o;
   s := o.SampleSource;
   tostream := tstream2.create;
   tostream.s := s;
   SynEdit2.LockUndo;
   SynEdit2.Lines.LoadFromStream(tostream);
   SynEdit2.UnlockUndo;
   tostream.Free;
   SynEdit2.UseCodeFolding := true;
//   s := SynEdit2.Lines[11];
//   SynEdit2.Lines[11] := s;

   lbElement.ItemIndex := -1;
   lbElement.Clear;
   for j := 0 to o.AttrCount-1 do
   begin
       s := o.Attribute[j].FriendlyName;
       lbElement.AddItem(s, TObject(j));
   end;

{
    ctx := TRttiContext.create;
    lt  := ctx.GetType(o.ClassType);


    j := 0;
    for lp in lt.GetProperties do
    begin
      inc(j);
      s := lp.Name;
      e := copy(s, length(s)-4, 5);
      if e = 'Attri' then
      begin
         ha := lp.GetValue(TSynHighlighterAttributes).Astype<TSynHighlighterAttributes>;
         lbElement.AddItem(s, nil);
      end;
    end;
    ctx.Free;
}
    lbElement.ItemIndex := 0;
    lbElementClick(lbElement);
end;


end.
