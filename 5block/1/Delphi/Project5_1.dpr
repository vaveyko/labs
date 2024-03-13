program Project5_1;

uses
  Vcl.Forms,
  MainUnit in 'MainUnit.pas' {ManeForm},
  ManualUnit in 'ManualUnit.pas' {ManualForm},
  DevInfUnit in 'DevInfUnit.pas' {DeveloperForm},
  BackUnit in 'BackUnit.pas',
  AddUnit in 'AddUnit.pas' {AddForm},
  LinkedListUnit in 'LinkedListUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TManeForm, ManeForm);
  Application.CreateForm(TManualForm, ManualForm);
  Application.CreateForm(TDeveloperForm, DeveloperForm);
  Application.CreateForm(TAddForm, AddForm);
  Application.Run;
end.
