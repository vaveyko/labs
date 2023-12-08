program Project1;

uses
  Vcl.Forms,
  Lab_2_4 in 'Lab_2_4.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
