program Project4;

uses
  Vcl.Forms,
  MainUnit in 'MainUnit.pas' {ManeForm},
  ManualUnit in 'ManualUnit.pas' {ManualForm},
  DevInfUnit in 'DevInfUnit.pas' {DeveloperForm},
  AddRecUnit in 'AddRecUnit.pas' {AddRecForm},
  ChangeRecUnit in 'ChangeRecUnit.pas' {ChangeRecForm},
  BackEndUnit in 'BackEndUnit.pas',
  FindRecUnit in 'FindRecUnit.pas' {FindRecForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TManeForm, ManeForm);
  Application.CreateForm(TManualForm, ManualForm);
  Application.CreateForm(TDeveloperForm, DeveloperForm);
  Application.CreateForm(TAddRecForm, AddRecForm);
  Application.CreateForm(TChangeRecForm, ChangeRecForm);
  Application.CreateForm(TFindRecForm, FindRecForm);
  Application.Run;
end.
