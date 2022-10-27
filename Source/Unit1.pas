unit Unit1;
{$H+,O+,W-,C-}
interface

uses
  Winapi.Windows, Winapi.Messages, System.AnsiStrings, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  System.IniFiles, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, SynEdit, SynMemo,
  SynEditHighlighter, SynHighlighterAsm, SynEditCodeFolding, SynHighlighterPas,
  AnsiStringList, Vcl.ActnList, System.Actions, Vcl.StdActns, Vcl.Menus,
  Vcl.ComCtrls, Vcl.ToolWin, Vcl.ExtCtrls, vcl.Themes, vcl.Styles,
  System.ImageList, Vcl.ImgList;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Memo2: TSynMemo;
    SynPas: TSynPasSyn;
    MM: TMainMenu;
    File1: TMenuItem;
    ActionList1: TActionList;
    Open1: TMenuItem;
    FileSave: TAction;
    SavePASM1: TMenuItem;
    N1: TMenuItem;
    eXit1: TMenuItem;
    Options1: TMenuItem;
    EditorOptions1: TMenuItem;
    OptionEditor: TAction;
    FileOpen: TAction;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    Panel1: TPanel;
    Splitter1: TSplitter;
    ImageList1: TImageList;
    Panel2: TPanel;
    Panel3: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    OptionSegment: TAction;
    SegmentOptions1: TMenuItem;
    procedure GutterGetText(Sender: TObject; aLine: Integer;
      var aText: string);
    procedure Memo2StatusChange(Sender: TObject; Changes: TSynStatusChanges);
    procedure FormShow(Sender: TObject);
    procedure Memo2KeyPress(Sender: TObject; var Key: Char);
    procedure eXit1Click(Sender: TObject);
    procedure FileSaveUpdate(Sender: TObject);
    procedure FileOpenExecute(Sender: TObject);
    procedure FileSaveExecute(Sender: TObject);
    procedure OptionEditorExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure OptionSegmentExecute(Sender: TObject);
  private
    fHighlighters: TStringList;
    AfMRUFiles: array[0..0] of TStringList;
    function GetMRUEntry(N:integer;Index: integer): string;
    procedure AddMRUEntry(N:integer; AFileName: string);
    procedure RemoveMRUEntry(N:integer;AFileName: string);
    procedure ReadIniSettings;
    procedure WriteIniSettings;
  public
    txtEditorActiveLineColor: string;
    EditorActiveLineColor : TColor;
    txtEditorGutterTextColor : string;
    EditorGutterTextColor : TColor;
    txtEditorModifiedColor : string;
    EditorModifiedColor : TColor;
    txtEditorSavedColor : string;
    EditorSavedColor : TColor;
    fOldCaretY:integer;
    fn:string;
    property Highlighters: TStringList read fHighlighters;
    { Public declarations }
  end;

var
  Form1: TForm1;

function GetFileNameStr(var str:string):pwidechar;
function GetIniName:String;
function GetDirName:String;
function GetCDM:TForm1;
function getsyscolor(c: TColor; tc: tcontrol = nil): TColor;
function ASM_2_PAS(var src: ansistring):TAnsiStringListSimple;
function openini:TIniFile;
var
  CodeSeg,DataSeg,BssSeg: String;
implementation

{$R *.dfm}

uses Unit5, Unit3;

function GetCDM:TForm1;
begin
  result := Form1;
end;
function GetFileNameStr(var str:string):pwidechar;
var
 i: integer;
begin
  result := system.sysutils.strrscan(pwidechar(str),char('\'));
  if result = nil then
  begin
      result := system.sysutils.strrscan(pwidechar(str),char('/'));
      if result = nil then result := pwidechar(str);
  end;
  result := system.sysutils.strrscan(result,char('.'));
  if result=nil then
  begin
    setlength(str, length(str)+4);
    result := system.sysutils.strend(pwidechar(str));
    result^ := #0;
  end
  else
  begin
    i := 4-system.SysUtils.StrLen(result);
    if i > 0 then
     setlength(str, length(str)+i);
  end;
end;
function GetIniName:String;
var
 p : pwidechar;
begin
  result := Application.ExeName;
  p := GetFileNameStr(result);
  if p^=#0 then p^ := '.';
  p[1] := 'i';
  p[2] := 'n';
  p[3] := 'i';
end;
function GetDirName:String;
var
 r : string;
 p : pwidechar;
 l : NativeUint;
begin
  result := Application.ExeName;
  p := pointer(result);
  l := length(result);
  repeat
    dec(l);
  until (l=0) or (p[l-1]='\');
  setlength(result, l);
end;

function getsyscolor(c: TColor; tc: tcontrol = nil): TColor;
var
 a : TCustomStyleServices;
begin
   try
    result := c;
    a := StyleServices(tc);
    if a <> nil then
    result := a.GetSystemColor(c);
   except
   end;
end;

procedure getCDMColor(var txt :string; section,def,filename: pwidechar);
begin
  setlength(txt, 256);
  setlength(txt, GetPrivateProfileStringW('Editor', section, def, pointer(txt), 255, FileName));
end;


procedure TrimL(s: pansichar; var d: ansistring);
var
l,n : cardinal;
begin
   d := '';
   if s = nil then exit;
   l := system.ansistrings.strlen(s);
   n := 0;
   while (n <= l) and (s[n] <= ' ') do inc(n);
   if n < l then
   begin
     setlength(d, l - n);
     system.ansistrings.strcopy(pansichar(d), @s[n]);
   end;
end;

function TrimR(var d: ansistring):integer;
var
s:pansichar;
l : integer;
begin
   s := pointer(d);
   if s = nil then
   begin
      result := 0;
      exit;
   end;
   l := system.ansistrings.strlen(s);
   while (l > 0) and (s[l-1] <= ' ') do dec(l);
   setlength(d, l);
   result := l;
end;

var
 s_ptr:ansistring='      ptr ';

procedure mkd(l:integer; var s:ansistring; tvar:TAnsiStringList);
var
 j : integer;
 k : integer;
 c : ansichar;
 c1: ansistring;
 a : ansistring;
begin
  j := l;
  repeat
    dec(j);
    if j < 6 then exit;
    c := s[j];
    if c='[' then exit;
  until c='+';
  inc(j);
  c1 := copy(s, j, l-j);
  k := tvar.IndexOf(c1);
  if k <> -1 then
  begin
    a := copy(s_ptr, 1, 10);
    pinteger(a)^ := integer(tvar.Objects[k]);
    dec(j);
    repeat
      dec(j);
      c := s[j];
    until (c = ' ') or (c = ',');
    if a[1]='d' then a[5] := 'd';

    insert(a, s, j+1)

  end;
end;

procedure mkdxx(l:integer; var s:ansistring; tvar:tstringlist);
var
 j : integer;
 k : integer;
 c : ansichar;
 c1: ansistring;
 t : string;
 a : ansistring;
begin
  j := l;
  repeat
    dec(j);
    if j < 6 then exit;
    c := s[j];
    if c='[' then exit;
  until c='+';
  inc(j);
  c1 := copy(s, j, l-j);
  t := utf8toansi(c1);
  k := tvar.IndexOf(t);
  if k <> -1 then
  begin
    a := copy(s_ptr, 1, 10);
    pinteger(a)^ := integer(tvar.Objects[k]);;
    dec(j);
    repeat
      dec(j);
      c := s[j];
    until (c = ' ') or (c = ',');
    if a[1]='d' then a[5] := 'd';

    insert(a, s, j+1)

  end;
end;

procedure mvh(s:pansichar);
var
 l:integer;
 c: ansichar;
begin
 l := system.ansistrings.strlen(s)-1;
 if s[l] <> 'h' then exit;
 repeat
  c := s[l-1];
  if c='-' then break;
  s[l] := c;
  dec(l);
 until(l=1);
 s[l] := '$';
end;

type
 rdw=record
   case word of
   0: (w: array[0..1] of word);
   1: (b: array[0..1] of byte);
   2: (d: array[0..1] of dword);
   3: (c: array[0..1] of ansichar);
 end;
 pdw=^rdw;

procedure UString2AString(s: pdw);
var
 l : integer;
 d : NativeInt;
 c : ansichar;
begin
 if s=nil then exit;
 l := pinteger(@pansichar(s)[-4])^;
 if l=1 then
 begin
    inc(pansichar(s)[-4]);
    c := s.c[0];
    s.c[0] := ' ';
    s.c[1] := c;
    exit;
 end;
 d := 1;
 repeat
   c := s.c[d*2];
   dec(l);
   s.c[d] := c;
   inc(d);
 until l=0;
end;

procedure UString2AString2(s: pdw);
var
 l : integer;
 d : NativeInt;
 c : ansichar;
begin
 if s=nil then exit;
 l := pinteger(@pansichar(s)[-4])^;
 d := 0;
 repeat
   c := s.c[d*2];
   dec(l);
   s.c[d] := c;
   inc(d);
 until l=0;
end;

procedure add_array(const c2:ansistring; ts: tstrings; typ: integer);
var
 c0: ansistring;
 t : string;
begin
   c0 := trim(c2);
   t := Utf8toAnsi(c0);
   ts.AddObject(t, pointer(typ));
end;

procedure add_array_a(const c2:ansistring; ts: TAnsiStringList; typ: integer);
var
 c0: ansistring;
begin
   c0 := trim(c2);
   ts.AddObject(c0, pointer(typ));
end;

function stringtoint(const t: string):integer;
var
 c:integer;
begin
  val(t, result, c);
//  result := t.ToInteger;
end;

function ansistringtoint(const t: ansistring):integer;
var
 s : string;
begin
  s := utf8toansi(t);
  result := stringtoint(s);
end;
function toint(const s:string):integer;
begin
  if s='' then result := 0
  else
  result := pinteger(pointer(s))^ or $20202020;
end;
procedure BSS_to_PAS(m1, m2: TAnsiStringListSimple; ts: TAnsiStringList; seg:integer); stdcall;
var
 l:integer;
 c0, c1, c2, c3: AnsiString;
 i : integer;
 cnt: integer;
 nstr: string;
 pstr: pdw absolute nstr;
 abc: Ansistring absolute nstr;
label
 brk, c2pc0, zy;
begin
//    m1.IndexOf('BSS             segment para public '''''' use32')
  l := m1.count;
  repeat
    dec(l);
    if l <= 10 then exit;
    c0 := m1.Strings[l];
    if length(c0) < 26 then continue;
    i := pinteger(c0)^ or $20202020;
    if i = seg then break;
    case i of
     ord('_')+$20+(ord('b') shl 8)+(ord('s') shl 16)+(ord('s') shl 24),
     ord('b')+(ord('s') shl 8)+(ord('s') shl 16)+(ord(' ') shl 24) : break;
    end;
  until false;

  repeat
    if l > 1500000 then exit;
    c0 := m1[l];
    inc(l);
  until pos(AnsiString('db '), c0) <> 0;
  m2.Add(ansistring('Var'));
  triml(pointer(c0), c2);
  repeat
    if (length(c2) > 4) then
    begin
      i := pinteger(c2)^ or $20202020;
      if i = seg then break;
      case i of
       ord('b')+(ord('s') shl 8)+(ord('s') shl 16)+(ord(' ') shl 24),
       ord('_')+$20+(ord('b') shl 8)+(ord('s') shl 16)+(ord('s') shl 24): break;
      end;
     end;

    repeat
      if l > 1500000 then goto brk;
      c1 := m1[l];
      inc(l);
      if c1 ='' then continue;
      triml(pointer(c1), c3);
      if (c3<>'') and (c3[1]<>';') then break;
    until false;
    i := pos(AnsiString('db    ?'), c2);
    if i = 0 then
    begin
      i := pos(AnsiString('dd '), c2);
      if i = 0 then
      begin
        i := pos(AnsiString('dw '), c2);
        if i = 0 then
        begin
          i := pos(AnsiString('dq '), c2);
          if i = 0 then
          begin
            c2 := '//'+ c2;
            goto zy
          end;
          if i > 1 then
          begin
            setlength(c2, i-1);
            add_array_a(c2, ts, 8);
            c0 := ': int64;';
            goto c2pc0;
          end;
          nstr := l.ToString;
          UString2AString(pstr);
          c0 := 'q_'+abc+' : int64;';
          goto zy;
        end;
        if i > 1 then
        begin
          setlength(c2, i-1);
          add_array_a(c2, ts, 2);
          c0 := ': word;';
          goto c2pc0;
        end;
        nstr := l.ToString;
        UString2AString(pstr);
        c0 := 'w_'+abc+' : word;';
        goto zy;
      end;
      if i > 1 then
      begin
        setlength(c2, i-1);
        add_array_a(c2, ts, 4);
        c0 := ': integer;';
        goto c2pc0;
      end;
      nstr := l.ToString;
      UString2AString(pstr);
      c2 := 'd_'+abc+' : integer;';
      goto zy;
    end;
    if i > 1 then
    begin
      setlength(c2, i-1);
      add_array_a(c2, ts, 1);
      cnt := 0;
      while pos(AnsiString('db    ?'), c3)=1 do
      begin
        inc(cnt);
        c1 := m1[l];
        inc(l);
        triml(pointer(c1), c3);
      end;
      if cnt <> 0 then
      begin
        nstr := l.ToString(cnt);
        UString2AString(pstr);
        c0 := ': array[0..'+abc+'] of ansichar;';
      end
      else
        c0 := ': ansichar;';
c2pc0:
      c2 := '  '+c2 + c0;
{    end
    else
    begin
      t := l.ToString;
      UString2AString(pstr);
      c0 := 'b_'+abc+' : ansichar;//byte boolean ';
}
    end;
zy:
    m2.Add(c2);
    c0 := c1;
    c2 := c3;
  until false;
brk:
end;


function cha(c3: pAnsichar):pansichar;
begin
   result := system.ansistrings.strpos(c3, '; ');
   if result = nil then exit;
   result^ := '/';
   result[1] :='/';
end;

procedure che(var c2: Ansistring);
var
 i: integer;
 p: pdw;
begin
 if pos(Ansistring('//'), c2)<>0 then exit;
 i := pos(Ansistring('; '), c2);
 if i = 0 then
 begin
    c2 := c2 + ';';
    exit;
 end;
 p := pdw(pointer(c2));
 p.c[i-1] := '/';
 p.c[i] := '/';
 while p.c[i-2]=' ' do dec(i);
 insert(';', c2, i);
end;

procedure chf(var c2: Ansistring);
var
 i: integer;
 p: pdw;
begin
 i := pos(Ansistring('//'), c2);
 if i = 0 then
 begin
    c2 := c2 + ');';
    exit;
 end;
 p := pdw(pointer(c2));
 while p.c[i-2]=' ' do dec(i);
 insert(');', c2, i);
end;

function change_src(var src: ansistring; const c0, c2: ansistring; bproc: integer):boolean;
var
 i : integer;
 a : integer;
 lc2 : integer;
 lc0 : integer;
 c : ansichar;
 psrc: pansichar;
label
  l1;
begin
  a := bproc;
  result := false;
  lc2 := length(c2);
  lc0 := length(c0);
  repeat
l1:
    i := pos(c2, src, a);
    if i = 0 then break;
    a := i+lc2;
    dec(i);
    c := src[i];
    if (c = #10) then
    begin
        i := a;
        repeat
           inc(i);
           c := src[i];
        until c <> ' ';
        if c = '=' then goto l1;
    end
    else
    if (c = '+') then
    begin
        repeat
           if c='+' then
           if (src[i-1]='p') then
           begin
              c := src[i-3];
              if (c='e') or (c = 'r') then goto l1;
           end;
           dec(i);
           c := src[i];
        until (c='[');
    end
    else if src[i-1]=';' then goto l1;

    insert(c0, src, a);
    inc(a, lc0);
    result := true;
  until false;
end;

procedure kip(a,b,c,d:integer);
begin

end;
procedure kip2(a,b,c,d:integer);assembler;
asm

end;

const
 a0to: set of ansichar=['0'..'9'];
 a1to: set of ansichar =['!','%','('..')','+',','];
procedure cetan(var src:ansistring; aa:integer);
type
 ttb=record
 case byte of
 0:(b:array[0..31] of byte);
 2:(w:array[0..15] of word);
 4:(d:array[0..7] of dword);
 end;

var
i:integer;
a:integer;
j:integer;
p,p2:pansichar;
c0,c2:ansistring;
c:ansichar;
lc:ansichar;
t:string;
pstr:pdw absolute t;
abc:ansistring absolute t;
tb:ttb;
inch: byte;
begin
    p := pointer(src);
    repeat
      inc(aa);
    until p[aa]='d';
    inc(p, aa);
    inc(aa);
    p2 := p;
    repeat
      inc(p);
    until (p^=#13) and (p[2]<>' ');
    setstring(c2,p2, p-p2);

    delete(src, aa, p-p2);
    fillchar(tb, sizeof(tb), 0);
    i := pos(ansistring('; '), c2);
    if i <> 0 then
    begin
      a := i;
      i := pos(ansistring(#13), c2, i);
      if i <> 0 then delete(c2, a, i-a);
    end;
    c := c2[2];
    if c in a1to then j := 0;

    j := 0;
    i := 2;
    repeat
      inc(i);
    until c2[i]<>' ';
    a := i;
    repeat
      inc(a);
    until c2[a]=' ';
    repeat
      c0 := copy(c2, i, a-i);
      if c0[length(c0)] = 'h' then
      begin
        c2[i] := '$';
        c0[1] := '$';
        delete(c2, i+length(c0)-1, 1);
        dec(a);
        setlength(c0, length(c0)-1);
      end;
      i := ansistringtoint(c0);
      if c='b' then
      begin
        if j<=31 then
        tb.b[j] := i;
      end
      else
      begin
        if j<=7 then
        tb.d[j] := i;
      end;
      i := pos(ansistring(' d'), c2, a);
      if i = 0 then
      if (c <> 'd') or (c2[a]<>',') then break;
      inc(j);
      if c2[a]=',' then
      begin
        i := a+1;
      end
      else
      begin
        c2[a] := ',';
        inc(a);
        delete(c2, a, i-a+3);
        i := a;
        repeat
          inc(a);
        until c2[a]<>' ';
        delete(c2, i, a-i);
      end;
      a := i;
      repeat
        inc(a);
        case c2[a] of
        ' ':
         begin
           delete(c2, a, 1);
           if c2[a]<>';' then
           begin
            if c2[a-1]=',' then
            dec(a);
           end
           else
           repeat
            delete(c2, a, 1);
           until c2[a]=#13;
           break;
         end;
        #0,#13: break;
        end;
      until false;
    until false;
    t := j.ToString;
    UString2AString(pstr);
    i := 2;
    repeat
        inc(i);
    until c2[i]<>' ';
    delete(c2,1,i-1);
    insert(': array[0..',c2, 1);
    insert(abc,c2, 12);
    insert('] of ',c2, 14);

    if c='b' then
      insert('byte=(',c2, 19)
    else
      insert('dword=(',c2, 19);
    insert(');'#13#10, c2, length(c2)+1);
    insert(c2, src, aa);
    aa := aa+length(c2);
    c0 := '';
    c := #0;
    inch := 0;
    for a:= 0 to 7 do
    begin
       for j := 0 to 31 do
       begin
         if tb.d[a] and (1 shl j) <> 0 then
         begin
           if inch and 1 = 0 then
           begin
             lc := c;
             inch := inch or 1;
             if (c < #32) or (inch and 2<>0) then
             begin
               c := ansichar(ord(c)+32);
               inch := inch or 2;
             end;
             if c < #32 then
             begin
              t := inttostr(ord(c));
              Ustring2Astring2(pstr);
              c0 := c0 + '#'+abc;
             end
             else
             begin
               setlength(abc, 1);
               abc[1] := c;
               c0 := c0 + ''''+abc+'''';
             end;
             c := lc;
           end;
         end
         else
           if inch and 1 <> 0 then
           begin
             inch := inch and not 1;
             if ord(c)-1 <> ord(lc) then
             begin
              lc := c;
              if (c < #33) or (inch and 2<>0) then
              begin
                  c := ansichar(ord(c)+32);
                  inch := inch or 2;
              end;
              if c < #33 then
              begin
                t := inttostr(ord(c)-1);
                Ustring2Astring2(pstr);
                c0 := c0 + '..#'+abc;
              end
              else
              begin
               setlength(abc, 1);
               abc[1] := ansichar(ord(c)-1);
               c0 := c0 + '..'''+abc+'''';
              end;
             end;
             c := lc;
             insert(',', c0, length(c0)+1);
           end;
         inc(c);
       end;

    end;
    a := length(c0);
    if a <> 0 then
      if c0[a]=',' then setlength(c0, a-1);
    c0 := 'set of ansichar =['+c0+'];';
    insert(c0, src, aa);
end;

procedure INIT_CODE(var src: ansistring; ts: tansistringlist);
var
 a : integer;
 i : integer;
 aa: integer;
 c0,c2 : ansistring;
 p, p2: pansichar;
 c : ansichar;
label
 lagi;
begin
  a := pos(ansistring('proc'), src);
  repeat
    i := pos(ansistring(' bt  '), src, a);
    if i=0 then break;
    a := i+5;
    c2 := copy(src, a, 32);
    i := pos(AnsiString('['), c2);
    if i <> 0 then
    begin
      aa := i+1;
      i := pos(AnsiString(']'), c2, aa);
      if i = 0 then continue;
      c0 := copy(c2, aa, i-aa);
      if length(c0) < 4 then
      begin
        p := pointer(src);
        inc(p, a-5);
        repeat
          dec(p)
        until p^=#13;
        aa := 0;
lagi:
        p2 := p;
        inc(aa);
        if aa=10 then continue;
        repeat
          dec(p)
        until p^=#13;
        SetString(c2, p, p2 - p);
        i := pos(c0, c2, 3);
        if i = 0 then goto lagi;
        c0 := copy(c2, i + 4, 32);
        if c0[4]=':' then delete(c0, 1, 3);

        // p2-p;
      end;
    end
    else
    begin
       i := pos(AnsiString(','), c2, 5);
       if i = 0 then continue;
       dec(i);
       aa := i;
       while c2[i] <> ' ' do dec(i);
       c0 := copy(c2, i, aa-i);
    end;
    i := pos(ansistring('X'), c0, 2);
    if i > 0 then delete(c0, 2, i-1);
    c2 := copy(c0, 2, 20);
    if ts.IndexOf(c2) <> -1 then continue;
    c0[1] := #10;
    i := pos(c0, src, a+32);
    if i=0 then continue;
    aa := i+length(c0);
    ts.Add(c2);
    cetan(src, aa);
  until false;
end;

procedure INIT_DATA(var datastart:integer; var src: ansistring; var xjl: integer; m1 :TAnsiStringListSimple; td: TAnsiStringList; seg:integer); stdcall;
var
 l:integer;
 c0, c1, c2, c3, c4: AnsiString;
 i : integer;
 aa: integer;
 cnt : integer;
 bproc: integer;
label brk, atd, nxt;
begin
  l := m1.count;
  repeat
    if l <= 10 then exit;
    dec(l);
    c0 := m1.Strings[l];
    if length(c0)<26 then continue;
    i := pinteger(c0)^ or $20202020;
    if (i <> seg) then
    case i of
     ord('d')+(ord('a') shl 8)+(ord('t') shl 16)+(ord('a') shl 24),
     ord('_')+$20+(ord('d') shl 8)+(ord('a') shl 16)+(ord('t') shl 24): ;
     else
      continue;
    end;
    if (c0[7]=' ') then break;
    until false;

  repeat
    if l > 1500000 then exit;
    c0 := m1[l];
    inc(l);
    i := pos(ansistring('org'), c0);
    if i<>0 then
    begin
      delete(c0, 1, i+4);
      c1 := trimright(c0);
      setLength(c1, length(c1)-1);
      insert('$', c1, 1);
      datastart := ansistringtoint(c1);
      continue;
    end;
    if pos(ansistring('dq '), c0) <> 0 then break;
    if pos(ansistring('dw '), c0) <> 0 then break;
    if pos(ansistring('dd '), c0) <> 0 then break;
    if (pos(ansistring('db '), c0) <> 0) then break;
  until false;

  xjl := l;
  bproc := pos(ansistring('proc'), src);
  triml(pointer(c0), c2);
  repeat
    if (length(c2) > 4) then
    begin
      i := pinteger(c2)^ or $20202020;
      if (i = seg) and (c2[7]=' ') then break;
      case i of
        ord('d')+(ord('a') shl 8)+(ord('t') shl 16)+(ord('a') shl 24),
        ord('_')+$20+(ord('d') shl 8)+(ord('a') shl 16)+(ord('t') shl 24): if (c2[7]=' ') then break;
      end;
    end;

    repeat
      if l > 1500000 then goto brk;
      c1 := m1[l];
      inc(l);
      if c1 = '' then continue;
      triml(pointer(c1), c3);
      if (c3<>'') and (c3[1]<>';') then break;
    until false;

    i := pos(AnsiString('dd '), c2);
    if i = 0 then
       i := pos(AnsiString('dq '), c2);
    if i = 0 then
    begin
      i := pos(AnsiString('db '), c2);
      if i > 1 then
      begin
        setlength(c2, i-1);
        i := pos(AnsiString(' '''), c0);
        if i = 0 then
          cnt := 3
        else
          cnt := $11;
        goto atd;
      end;
      i := pos(AnsiString('dw '), c2);
      if i > 1 then
      begin
        setlength(c2, i-1);
        cnt := 2;
        goto atd;
      end;
      goto nxt;
    end;

    aa := i;
    setlength(c2, i-1);
    cnt := 5;
    if aa > 1 then
    begin
      i := pos(AnsiString('off'), c0, aa+3);
      if i > 0 then
      begin
        c4 := copy(c0, aa, 5);   // next line = dd/dq off
        delete(c0, 1, aa+2+6);
        while pos(c4, c3)=1 do
        begin
          inc(cnt);
          c1 := m1[l];
          inc(l);
          triml(pointer(c1), c3);
        end;
        if cnt <> 5 then cnt := 6
        else
        begin
          trimr(c2);
          c0[1] := 'X';
          i := pos(AnsiString(' '), c0, 3);
          if i <> 0 then setlength(c0, i-1);
          if change_src(src, c0, c2, bproc) then
          insert(c0, c2, length(c2)+1);
        end;
      end;
   end;
{   else
    begin
      asm nop end;
    end;
}
atd:
    trimr(c2);
    td.AddObject(c2, pointer(cnt));
    if datastart<>0 then goto nxt;
    i := pos(ansistring('_'), c2);
    if i <> 0 then
    begin
      delete(c2, 1, i);
      insert('$', c2, 1);
      datastart := ansistringtoint(c2);
    end;
nxt:
    c0 := c1;
    c2 := c3;
  until false;
brk:
end;
procedure graba(i: integer; var c2: ansistring); forward;

procedure DATA_to_PAS(var conststart: integer; xjl: integer; m1, m2:TAnsiStringListSimple; ts, td: TAnsiStringList; seg:integer); stdcall;
var
 l:integer;
 c0, c1, c2, c3, c4: AnsiString;
 i : integer;
 aa: integer;
 yi: integer;
 ji: integer;
 cnt: integer;
 nstr: string;
 pstr: pdw absolute nstr;
 abc: Ansistring absolute nstr;
 pc0: pdword;
 pc2: pansichar absolute c2;
 pcloc: pansichar;
label
 chkdb0, brk, zy;
begin
//    m1.IndexOf('DATA            segment para public '''DATA''' use32')

  l := xjl;
  conststart := m2.Count;
  m2.Add(ansistring('Const'));
  c0 := m1[l-1];
  triml(pointer(c0), c2);

  repeat
    if (length(c2) > 4) then
    begin
      i := pinteger(c2)^ or $20202020;
      if (i = seg) and (c2[7]=' ') then break;
      case i of
       ord('d')+(ord('a') shl 8)+(ord('t') shl 16)+(ord('a') shl 24),
       ord('_')+$20+(ord('d') shl 8)+(ord('a') shl 16)+(ord('t') shl 24),
       ord('_')+$20+(ord('i') shl 8)+(ord('d') shl 16)+(ord('a') shl 24) : if (c2[7]=' ') then break;
      end;
    end;

    repeat
      c1 := m1[l];
      inc(l);
      if c1='' then continue;
      triml(pointer(c1), c3);
      if (c3<>'') and ((c3[1] <> ';') or (c3[3]='"')) then break;
    until false;
{
      if pos(ansistring('off_40A004'), c2) <> 0 then
      if l=0 then
      if l=0 then ;
}
    i := pos(AnsiString('dd off'), c2);
    if i = 0 then
    begin
      i := pos(AnsiString('XREF'), c2);
      if i <> 0 then
      begin
        i := pos(AnsiString(' ; '), c2);
        setlength(c2, i);
      end;
      i := pos(AnsiString(' d'), c2);
      if i = 0 then
      begin
        i := pos(ansistring(': array'), c2);
        if i = 0 then
        begin
          c2 := '//'+ c2;
        end;
        goto zy;
      end;
      aa := i+2;
      i := pos(AnsiString('b '''), c2, aa);
      if i = aa then
      begin
        cnt := pos(AnsiString(''''), c2, aa+1+2);
        pcloc := @pc2[cnt];
        if (pcloc^=',') then
        begin
          if ((pcloc[1]<>'0') or (pcloc[2]<>#0)) then
          begin
            graba(aa, c2);
            goto chkdb0;
          end;
          delete(c2, cnt+1, 2);
          insert('#0;', c2, cnt+1);
        end;
        dec(cnt, aa);
        cnt := ((cnt + 3) and $7C)-1;
        nstr := l.ToString(cnt);
        UString2AString(pstr);

        c0 := ': array[0..'+abc+'] of ansichar =';

        insert(c0, c2, aa+2);
chkdb0:
        delete(c2, aa-1, 2);
        c2 := '  '+c2;
        if (pos(AnsiString('db    0'), c3)=1) then
        begin
          repeat
            m2.Add(c2);
            c2 := '  // '+c3;
            c1 := m1[l];
            inc(l);
            triml(pointer(c1), c3);
          until pos(AnsiString('db    0'), c3)<>1;

          while (c3='') or (c3[1]=';') do
          begin
            c1 := m1[l];
            inc(l);
            triml(pointer(c1), c3);
          end;
        end;
        goto zy;
      end;

      i := pos(AnsiString('b  '), c2, aa);
      if i = 0 then
      begin
        goto zy;
      end;
      yi := i-1;
      i := 4;
      while c2[yi+i+1] = ' ' do inc(i);

      delete(c2, yi, i+1);

      i := pos(AnsiString(' ; '), c2);
      if i <> 0 then
          setlength(c2,i);

      trimr(c2);
      c0 := copy(c2, yi, 12);
      ji := length(c0);
      if ji > 1 then
      begin
        setlength(c2, yi-1);
        if pdw(pointer(c0)).c[ji-1]= 'h' then
        begin
          setlength(c0, ji-1);
          if c0[1]='0' then c0[1] := '$'
            else c0 := '$'+c0;
        end;
        c2 := c2+c0;
      end;

      aa := m2.count;
      cnt := 0;
      c0 := '';
      while pos(AnsiString('db '), c3)=1 do
      begin
          delete(c3, 1, 3);

          ji := pos(Ansistring(' ;'), c3);
          if ji <> 0 then setlength(c3, ji);

          c3 := trim(c3);

          ji := length(c3);
          if pdw(pointer(c3)).c[ji-1]= 'h' then
          begin
            setlength(c3, ji-1);
            if c3[1]='0' then c3[1] := '$'
           else c3 := '$'+c3;
          end;

          inc(cnt);
          c0 :=  c0+'   ,'+c3;
          if cnt and 3=3 then
          begin
             m2.Add(c0);
             c0 := '';
          end;

          c1 := m1[l];
          inc(l);
          triml(pointer(c1), c3);
      end;
      if cnt = 0 then
      begin
            insert(': byte = ', c2, aa);
            c2 := '  '+c2+';';
      end else
      begin
           if c0<>'' then
             m2.Add(c0);

           nstr := l.ToString(cnt);
           UString2AString(pstr);
           c0 := ': array[0..'+abc+'] of byte= (';
           insert(c0, c2, yi);
           c2 := '  '+c2;
           m2.Insert(aa, c2);

           cnt := m2.count-1;
           c2 := m2.Strings[cnt];
           m2.Delete(cnt);
           c2 := c2+');'#13#10;
           goto zy;
      end;
    end // dd off
    else
    if i > 1 then
    begin
      aa := i;
      delete(c2, i, 10);
      i := pos(AnsiString('XREF'), c2);
      if i = 0 then
      begin

        i := pos(AnsiString('; "'), c3);
        if i <> 0 then
        begin
          c2 := c2 + ' ' + c3;
          repeat
            c1 := m1[l];
            inc(l);
          until c1 <> '';
          triml(pointer(c1), c3);
          i := -1;
        end;

      end
      else
      begin
        i := pos(AnsiString(' ; '), c2);
        if i <> 0 then setlength(c2, i);
        i := -1;
      end;
      if i <> 0 then
      begin
        if pos(AnsiString('; sub'), c3) <> 0 then
        begin
          repeat
            c1 := m1[l];
            inc(l);
          until c1 <> '';
          triml(pointer(c1), c3);
        end;

        if pos(AnsiString('; '), c3) = 1 then
        begin
          c3[1] := '/';
          insert('/', c3, 1);
          yi := length(c2);
          c2 := c2 + c3;
          repeat
            c1 := m1[l];
            inc(l);
          until c1 <> '';
          triml(pointer(c1), c3);

          if pos(ansistring('dd'), c3)<>1 then

            if c2[yi] <> ' ' then
              c2 := c2 +';'
            else
            begin
              while c2[yi-1] = ' ' do dec(yi);
              c2[yi] := ';';
            end;

        end;
      end;

      cnt := m2.Count;
      while pos(AnsiString('dd off'), c3)=1 do
      begin
        delete(c3, 1, 10);
        cha(pointer(c3));
        c3 := '   ,@'+c3;
        m2.Add(c3);
        c1 := m1[l];
        inc(l);
        triml(pointer(c1), c3);
      end;
      i := m2.Count-cnt;
      if i <> 0 then
      begin
        yi := i;
        nstr := l.ToString(yi);
        UString2AString(pstr);
        c0 := ': array[0..'+abc+'] of pAnsiChar= (@';

        insert(c0, c2, aa);

        c2 := '  '+c2;
        m2.Insert(cnt, c2);

        cnt := m2.count-1;
        c2 := m2.Strings[cnt];
        m2.Delete(cnt);
        chf(c2);
        c2 := c2 + #13#10;
      end
      else
      begin
        trimr(c2);
        c0:= copy(c2, aa, 100);

        i := pos(Ansistring(';'), c0);
        if i = 0 then
           i := pos(Ansistring(' '), c0);
        if i <> 0 then
          setlength(c0, i-1);

        i := td.IndexOf(c0);
        if i<>-1 then
        begin
          yi := i;
          i := integer(td.Objects[yi]);
          case i of
           3 : c0 := ': pointer = @';
           6 : c0 := ': ppointer= @';
          else
            c0 := ': ppAnsiChar = @'
          end;
        end
        else
        begin
          i := ts.IndexOf(c0);
          if i<>-1 then
          begin
            yi := i;
            i := integer(ts.Objects[yi]);
            c0 := ': pAnsiChar = @';
            case i of
              4 : ;
            else ;

            end;
          end
          else
          c0 := ': pAnsiChar = @';
        end;
        insert(c0, c2, aa);
        c2 := '  '+c2;
        che(c2);
      end;
    end
    else  {dd off}
    begin
       c2 := ', @'+c2;
       che(c2);
    end;
zy:
    m2.Add(c2);
    c0 := c1;
    c2 := c3;
  until false;
brk:
end;

procedure chkcomment(var c2: ansistring);
var
 i:integer;
begin
  i := pos(ansistring(';'), c2);
  if i <> 0 then
  begin
     setlength(c2, i-1);
     trimr(c2);
  end;
end;

procedure inttochr(var s:ansistring);
var
a : integer;
v : ansistring;
begin
  v := s;
  a := pos(ansistring(' dup'), s);
  if a <> 0 then
  begin
    setlength(s, a-1);
    delete(v, 1, a+4);
    setlength(v, length(v)-1);
    inttochr(v); // recursive
    a := ansistringtoint(s);
    setlength(s, a);
    for a := 1 to a do
      s[a] := v[1];
  end
  else
  begin
    setlength(s, 1);
    s[1] := ansichar(ansistringtoint(v));
  end;
end;

procedure graba(i: integer; var c2: ansistring);
const
 maxs=9;
var
 a:array[0..maxs] of ansistring;
 s:ansistring;
 x:integer;
 l:integer;
 m:integer;
 c:ansichar;
 instring:boolean;
 t:string;
 q: pdw absolute t;
 abc: ansistring absolute t;
begin
 inc(i,2);
 x := pos(ansistring('//') , c2, i);
 if x = 0 then x := $3FFF;
 a[maxs] := copy(c2, i, x-i-1);
 a[maxs] := trim(a[maxs]);

 for l := 0 to maxs-1 do
 begin
   if a[maxs]='' then break;
   if (a[maxs][1]='''') then
   begin
     x := pos(AnsiString(''''), a[maxs], 2)+1;
   end
   else
   begin
    x := pos(AnsiString(','), a[maxs]);
   end;
   if x<2 then break;
   a[l] := copy(a[maxs], 1, x-1);
   delete(a[maxs], 1, x);
  end;
 for l := 0 to maxs do
 if a[l] <> '' then
 begin
   s := a[l];
   m := length(s);
   if s[1]='''' then
   begin
     setlength(s, m-1);
     delete(s, 1, 1);
   end
   else
   begin
     if s[1]=' ' then
     begin
        dec(m);
        delete(s, 1, 1);
     end;

     if s[m]='h' then
     begin
       setlength(s, m-1);
       insert('$', s, 1);
     end;
     inttochr(s);
   end;
   if l=0 then
     a[0] := s
   else
    insert(s, a[0], length(a[0])+1)
 end;
 s := a[0];
 m := ((length(s)+ 3) and $7C)-1;
 t := m.ToString;
 UString2AString(q);
 a[0] := ': array[0..'+abc+'] of ansichar = ';
 a[1] := '';
 instring := false;
 for l := 1 to length(s) do
 begin
   c := s[l];
   case c of
   #0..#31: begin
              if instring then
              begin
               instring := false;
               a[1] := a[1]+'''';
              end;
              a[1] := a[1]+'#';
              t := integer(c).ToString;
              a[2] := Ansitoutf8(t);
              a[1] := a[1]+a[2];
            end;
   '''': begin
           if not instring then
           begin
            instring := true;
            a[1] := a[1]+'''''''';
           end
           else
            a[1] := a[1]+'''''';

          end;
   #255: exit;
   else
     if not instring then
     begin
        a[1] := a[1]+'''';
        instring := true;
     end;
     m := length(a[1])+1;
     setlength(a[1], m);
     a[1][m] := c;
   end;
 end;
 if instring then
  a[1] := a[1]+'''';
 s := a[0]+a[1]+'; //rchk ';
 insert(s, c2, i);
end;

procedure grada(i: integer; var c2: ansistring);
var
x:integer;
a,b:ansistring;
s:ansistring;
m:integer;
t:string;
q: pdw absolute t;
abc: ansistring absolute t;
begin
 inc(i,2);
 x := pos(ansistring('//') , c2, i);
 if x = 0 then x := $3FFF;
 a := copy(c2, i, x-i-1);
 a := trim(a);
// delete(c2, i, x-i-1);
 x := pos(AnsiString(','), a);
 if x=0 then
 begin
   if pos(ansistring('off'), a)=0 then
   begin
    m := length(a);
    if a[m]='h' then
    begin
     setlength(a, m-1);
     insert('$', a, 1);
    end;

    if pos(ansistring('.'), a)<>0 then
    begin
      t := utf8toansi(a);
      // t.ToExtended;
    end
    else m := ansistringtoint(a); // t.ToInteger;
    s := ': dword ='+a+';//';
   end
   else
   begin
      delete(a, 1, 7);
      s := ': pointer =@'+a+';//';
   end;
 end
 else
 begin
   m := 0;
   repeat
      inc(m);
      b := copy(a, 1, x-1);
      delete(a, 1, x+1);

      x := length(b);
      if b[x]='h' then
      begin
         setlength(b, x-1);
         insert('$', b, 1);
      end;
      s := s+b+',';
      x := pos(AnsiString(','), a);
   until x=0;
   t := m.ToString;
   UString2AString(q);
   m := length(a);
   if a[m]='h' then
   begin
     setlength(a, m-1);
     insert('$', a, 1);
   end;
   s := s+a;
   s := ': array[0..'+abc+'] of dword=('+s+');//';
 end;
 insert(s, c2, i);
end;

procedure CODE_to_PAS(datastart, conststart: integer; m1, m2:TAnsiStringListSimple; ts, te: TAnsiStringList; seg:integer); stdcall;
type
 prm_enum=(prm_nil,
  prm_al,prm_ax,prm_eax,
  prm_dl,prm_dx,prm_edx,
  prm_cl,prm_cx,prm_ecx,
  ret_al,ret_ax,ret_eax,
  stdcall);
 tprm_enum=set of prm_enum;

var
 l:integer;
 c0, c1, c2, c3, c4: AnsiString;
 i : integer;
 aa: integer;
 yi: integer;
// ji: integer;
 beginproc:integer;
 beginasm:integer;
 cnt: integer;
 nstr:string;
 pstr: pdw absolute nstr;
 abc: Ansistring absolute nstr;
 v1,v2: integer;
 tvar: TAnsiStringList;
 tconst:TAnsiStringListSimple;
 tpas:TAnsiStringListSimple;
 prm:tprm_enum;
 bd : byte;
 dloc: pdw absolute c4;
 cloc: pdw absolute c2;
 pc2: pansichar absolute c2;
 pcloc: pansichar;
 c:ansichar;
label
 ignore, chkj, xn, chkproc, nobyte, chkdb0, addcom, nxt,
 xy,
 jx, lx, mx, px, pax, pdx, pcx, rx, ox, wx, xx, xx2, zy, yz, zz;
begin
//    m1.IndexOf('CODE            segment para public '''CODE''' use32')
  l := m1.count;
  repeat
    if l <= 10 then exit;
    dec(l);
    c0 := m1.Strings[l];
    if length(c0)<=25 then continue;
    i := pinteger(c0)^ or $20202020;
    if i <> seg then
    case i of
      ord('c')+(ord('o') shl 8)+(ord('d') shl 16)+(ord('e') shl 24),
      ord('_')+$20+(ord('c') shl 8)+(ord('o') shl 16)+(ord('d') shl 24),
      ord('_')+$20+(ord('t') shl 8)+(ord('e') shl 16)+(ord('x') shl 24): ;
      else continue;
    end;
    if c0[7]=' ' then break;
  until false;

  repeat
    if l > 500000 then exit;
    c0 := m1[l];
    inc(l);
  until (pos(ansistring('proc'), c0) <> 0);
  ts.Clear;
  ts.AddObject(ansistring('-'), nil);
  tconst := TAnsiStringListSimple.Create;
  tpas := TAnsiStringListSimple.Create;
  tvar := TAnsiStringList.Create;
  bd := 0;
  beginproc := 0;
  beginasm := 0;
  word(prm) := 0;
  v1 := $400000;

  triml(pointer(c0), c2);
  repeat
    repeat
      if l > 1500000 then break;
      c1 := m1[l];
      inc(l);
      if c1= '' then continue;
      triml(pointer(c1), c3);
      if (c3<>'') and ((c3[1]<>';') or (pos(ansistring('_stdcall'), c3)<> 0)) then break;
    until false;

    if (length(c2) < 4) then goto ignore;
    i := pinteger(c2)^ or $20202020;
    if (i = seg) and (c2[7]=' ') then break;
    case i of
      ord('c')+(ord('o') shl 8)+(ord('d') shl 16)+(ord('e') shl 24),
      ord('_')+$20+(ord('c') shl 8)+(ord('o') shl 16)+(ord('d') shl 24),
      ord('_')+$20+(ord('t') shl 8)+(ord('e') shl 16)+(ord('x') shl 24): if c2[7]=' ' then break;

      ord('a')+(ord('l') shl 8)+(ord('i') shl 16)+(ord('g') shl 24),
      ord('a')+(ord('s') shl 8)+(ord('s') shl 16)+(ord('u') shl 24) :
        goto ignore;
      ord('c')+(ord('a') shl 8)+(ord('l') shl 16)+(ord('l') shl 24) :
      begin
        pcloc := pc2;
        i := 6;
        repeat
          inc(i);
        until pcloc[i] <> ' ';
        c4 := copy(c2, i+1, length(c2));
        i := pos(AnsiString(' '), c4, 2);
        if i <> 0 then setlength(c4, i-1);
        if pinteger(c4)^ = ord('s')+(ord('u') shl 8)+(ord('b') shl 16)+(ord('_') shl 24) then
        begin
            c0 := copy(c4, 4, 20);
            c0[1] := '$';
            if Ansistringtoint(c0) > v1 then
              if ts.IndexOf(c0)<0 then
                ts.Add(c0);
        end;
        tpas.add(c4);
        bd := bd and not 8;
        word(prm) := word(prm) and not ((1 shl ord(ret_eax)) or (1 shl ord(ret_ax)) or (1 shl ord(ret_al)));
        goto xx2;
      end;
      ord('s')+(ord('e') shl 8)+(ord('t') shl 16)+(ord(' ') shl 24) :
      begin
        insert('; ', c2, 1);
        goto xx;
      end;
    end;

    if pos(ansistring('start'), c2) <> 0 then
    begin
      bd := bd or (8+4+1);
      word(prm) := 0;
      goto zy;
    end;
{

 for $1000
 
}
xx:
    if c2[1]=';' then
    begin
      aa := 1;
      goto addcom;
    end;
xx2:
    i := pos(AnsiString(' ; '), c2);
    if i > 0 then
    begin
      aa := i+1;
      if system.ansistrings.strpos(pansichar(@c2[aa]), 'XREF') <> nil then
      begin
        setlength(c2, aa-1);
        trimr(c2);
      end
      else if (c2[aa+2]<>'{') then
      begin
addcom:
         c2[aa] := '/';
         insert('/', c2, aa);
      end;
    end;
{

 for $1000
 
}

xy:
    c2 := '  '+c2;
zy:
    if bd and 4 = 0 then
    begin
       inc(beginasm);
       m2.insert(beginasm, c2);
    end
    else
zz:
    m2.Add(c2);

ignore:
    c0 := c1;
    c2 := c3;
  until false;

  tvar.free;
  tpas.free;
  tconst.free;

  aa := integer(ts.Objects[0]);
  if aa > 0 then
  begin
    repeat
        c4 := m2[aa];
        dec(aa);
    until (aa=0) or ((length(c4)>4) and (dloc.d[0]=ord('p')+(ord('r') shl 8)+(ord('o') shl 16)+(ord('c') shl 24)));
  m2.Insert(aa, '');
  inc(aa);
  m2.insert(aa,'// ---------- forward ----------');
  for l := 1 to ts.Count-1 do
  begin
    c4 := ts.Strings[l];
    c4[1] := '_';
    c4 := 'procedure sub'+c4+';forward;';
    inc(aa);
    m2.Insert(aa, c4);
  end;
  m2.Insert(aa+1, '');
  end;
end;


function ASM_2_PAS(var src: ansistring):TAnsiStringListSimple;
var
 ts,td : TAnsiStringList;
 m1: TAnsiStringListSimple;
 datastart, conststart, xl: integer;
 o:ansistring;
begin
 result := TAnsiStringListSimple.Create;
 m1 := TAnsiStringListSimple.Create;
 m1.Text := src;
 ts := TAnsiStringList.Create;
 td := TAnsiStringList.Create;
 INIT_DATA(datastart, src, xl, m1, td, toint(dataseg));
 INIT_CODE(src, ts);
 ts.clear;
 m1.Text := src;
 src := '';
 BSS_to_PAS(m1, result, ts, toint(bssseg));
 DATA_to_PAS(conststart, xl, m1, result, ts, td, toint(dataseg));
 CODE_to_PAS(datastart, conststart, m1, result, ts, td, toint(codeseg));
 ts.Free;
 td.free;
 m1.Free;
end;


procedure TForm1.eXit1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.FileOpenExecute(Sender: TObject);
var
 s : string;
 d : ansistring;
 m2: TAnsiStringListSimple;
begin
    with TFileOpenDialog.Create(Self) do
    begin
      DefaultExtension := 'asm';
      with FileTypes.add do
      begin
        DisplayName := '*.asm';
        FileMask := '*.asm';
      end;
      with FileTypes.add do
      begin
        DisplayName := '(*.*)';
        FileMask := '*.*';
      end;
//      Options := Options + [fdoFileMustExist];
      if Execute then s := FileName
      else s := '';
      free;
      if s = '' then exit;
    end;
    fn := s;
    s := extractfilename(s);
    label2.Caption := s;
    label1.Caption := 'Loading ...';
    application.ProcessMessages;
    memo1.Lines.LoadFromFile(fn);
    memo2.ClearAll;
    application.ProcessMessages;
    application.ProcessMessages;
    application.ProcessMessages;
    s := memo1.lines.Text;
    d := ansitoutf8(s);
    s := '';
    label1.Caption := '...';
    m2 := ASM_2_PAS(d);
    d := m2.Text;
    s := utf8toAnsi(d);
    d := '';
    Memo2.LockUndo;
    Memo2.Lines.Text := s;
    s := '';
    memo2.UnlockUndo;
    m2.free;
    label1.Caption := '';
end;

procedure TForm1.FileSaveExecute(Sender: TObject);
var
  p,d:pwidechar;
  s:string;
  l : integer;
begin
    d := pwidechar(fn);
    if (d=nil) or (memo2.Lines.Count=0) then exit;
    p := strRscan(d, '.');
    l := integer(p-d);
    setstring(s, d, l);
    s := s+'.pasm';
    with TFileSaveDialog.Create(Self) do
    begin
      FileName := s;
      DefaultExtension := 'pasm';
      with FileTypes.add do
      begin
        DisplayName := '*.pasm';
        FileMask := '*.pasm';
      end;
      with FileTypes.add do
      begin
        DisplayName := '(*.*)';
        FileMask := '*.*';
      end;
      Options := Options + [fdoOverWritePrompt];
      if Execute then s := FileName
      else s := '';
      free;
      if s = '' then exit;
    end;
    memo2.lines.SaveToFile(s);
    memo2.MarkModifiedLinesAsSaved;
    memo2.Modified := False;
end;

procedure TForm1.FileSaveUpdate(Sender: TObject);
begin
  FileSave.Enabled := memo2.Lines.Count<>0;
end;

type
 TScrollingStyleHook2 = class(TScrollingStyleHook)
//    procedure WMMove(var Msg: TMessage); message WM_MOVE;
    procedure UpdateScroll; override;
 end;
procedure TScrollingStyleHook2.UpdateScroll;
begin
  if Control.Visible then inherited;
end;

const
MAX_MRU=10;

procedure TForm1.AddMRUEntry(N:integer; AFileName: string);
begin
  if AFileName <> '' then begin
    RemoveMRUEntry(N, AFileName);
    AfMRUFiles[N].Insert(0, AFileName);
    while AfMRUFiles[N].Count > MAX_MRU do
      AfMRUFiles[N].Delete(AfMRUFiles[N].Count - 1);
  end;
end;

function TForm1.GetMRUEntry(N:integer;Index: integer): string;
begin
  if (Index >= 0) and (Index < AfMRUFiles[N].Count) then
    Result := AfMRUFiles[N][Index]
  else
    Result := '';
end;

procedure TForm1.RemoveMRUEntry(N:integer;AFileName: string);
var
  i: integer;
begin
  for i := AfMRUFiles[N].Count - 1 downto 0 do begin
    if CompareText(AFileName, AfMRUFiles[N][i]) = 0 then
      AfMRUFiles[N].Delete(i);
  end;
end;
function openini:TIniFile;
begin
  result := TIniFile.Create(GetIniName);
end;

procedure TForm1.ReadIniSettings;
var
  iniFile: TIniFile;
  x, y, w, h: integer;
  i: integer;
  s: string;
begin
  iniFile := openini;
  try
    x := iniFile.ReadInteger('M', 'L', 0);
    y := iniFile.ReadInteger('M', 'T', 0);
    w := iniFile.ReadInteger('M', 'W', 0);
    h := iniFile.ReadInteger('M', 'H', 0);
    if (w > 0) and (h > 0) then
      SetBounds(x, y, w, h);
    if iniFile.ReadInteger('M', 'Max', 0) <> 0 then
      WindowState := wsMaximized;
//    StatusBar.Visible := iniFile.ReadInteger('Main', 'ShowStatusbar', 1) <> 0;
    // MRU files
    for i := MAX_MRU-1 downto 0 do begin
      s := iniFile.ReadString('F', Format('F%d', [i]), '');
      if s <> '' then
        AddMRUEntry(0, s);
    end;
  finally
    iniFile.Free;
  end;
end;

procedure TForm1.WriteIniSettings;
var
  iniFile: TIniFile;
  wp: TWindowPlacement;
  i: integer;
  s: string;
begin
  s := GetIniName;
  iniFile := TIniFile.Create(s);
  try
    wp.length := SizeOf(TWindowPlacement);
    GetWindowPlacement(Handle, @wp);
    // form properties
    with wp.rcNormalPosition do begin
      iniFile.WriteInteger('M', 'L', Left);
      iniFile.WriteInteger('M', 'T', Top);
      iniFile.WriteInteger('M', 'W', Right - Left);
      iniFile.WriteInteger('M', 'H', Bottom - Top);
    end;
    iniFile.WriteInteger('M', 'Max', Ord(WindowState = wsMaximized));
//    iniFile.WriteInteger('Main', 'ShowStatusbar', Ord(Statusbar.Visible));
    // MRU files
    for i := 0 to MAX_MRU-1 do begin
      s := GetMRUEntry(0, i);
      if s <> '' then
        iniFile.WriteString('F', Format('F%d', [i]), s)
      else
        iniFile.DeleteKey('F', Format('F%d', [i]));
    end;
  finally
    iniFile.Free;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  HL: TStringList;
  O : TSynCustomHighlighter;
  j : integer;
  FileName : string;
  Style: string;
begin
  FileName := GetIniName;
  setlength(Style, 256);
  setlength(Style, GetPrivateProfileString('Style', 'Name', '', pointer(Style), 255, pointer(FileName)));
  if Style <> '' then TStyleManager.TrySetStyle(Style);

  getCDMColor(txtEditorActiveLineColor, 'ALC', 'clNone', pointer(FileName));
  EditorActiveLineColor := StringToColor(txtEditorActiveLineColor);
  getCDMColor(txtEditorGutterTextColor, 'GT', 'clWindowText', pointer(FileName));
  EditorGutterTextColor := StringToColor(txtEditorGutterTextColor);
  getCDMColor(txtEditorModifiedColor, 'ML', 'clYellow', pointer(FileName));
  EditorModifiedColor := StringToColor(txtEditorModifiedColor);
  getCDMColor(txtEditorSavedColor, 'SL', 'clLime', pointer(FileName));
  EditorSavedColor := StringToColor(txtEditorSavedColor);

  FileName := GetDirName;
  FileName := FileName + 'HL\';
  SynPas.LoadFromFile(FileName + SynPas.Name+'.HL');
  fHighlighters := TStringList.Create;
  fHighlighters.AddObject(SynPas.GetLanguageName, SynPas);
  AfMRUFiles[0] := TStringList.Create;
  TStyleManager.Engine.UnRegisterStyleHook(TCustomSynEdit, TScrollingStyleHook);
  TStyleManager.Engine.RegisterStyleHook(TCustomSynEdit, TScrollingStyleHook2);
  ReadIniSettings;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  WriteIniSettings;
  TStyleManager.Engine.UnRegisterStyleHook(TCustomSynEdit, TScrollingStyleHook2);
  TStyleManager.Engine.RegisterStyleHook(TCustomSynEdit, TScrollingStyleHook);
  AfMRUFiles[0].Free;
  fHighlighters.Free;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  Memo2.UseCodeFolding := true;
end;

procedure TForm1.GutterGetText(Sender: TObject; aLine: Integer;
  var aText: string);
var
pc: pwidechar;
begin
  if (aLine = 1) then
  begin
    if TSynMemo(Sender).Lines.Count=0 then aText := '';
    exit;
  end;
  if (aLine = TSynEdit(Sender).CaretY) then exit;
  if (aLine mod 10 = 0) then exit;
  setlength(aText, 1);
  pc := pointer(aText);
  if Aline mod 5 = 0 then
     pc^ := '-'
  else
     pc^ := '.';
end;

procedure TForm1.Memo2KeyPress(Sender: TObject; var Key: Char);
var
 c : char;
 s : string;
begin
  s := memo2.Lines.Strings[fOldCaretY];
  c := key;
  case char(ord(c) or $20) of
  'a' : ;
  'b' : ;
  'c' : ;
  'd' : ;
  'w' : ;
  end;

end;

procedure TForm1.Memo2StatusChange(Sender: TObject; Changes: TSynStatusChanges);
Var
  NewCaretY: integer;
begin
  if (scCaretY in Changes)then
  begin
    NewCaretY := TSynEdit(Sender).CaretY;
    TSynEdit(Sender).InvalidateGutterLine(fOldCaretY);
    TSynEdit(Sender).InvalidateGutterLine(NewCaretY);
    fOldCaretY := NewCaretY;
  end;
end;

procedure TForm1.OptionEditorExecute(Sender: TObject);
var
i: integer;
s: string;
f: string;
begin
 With TEditorOpt.Create(Self) do
 begin
  if showModal = mrOK then
  begin
    i := CB1.ItemIndex;
    if i>=0 then
    begin
      s := CB1.Items[i];
      f := TStyleManager.ActiveStyle.Name;
      if s<>f then
      begin
        free;
        try
          if s='' then
             TStyleManager.SetStyle(TStyleManager.SystemStyle)
          else
           TStyleManager.TrySetStyle(s);
          f := GetIniName;
          WritePrivateProfileString('Style', 'Name', pointer(s), pointer(f));
        except
        end;
        with memo2 do
        begin
         Gutter.Font.Color := EditorGutterTextColor;
         Gutter.ModificationColorModified := EditorModifiedColor;
         Gutter.ModificationColorSaved := EditorSavedColor;
         ActiveLineColor := EditorActiveLineColor;
        end;
      end;
      exit;
    end;
  end;
  free;
 end;
end;

procedure TForm1.OptionSegmentExecute(Sender: TObject);
begin
  with TForm3.Create(Self) do
  begin
     if CodeSeg='' then
        RadioGroup1.ItemIndex:=0
     else
     begin
        Edit1.Text := CodeSeg;
        RadioGroup1.ItemIndex:=1;
     end;
     if DataSeg='' then
        RadioGroup2.ItemIndex:=0
     else
     begin
        Edit2.Text := DataSeg;
        RadioGroup2.ItemIndex:=1;
     end;
     if BSSSeg='' then
        RadioGroup3.ItemIndex:=0
     else
     begin
        Edit3.Text := BSSSeg;
        RadioGroup3.ItemIndex:=1;
     end;
     if ShowModal=mrOK then
     begin
        CodeSeg := '';
        DataSeg := '';
        BSSSeg := '';
        if RadioGroup1.ItemIndex=1 then CodeSeg := Edit1.Text;
        if RadioGroup2.ItemIndex=1 then DataSeg := Edit2.Text;
        if RadioGroup3.ItemIndex=1 then BssSeg := Edit3.Text;
        with OpenIni do
        begin
          if BssSeg <> '' then
            WriteString('S', 'B', BssSeg)
          else
            DeleteKey('S', 'B');
          if CodeSeg <> '' then
            WriteString('S', 'C', CodeSeg)
          else
            DeleteKey('S', 'C');
          if DataSeg <> '' then
            WriteString('S', 'D', DataSeg)
          else
            DeleteKey('S', 'D');
          Free;
        end;
     end;
     free;
  end;
end;

end.
