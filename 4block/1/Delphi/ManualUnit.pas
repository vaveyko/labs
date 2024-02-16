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
    TextInf = '1) Имя ограничено 20 символами '
              + #13#10 +
              '2) Кол-во и цена могут принимать значения от 0 до 2000000000'
              + #13#10 +
              '3) Возраст принимает значения от 1 до 120'
              + #13#10 +
              '4) Чтобы внесенные изменения остались, требуется сохраниться';

var
  ManualForm: TManualForm;

implementation

{$R *.dfm}

procedure TManualForm.FormCreate(Sender: TObject);
begin
    ManualLabel.Caption := TextInf;
end;
end.
