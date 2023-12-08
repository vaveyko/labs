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
    TextInf = '1. Числа должны быть в диапазоне' + #13#10 +
           'от 1 до 999 включая концы' + #13#10 +
           '2. Треугольник с введенными сторонами' + #13#10 +
           'должен существовать' + #13#10 +
           '3. В файле должно быть три длинны' + #13#10 +
           'сторон разделенных пробелом';

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.FormCreate(Sender: TObject);
begin
    Label1.Caption := TextInf;
end;
end.
