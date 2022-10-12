unit Unit1;
{$H+,O+,W-,C-}
interface

uses
  Winapi.Windows, Winapi.Messages, System.AnsiStrings, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, SynEdit, SynMemo,
  SynEditHighlighter, SynHighlighterAsm, SynEditCodeFolding, SynHighlighterPas;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    Memo2: TSynMemo;
    SynPasSyn1: TSynPasSyn;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Memo2GutterGetText(Sender: TObject; aLine: Integer;
      var aText: string);
    procedure Memo2StatusChange(Sender: TObject; Changes: TSynStatusChanges);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    fOldCaretY:integer;
    fn:string;
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

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
 aa:ansistring='      ptr ';

procedure mkd(var s:ansistring; l:integer; tvar:tstringlist);
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
  t := c1;
  k := tvar.IndexOf(t);
  if k <> -1 then
  begin
    a := copy(aa, 1, 10);
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

procedure ASM_2_PAS(memo1, memo2: tstrings; s:string);
type
 prm_enum=(prm_nil,
  prm_al,prm_ax,prm_eax,
  prm_dl,prm_dx,prm_edx,
  prm_cl,prm_cx,prm_ecx,
  ret_al,ret_ax,ret_eax);
 tprm_enum=set of prm_enum;

 var
 t : string;
 c : ansichar;
 l : integer;
 p : integer;
 p1 : integer;
 p2 : integer;
 p3 : integer;
 z : integer;
 c0,c1,c2,c3: ansistring;
 v1,v2: integer;
 v3: integer;
 ts : tstringlist;
 tvar:tstringlist;
 prm:tprm_enum;
 bd : byte;
 awal_proc: integer;

label jx, px, pax, pdx, pcx, rx, ox, wx, xx, xy, zy, yz, zz;

begin
    Memo1.LoadFromFile(s);
    memo2.clear;
    memo1.BeginUpdate;
    memo2.BeginUpdate;
    bd := 0;
    v1 := $400000;
    awal_proc := 0;
    tvar:= tstringlist.Create;
    ts := tstringlist.Create;
    ts.AddObject('-', nil);
    t := memo1[0];
    c0 := AnsitoUtf8(t);
    triml(pointer(c0), c2);
    l := 1;
    z := memo1.Count-1;
    while l <= z do
    begin
wx:
{
      if l>=8367 then
      if l<=8370 then
      if l<>0 then
      if l<>0 then ;
}
      t := memo1[l];
      inc(l);
      c1 := AnsitoUtf8(t);
      if t='' then
      begin
         t := memo1[l];
         inc(l);
         c1 := AnsitoUtf8(t);
         t := '';
      end;
      triml(pointer(c1), c3);
      if (c3<>'') and (c3[1]=';') and ((c3[3]=#39) or (c3[3]='"') or (pos(ansistring('XREF'), c3, 2) > 1) or (pos(AnsiString('sub'), c3, 3)=3))then goto wx;

      if c2 = '' then
      begin
        if t='' then goto zz;
        t := '';
        goto yz;
      end;
      c := c2[1];
      if c = ';' then
      begin
         if c2[2]=' ' then
         begin
          if c2[3]='-' then goto zz;
          if c2[3]='=' then
          begin
            t := '{ ============================== }';
            goto yz;
          end;
         end;
         p := pos(AnsiString(' DATA'), c2);
         if p <> 0 then goto zz;
         p := pos(AnsiString(' sub'), c2);
         if p <> 0 then goto zz;

//         p := pos(AnsiString('"', c2);

         c0[1] := '/';
         c0 := '/'+c0;
         goto zy;
      end;
      p := pos(AnsiString('proc near'), c2);
      if p <> 0 then
      begin
         p1 := p;
         setlength(c2, p1-1);

         c0 := copy(c2, trimR(c2)-6, 7);;
         if c0[1]='_' then
         begin
            c0[1] := '$';
            t := c0;
            v2 := t.ToInteger;
            if v2 > v1 then v1 := v2;
         end;
         c2 := 'procedure '+c2+';';
         awal_proc:=memo2.Count;
         if ts.Count < 2 then
         begin
            ts.Objects[0] := pointer(awal_proc);
         end;
         t := utf8toansi(c2);
         memo2.Add(t);
         while (c3='') or (c3[1]=';') do
         begin
           t := memo1[l];
           inc(l);
           c1 := AnsitoUtf8(t);
           triml(pointer(c1), c3);
         end;
         p := pos(AnsiString('= '), c1);
         if p = 0 then
         begin
         end
         else
         begin
             p1 := p+2;
             memo2.Add('const');
             repeat
               c0 := copy(c1, 1, p1-3);
               trimr(c0);
               t := utf8toansi(c0);

               p2 := pos(AnsiString('ptr '), c1, p1);
               c2 := copy(c1, p1, (p2-p1)-1);
               delete(c1, p1, (p2-p1)+4);
               p2 := pinteger(c2)^;
               tvar.AddObject(t, pointer(p2));
               mvh(pointer(@c1[p1]));
               c1 := c1 + '; //' + c2;
               t := utf8toansi(c1);
               memo2.Add(t);

               t := memo1[l];
               inc(l);
               c1 := AnsitoUtf8(t);
               p := pos(AnsiString('= '), c1);
               p1 := p+2;
             until p=0;
             while (c1='') do
             begin
               t := memo1[l];
               inc(l);
               c1 := AnsitoUtf8(t);
             end;
             triml(pointer(c1), c3);
         end;
         memo2.Add('{$IFDEF POSIX}'#13#10'begin'#13#10'{$else}'#13#10'asm'#13#10'{$if szp=8}'#13#10);
         c2 := '{$else}';
         bd := bd or (8+1);
         prm := [];
         goto xy;
      end;
      p := pos(AnsiString('endp'), c2);
      if p <> 0 then
      begin
        tvar.Clear;
        memo2.Add('{$ifend}'#13#10'{$ENDIF}');
        bd := (bd and not 1) or 4;;

        c2 := 'end; //'+c2;
        if word(prm) and (1+2+4+8+16+32+64+128+256)<>0 then
        begin
        c0 := '_a?:';
        if prm_eax in prm then
        begin
          c0 := '_eax:';
          goto pax;
        end;
        if prm_ax in prm then
        begin
          c0 := '_ax:';
          goto pax;
        end;
        if prm_al in prm then
        begin
          c0 := '_al:';
        end;
pax:
        if prm_edx in prm then
        begin
          c0 := c0+';_edx:';
          goto pdx;
        end;
        if prm_dx in prm then
        begin
          c0 := c0+';_dx:';
          goto pdx;
        end;
        if prm_dl in prm then
        begin
          c0 := c0+';_dl:';
pdx:
        end
        else if word(prm) and (64+128+256) <> 0 then
          c0 := c0+';d?';
        if prm_ecx in prm then
        begin
          c0 := c0+';_ecx:';
          goto pcx;
        end;
        if prm_cx in prm then
        begin
          c0 := c0+';_cx:';
          goto pcx;
        end;
        if prm_cl in prm then
        begin
          c0 := c0+';_cl:';
pcx:
        end;
        t := '// ('+c0+');';
        memo2.Insert(awal_proc+1, t);
        end;
        if ret_eax in prm then
        begin
          c0 := ':eax;';
          goto rx;
        end else if ret_ax in prm then
        begin
          c0 := ':ax;';
          goto rx;
        end else if ret_al in prm then
        begin
          c0 := ':al;';
rx:
          t := memo2[awal_proc];
          delete(t, 1, 9);
          setlength(t, t.Length-1);
          t := '// function '+t+c0;
          memo2.Insert(awal_proc+1, t);
        end;
        goto xy;
      end;
      p := pos(AnsiString('retn'), c2);
      if p <> 0 then
      begin
        p := pos(AnsiString('endp'), c3);
        if p <> 0 then goto zz;
      end;

      if pos(AnsiString('j'), c2) = 1 then
      begin
        prm := prm -[ret_eax,ret_ax,ret_al];
        goto jx;
      end;
      if bd and 8 <> 0 then
      begin
        p := pos(AnsiString(', '), c2);
        if p > 1 then
        begin
          p1 := p+2;
          p := pos(AnsiString('xor'), c2);
          if p=1 then
          begin
            bd := bd and not 8;
            goto xx;
          end;
          if (word(prm) and 7=0) and (pos(AnsiString('eax'), c2, p1)=p1) then
          begin
              include(prm,prm_eax);
              goto ox;
          end else if (word(prm) and (8+16+32)=0) and (pos(AnsiString('edx'), c2, p1)=p1) then
          begin
              include(prm,prm_edx);
              goto ox;
          end else if (word(prm) and (64+128+256)=0) and (pos(AnsiString('ecx'), c2, p1)=p1) then
          begin
              include(prm,prm_ecx);
              goto ox;
          end else if (word(prm) and 7=0) and (pos(AnsiString('ax'), c2, p1)=p1) then
          begin
              include(prm,prm_ax);
              goto ox;
          end else if (word(prm) and (8+16+32)=0) and (pos(AnsiString('dx'), c2, p1)=p1) then
          begin
              include(prm,prm_dx);
              goto ox;
          end else if (word(prm) and (64+128+256)=0) and (pos(AnsiString('cx'), c2, p1)=p1) then
          begin
              include(prm,prm_cx);
              goto ox;
          end else if (word(prm) and 7=0) and (pos(AnsiString('al'), c2, p1)=p1) then
          begin
              include(prm,prm_al);
              goto ox;
          end else if (word(prm) and (8+16+32)=0) and (pos(AnsiString('dl'), c2, p1)=p1) then
          begin
              include(prm,prm_dl);
              goto ox;
          end else if (word(prm) and (64+128+256)=0) and (pos(AnsiString('cl'), c2, p1)=p1) then
          begin
              include(prm,prm_cl);
ox:
          end;
        end;
      end;
      if pos(AnsiString('set'), c2)=1 then
      begin
          if pos(AnsiString('al'), c2, 4)>4 then
          begin
            include(prm, ret_al);
            prm := prm - [ret_eax, ret_ax];
          end;
          goto xx;
      end;
      if pos(AnsiString('mov'), c2)=1 then
      begin
          if pos(AnsiString('eax,'), c2, 4)>4 then
          begin
            include(prm, ret_eax);
            prm := prm - [ret_ax, ret_al];
            goto px;
          end else
          if pos(AnsiString('ax,'), c2, 4)>4 then
          begin
            include(prm, ret_ax);
            prm := prm - [ret_eax, ret_al];
            goto px;
          end else
          if pos(AnsiString('al,'), c2, 4)>4 then
          begin
            include(prm, ret_al);
            prm := prm - [ret_eax, ret_ax];
px:
            goto xx;
          end;
      end;

// =================================================
//
//      for $1000
//
// =================================================
jx:
      p := pos(AnsiString('short '), c2);
      if p <> 0 then delete(c2, p, 6);

      p := pos(AnsiString('def_'), c2);
      if p <> 0 then
      begin
            p1 := p;
            delete(c2, p1, 1);
            c2[p1] := '@';
            c2[p1+1] := '@';
            goto xx;
      end;
      p := pos(AnsiString('loc_'), c2);
      if p <> 0 then
      begin
            p1 := p;
            delete(c2, p1, 1);
            c2[p1] := '@';
            c2[p1+1] := '@';
            goto xx;
      end;
      p := pos(AnsiString('locret_'), c2);
      if p <> 0 then
      begin
            p1 := p;
            delete(c2, p1, 4);
            c2[p1] := '@';
            c2[p1+1] := '@';
            goto xx;
      end;

      p := pos(AnsiString('], '), c2);
      if p <> 0 then
      begin
           p1 := p;
           if c2[p1+3] in ['0'..'9'] then
           mkd(c2, p1, tvar);
      end;

xx:
      if c2[1] = '@' then
      begin                             // @@_410000
        if (pos(AnsiString('XREF'), c2)<>0) and (c2[10] = ':') then
        setlength(c2, 10);

      end else
      begin
        p := pos(AnsiString(' ; '), c2);
        if p > 0 then
        begin
         p1 := p+1;
         if system.ansistrings.strpos(pansichar(@c2[p1]), 'XREF') <> nil then
         begin
           setlength(c2, p1-1);
           trimr(c2);
         end
         else if c2[p1+2]<>'{' then
         begin
            c2[p1] := '/';
            insert('/', c2, p1);
         end;
        end;
        p := pos(AnsiString('db '''), c2);
        if p <> 0 then
        begin
          p1 := p;
          delete(c2, p1, 2);
          p2 := pos(AnsiString(''''), c2, p1+2);
//          if p2 <= p1 then
//          asm nop end;
          dec(p2, p1+1);

          p2 := ((p2 + 3) and $7C)-1;
          c0 := p2.ToString;
          if p2<10 then c0 := ' '+c0;
          
          c0 := ': array[0..'+c0+'] of ansichar =';
          insert(c0, c2, p1);
          p := pos(AnsiString(',0'), c2);
          if p > 0 then
          begin
            p1 := p;
            delete(c2, p1, 2);
            insert('#0;', c2, p1);
          end;

          if bd and 4 <> 0 then
          begin
            bd := bd and not 4;
            memo2.add('const');
          end;
          if (pos(AnsiString('db    0'), c3)=1) then
          begin
           repeat
             t := utf8toansi(c2);
             memo2.Add(t);
             c2 := '// '+c3;
             t := memo1[l];
             inc(l);
             c1 := AnsitoUtf8(t);
             triml(pointer(c1), c3);
             inc(p2);
           until pos(AnsiString('db    0'), c3)<>1;
           goto xy;
          end;
        end else ;
{        if pos(AnsiString(': pointer '), c2) <> 0 then
          c2 := c2+';'; }
        c2 := '  '+c2;
      end;
xy:
      c0 := c2;
zy:
      t := utf8toansi(c0);
yz:
      memo2.Add(t);
zz:
      c0 := c1;
      c2 := c3;
    end;
    p1 := integer(ts.Objects[0])-1;
    for l := 1 to ts.Count-1 do
    begin
      t := ts.Strings[l];
      t[1] := '_';
      t := 'procedure sub'+t+';forward;';
      memo2.Insert(p1, t);
      inc(p1);
    end;
    memo2.EndUpdate;
    memo1.EndUpdate;
    ts.Free;
    tvar.free;
end;

procedure TForm1.Button1Click(Sender: TObject);
type
 prm_enum=(prm_nil,
prm_al,prm_ax,prm_eax,
prm_dl,prm_dx,prm_edx,
prm_cl,prm_cx,prm_ecx,
ret_al,ret_ax,ret_eax);
 tprm_enum=set of prm_enum;
var
 s : string;
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
    Memo2.LockUndo;
    ASM_2_PAS(Memo1.Lines,Memo2.Lines,s);
    memo2.UnlockUndo;
end;

procedure TForm1.Button2Click(Sender: TObject);
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

procedure TForm1.FormShow(Sender: TObject);
begin
  Memo2.UseCodeFolding := true;
end;

procedure TForm1.Memo2GutterGetText(Sender: TObject; aLine: Integer;
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

end.
