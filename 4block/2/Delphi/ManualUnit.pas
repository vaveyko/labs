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
    TextInf = '1. �������� ������� ������ ���� � ��������� ' +
      '�� -70 �� 70 ������������' + #13#10 +
      '2. ������ ������� ������ ����������' + ' � �������� �� 1 �� 5' + #13#10 +
      '3. � ����� ������ ���� ������ ������� ' + '� ��� �������� ��� � �������';

Var
    ManualForm: TManualForm;

Implementation

{$R *.dfm}

Procedure TManualForm.FormCreate(Sender: TObject);
Begin
    ManualLabel.Caption := TextInf;
End;

End.
