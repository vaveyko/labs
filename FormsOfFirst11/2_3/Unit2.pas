unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.DBCtrls;

type
  TForm2 = class(TForm)
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Const
    TextInf = '1. Элементы матрицы должны быть в диапазоне '
              + 'от -21474836 до 21474836 включичельно'
              + #13#10 + '2. Размер матрицы должен находиться'
              + ' в границах от 1 до 100'
              + #13#10 + '3. В файле должен быть размер матрицы '
              + 'и его элементы как в матрице';

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.FormCreate(Sender: TObject);
begin
    Label1.Caption := TextInf;
end;
end.
