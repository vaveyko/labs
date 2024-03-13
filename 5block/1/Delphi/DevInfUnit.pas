Unit DevInfUnit;

Interface

Uses
    Winapi.Windows, Winapi.Messages, System.Classes, Vcl.Forms,
    Vcl.StdCtrls, Vcl.Dialogs, Vcl.Controls;

Type
    TDeveloperForm = Class(TForm)
        InfLabel: TLabel;
        Procedure FormCreate(Sender: TObject);
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Var
    DeveloperForm: TDeveloperForm;

Implementation

{$R *.dfm}

Procedure TDeveloperForm.FormCreate(Sender: TObject);
Begin
    InfLabel.Caption := 'Студент группы 351005, Захвей Иван'
End;

End.
