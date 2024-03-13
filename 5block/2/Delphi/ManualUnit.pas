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
    TextInf = '1. Ёлементы дерева должны быть от -99999 до 99999 ' + #13#10 +
      '2. Ёлементы не могут повтор€тьс€' + #13#10 +
      '3.  расным цветом подсвечиветс€ элемент выбранный элемент в массиве' +
      #13#10 + '4. „тобы выбрать другой элемент, просто кликните по нему в таблице';

Var
    ManualForm: TManualForm;

Implementation

{$R *.dfm}

Procedure TManualForm.FormCreate(Sender: TObject);
Begin
    ManualLabel.Caption := TextInf;
End;

End.
