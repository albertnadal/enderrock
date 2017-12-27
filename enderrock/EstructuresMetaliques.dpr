program EstructuresMetaliques;

uses
  Forms,
  Estructures in 'Estructures.pas' {Form1},
  TractamentFigures in 'TractamentFigures.pas',
  Entrada in 'Entrada.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Enderrock!';
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
