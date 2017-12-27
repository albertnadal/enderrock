unit Menu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TForm2 = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Button1: TButton;
    procedure Label1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses Estructures;

{$R *.dfm}

procedure TForm2.Label1Click(Sender: TObject);
begin
        Application.terminate;
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
form1:= TForm1.Create(nil);
form1.Visible:=true;
form1.Update;
form1.Show;
end;

end.
