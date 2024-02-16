program Project4;

uses
  Vcl.Forms,
  MainUnit in 'MainUnit.pas' {ManeForm},
  ManualUnit in 'ManualUnit.pas' {ManualForm},
  DevInfUnit in 'DevInfUnit.pas' {DeveloperForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TManeForm, ManeForm);
  Application.CreateForm(TManualForm, ManualForm);
  Application.CreateForm(TDeveloperForm, DeveloperForm);
  Application.Run;
end.
