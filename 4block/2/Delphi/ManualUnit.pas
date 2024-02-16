Unit ManualUnit;

Interface

Uses
    Winapi.Windows, Winapi.Messages, System.Classes, Vcl.Forms,
    Vcl.StdCtrls, Vcl.Controls;

Type
    TManualForm = Class(TForm)
        ManualLabel: TLabel;
        Procedure FormCreate(Sender: TObject);
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Const
    TextInf = '1. Элементы матрицы должны быть в диапазоне ' +
      'от -70 до 70 включичельно' + #13#10 +
      '2. Размер матрицы должен находиться' + ' в границах от 1 до 5' + #13#10 +
      '3. В файле должен быть размер матрицы ' + 'и его элементы как в матрице';

Var
    ManualForm: TManualForm;

Implementation

{$R *.dfm}

Procedure TManualForm.FormCreate(Sender: TObject);
Begin
    ManualLabel.Caption := TextInf;
End;

End.
