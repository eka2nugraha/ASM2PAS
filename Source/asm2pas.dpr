program asm2pas;
//
//
//
uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  AnsiStringList in '..\myUnit\AnsiStrings\AnsiStringList.pas';

{$R *.res}

begin
{TODO: add cli mode}
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
