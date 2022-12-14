program asm2pas;
//
//
//
uses
  Windows,
  Classes,
  sysutils,
  ansistrings,
  Vcl.Forms,
  System.IniFiles,
  Vcl.Themes,
  Vcl.Styles,
  tlhelp32,
  AnsiStringList in '..\myUnit\AnsiStrings\AnsiStringList.pas',
  Unit1 in 'Unit1.pas' {Form1},
  Unit3 in 'Unit3.pas' {Form3},
  Unit5 in 'Unit5.pas' {EditorOpt},
  Unit6 in 'Unit6.pas' {Form6};

{$R *.res}
function getParentPID():dword;
var
h : tHandle;
pe: tPROCESSENTRY32;
pid:dword;
begin
    result := 0;
    pid := GetCurrentProcessId;
    pe.dwSize:= sizeof(tPROCESSENTRY32);
    h := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    if(Process32First(h, pe)) then
    repeat
       if (pe.th32ProcessID = pid) then
       begin
            result := pe.th32ParentProcessID;
            break;
       end;
    until not (Process32Next(h, pe));
    CloseHandle(h);
end;
procedure writeo(o:thandle; s:pansichar);
var
vNumberOfCharsWritten:dword;
begin
  WriteConsoleA(o, s, ansistrings.strlen(s), vNumberOfCharsWritten, nil);
end;
procedure dpf(const d:string; var f:string);
begin
  if d <> '' then
  begin
    insert('\',f,1);
    insert(d, f, 1);
  end;
end;
procedure ASM_PAS(const f, fn:string);
var
 d : ansistring;
 m1: TAnsiStringListSimple;
begin
  m1 := TAnsiStringListSimple.Create;
  m1.LoadFromFile(f);
  d := m1.Text;
  m1 := ASM_2_PAS(m1, d);
  m1.SaveToFile(fn);
  m1.free;
end;
procedure duru(const src, indir, outdir:string; opt:byte);
var
  t:TWIN32FindDataW;
  h:thandle;
  f,fn:string;
  p:pwidechar;
  i:integer;
begin
  if src='' then
    f := '*.asm'
  else
  begin
    f := copy(src, 1, length(src));
    p := GetFileExtStr2(f);
    if p^=#0 then
    begin
      p^ := '.';
      p[1] := 'a';
      p[2] := 's';
      p[3] := 'm';
    end;
  end;
  dpf(indir, f);
  writeln(indir);
  h := findfirstfilew(pointer(f), t);
  if h <> INVALID_HANDLE_VALUE then
  begin
      repeat
        if (t.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY<>0) then continue;
        setstring(f, t.cFileName, strlen(t.cFileName));
        fn := copy(f, 1, length(f));
        i := (GetFileExtStr2(fn)-pointer(fn));
        setlength(fn, length(fn)+1);
        p := pointer(fn);
        p[i] := '.';
        p[i+1] := 'p';
        p[i+2] := 'a';
        p[i+3] := 's';
        p[i+4] := 'm';
        dpf(outdir, fn);
        dpf(indir, f);
        writeln(f,' -> ',fn);
        ASM_PAS(f, fn);
      until not FindNextFileW(h, t);
      windows.FindClose(h);
  end;
  if opt and 1 <> 0 then
  begin
    f := '*.*';
    dpf(indir, f);
    h := findfirstfilew(pointer(f), t);
    if h <> INVALID_HANDLE_VALUE then
    begin
      repeat
        if (t.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY=0) or (t.cFileName[0] = '.') then continue;
        setstring(f, t.cFileName, strlen(t.cFileName));
        fn := f;
        dpf(indir, f);
        dpf(outdir, fn);
        duru(src, f, fn, opt);
      until not FindNextFileW(h, t);
      windows.FindClose(h);
    end;
  end;
end;

function setdir(const indir,s:string):string;
var
 d,k,j:string;
 p:pwidechar;
 i:integer;
begin
  d := indir;
  k := s;
  if k='' then k := 'DELIST_';
  j := d;
  if j='' then j := getcurrentdir;
  p := strrscan(pwidechar(j), '\');
  if p= nil then p := strrscan(pwidechar(j), '/');
  if p<>nil then
  begin
     i := p-pointer(j);
     if d='' then
     begin
      d := copy(j, i+1, length(j));
      insert(k, d, 2);
      insert('..', d, 1);
     end
     else
     insert(k, d, i+2);
  end
  else
  begin
    insert(k, d, 1);
    insert('..\', d, 1);
  end;
  result := d;
end;

function duro:boolean;
var
// o: thandle;
// b: _CONSOLE_SCREEN_BUFFER_INFO;
// x: word;
 indir,outdir:string;
 c,cnt:integer;
 j,k:integer;
 seg:byte;
 s:string;
 opt:byte;
begin
  cnt := paramcount;
  result := cnt>0;
  if not result then exit;

  result := AllocConsole;
{
// result := attachconsole(ATTACH_PARENT_PROCESS);
  if not result then AllocConsole;
  writeln;
  o := GetStdHandle(STD_OUTPUT_HANDLE);
  GetConsoleScreenBufferInfo(o, b);
  x := b.wAttributes;
  writeo(o,'ASM2PAS : (c) 1444H, ');
  SetConsoleTextAttribute(o, $70);
  writeo(o,'ubur-ubur');
  SetConsoleTextAttribute(o, x);
  writeln;
  //  readln;
}
  indir := '';
  outdir := '';
  opt := 0;
  c := 1;
  repeat
    s := paramstr(c);
    inc(c);
    case s[1] of
    '-','/':
       case ord(s[2]) or $20 of
         ord('d'),ord('i'):
          begin
            if length(s) > 2 then
            begin
              delete(s,1,2);
            end else
            begin
              s := paramstr(c);
              inc(c);
            end;
            indir := s;
            writeln('indir :', indir);
          end;
         ord('o'):
          begin
            if length(s) > 2 then
              delete(s,1,2)
            else
            begin
              s := paramstr(c);
              inc(c);
            end;
            if s<>'' then
            if s[1] = '~' then
            begin
              delete(s,1,1);
              s := setdir(indir, s);
            end;
            outdir := s;
            writeln('outdir :', outdir);
          end;
         ord('r'): begin
                      if length(s)=2 then
                        opt := opt or 3
                      else
                      if length(s)=3 then
                      case ord(s[3]) or $20 of
                      ord('-') or $20 : opt := opt and not 1;
                      ord('r') : opt := opt or 3;
                      ord('s') : opt := (opt and not 2) or 1;
                      end;
                      writeln('opt : ', opt and 1);
                   end;
         ord('s'): begin
                    seg := ord(s[2]);
                    if (seg>=ord('b')) and (seg<=ord('d')) then
                    begin
                      delete(s, 1, 2);
                      if s='' then
                      begin
                         s := paramstr(c);
                         inc(c);
                      end;
                      if (s<>'') then
                      if (s[1]='=') then
                      begin
                        delete(s, 1, 1);
                        if s='' then
                        begin
                          s := paramstr(c);
                          inc(c);
                        end;
                        case seg of
                        ord('b') : BssSeg := s;
                        ord('c') : CodeSeg := s;
                        ord('d') : DataSeg := s;
                        end;
                        continue;
                      end;
                    end;

                   end;
         else

           continue;
       end;
    else
      opt := opt or $40;
      writeln(s);
      k := GetFileName(s)-pointer(s);
      if k <> 0 then
      begin
         j := k;
         indir := copy(s, 1, k-1);
         delete(s, 1, j);
      end;
      duru(s, indir, outdir, opt);
    end;
  until c>cnt;
  if (opt and $40=0) and (opt and 1 <> 0) then duru('', indir, outdir, opt or 1);

//  if result then
//  begin
//    write(#13#10'press [ENTER] to exit ... ');
//    readln;
//  end;
{
  closehandle(o);
}
  result := true;
end;

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  with OpenIni do
  begin
    BSSSeg := ReadString('S','B','');
    CodeSeg := ReadString('S','C','');
    DataSeg := ReadString('S','D','');
    free;
  end;
  if duro then exit;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
