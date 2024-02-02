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
    TextInf = '1. Элементы матрицы должны быть в диапазоне '
              + 'от -70 до 70 включичельно'
              + #13#10 + '2. Размер матрицы должен находиться'
              + ' в границах от 1 до 5'
              + #13#10 + '3. В файле должен быть размер матрицы '
              + 'и его элементы как в матрице';

var
  ManualForm: TManualForm;

implementation

{$R *.dfm}

procedure TManualForm.FormCreate(Sender: TObject);
begin
    ManualLabel.Caption := TextInf;
end;
end.
