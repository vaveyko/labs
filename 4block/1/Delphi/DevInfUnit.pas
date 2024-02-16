unit DevInfUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TDeveloperForm = class(TForm)
    InfLabel: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DeveloperForm: TDeveloperForm;

implementation

{$R *.dfm}

procedure TDeveloperForm.FormCreate(Sender: TObject);
begin
    InfLabel.Caption := 'Студент группы 351005, Захвей Иван'
end;

end.
