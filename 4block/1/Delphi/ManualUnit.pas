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
    TextInf = '1) ��� ���������� 20 ��������� '
              + #13#10 +
              '2) ���-�� � ���� ����� ��������� �������� �� 0 �� 2000000000'
              + #13#10 +
              '3) ������� ��������� �������� �� 1 �� 120'
              + #13#10 +
              '4) ����� ��������� ��������� ��������, ��������� �����������';

var
  ManualForm: TManualForm;

implementation

{$R *.dfm}

procedure TManualForm.FormCreate(Sender: TObject);
begin
    ManualLabel.Caption := TextInf;
end;
end.
