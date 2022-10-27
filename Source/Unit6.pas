unit Unit6;
{$H+,O+,W-,C-}
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ToolWin, Vcl.ExtCtrls,
  SynEdit, Vcl.Menus;

type
  TForm6 = class(TForm)
    SynEdit: TSynEdit;
    PageControl1: TPageControl;
    TreeView1: TTreeView;
    TabSheet1: TTabSheet;
    Panel1: TPanel;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    MM: TMainMenu;
    File1: TMenuItem;
    eXit1: TMenuItem;
    ToolBar2: TToolBar;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    procedure FormShow(Sender: TObject);
    procedure eXit1Click(Sender: TObject);
  private
    { Private declarations }
    procedure CMShowingChanged(var Message: TMessage); message CM_SHOWINGCHANGED;
  public
    { Public declarations }
  end;

var
  Form6: TForm6;

implementation
uses Unit1;
{$R *.dfm}

procedure TForm6.eXit1Click(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TForm6.FormShow(Sender: TObject);
begin
    TreeView1.Items[3].Selected := true;
    SynEdit.GotoLineAndCenter(12);
end;

procedure TForm6.CMShowingChanged(var Message: TMessage);
begin
     if StyleName='' then ;
//     Self.StyleName :=
inherited;
end;

end.
