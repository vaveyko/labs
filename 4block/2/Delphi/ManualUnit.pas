unit ManualUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.DBCtrls;

type
  TManualForm = class(TForm)
    ManualLabel: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Const
    TextInf = '1. �������� ������� ������ ���� � ��������� '
              + '�� -70 �� 70 ������������'
              + #13#10 + '2. ������ ������� ������ ����������'
              + ' � �������� �� 1 �� 5'
              + #13#10 + '3. � ����� ������ ���� ������ ������� '
              + '� ��� �������� ��� � �������';

var
  ManualForm: TManualForm;

implementation

{$R *.dfm}

procedure TManualForm.FormCreate(Sender: TObject);
begin
    ManualLabel.Caption := TextInf;
end;
end.
