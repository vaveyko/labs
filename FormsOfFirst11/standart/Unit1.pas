unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtDlgs, Vcl.Menus, Vcl.StdCtrls,
  Unit2, Unit3;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N4: TMenuItem;
    N3: TMenuItem;
    N7: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    PopupMenu1: TPopupMenu;
    OpenTextFileDialog1: TOpenTextFileDialog;
    SaveTextFileDialog1: TSaveTextFileDialog;
    CheckButton: TButton;
    InfLabel: TLabel;
    Edit1: TEdit;
    procedure N5Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure N7Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Const
    INFTEXT = '1232114';

var
  Form1: TForm1;
  IsSaved: Boolean = True;

implementation

{$R *.dfm}

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
    if N4.Enabled And Not IsSaved then
        case Application.MessageBox('Сохранить данные перед выходом?', 'Выход', MB_YESNOCANCEL + MB_ICONQUESTION + MB_DEFBUTTON3) of
            IDYES :
            Begin
                N4.Click;
                CanClose := True;
            End;
            IDNO : CanClose := True;
            IDCANCEL : CanClose := False;
        end
    Else
        Case Application.MessageBox('Вы точно хотите выйти?', 'Выход',
          MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2) Of
            IDYES:
                CanClose := True;
            IDNO:
                CanClose := False;
        End;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
    InfLabel.Caption := INFTEXT;
end;

procedure TForm1.N5Click(Sender: TObject);
Var
    Form2: TForm2;
begin
    Form2 := TForm2.Create(Self);
    Form2.ShowModal;
    Form2.Free;
end;

procedure TForm1.N6Click(Sender: TObject);
Var
    Form3: TForm3;
begin
    Form3 := TForm3.Create(Self);
    Form3.ShowModal;
    Form3.Free;
end;

procedure TForm1.N7Click(Sender: TObject);
begin
    Form1.Close;
end;

end.
