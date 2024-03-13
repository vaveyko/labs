program Project52;

uses
  Vcl.Forms,
  MainUnit in 'MainUnit.pas' {MainForm},
  TreeUnit in 'TreeUnit.pas',
  BackUnit in 'BackUnit.pas',
  DevInfUnit in 'DevInfUnit.pas' {DeveloperForm},
  ManualUnit in 'ManualUnit.pas' {ManualForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TDeveloperForm, DeveloperForm);
  Application.CreateForm(TManualForm, ManualForm);
  Application.Run;
end.
