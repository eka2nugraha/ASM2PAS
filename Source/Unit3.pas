unit Unit3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm3 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    RadioGroup1: TRadioGroup;
    Edit1: TEdit;
    RadioGroup2: TRadioGroup;
    RadioGroup3: TRadioGroup;
    Edit2: TEdit;
    Edit3: TEdit;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

procedure TForm3.Button1Click(Sender: TObject);
begin
  if (RadioGroup1.ItemIndex=1) and (Edit1.Text='') then
  begin
   edit1.SetFocus;
   exit;
  end;
  if (RadioGroup2.ItemIndex=1) and (Edit2.Text='') then
  begin
   edit2.SetFocus;
   exit;
  end;
  if (RadioGroup3.ItemIndex=1) and (Edit3.Text='') then
  begin
   edit3.SetFocus;
   exit;
  end;
  modalresult := mrOK;
end;

end.
