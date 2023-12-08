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
    Label1: TLabel;
    Edit2: TEdit;
    procedure N5Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure N7Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure CheckButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Const
    INFTEXT = 'Вычислить произведение' + #13#10
    +'Р = 2 * 4 * 6 * 8 * ... * 2n для заданного n.';
    DIGITS = ['0' .. '9'];
    VOID = #0;
    BACKSPACE = #8;
    MIN_NUMB = 1;
    MAX_NUMB = 15;

var
  Form1: TForm1;
  IsSaved: Boolean = True;

implementation

{$R *.dfm}

Function MultiOddNum(Num: Integer): Int64;
Var
    I: Integer;
    Multi: Int64;
Begin
    Multi := 2;
    For I := 2 to Num do
        Multi := Multi * 2 * I;
    MultiOddNum := Multi;
End;

procedure TForm1.CheckButtonClick(Sender: TObject);
begin
    Edit2.Text := IntToStr(MultiOddNum(StrToInt(Edit1.Text)));
end;

procedure TForm1.Edit1Change(Sender: TObject);
begin
    if Edit1.Text = '' then
        CheckButton.Enabled := False
    Else
        CheckButton.Enabled := True;
end;

procedure TForm1.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    If ((SsShift In Shift) Or (SsCtrl In Shift)) And ((Key = VK_RIGHT) Or (Key = VK_LEFT)) Then
        Key := Key
    Else if (SsShift In Shift) Or (SsCtrl In Shift) then
        Key := 0;
    If (Key = VK_DOWN) And (CheckButton.Enabled) Then
        CheckButton.SetFocus;
    If (Key = VK_RETURN) And CheckButton.Enabled Then
        CheckButton.Click;
end;

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
    if (Edit1.SelStart = 0) And (Key = '0') then
        Key := VOID;
    If CharInSet(Key, DIGITS) then
    Begin
        if StrToInt(Edit1.Text + Key) > MAX_NUMB then
            Key := VOID;
    End
    Else
        if Not (Key = BACKSPACE)  then
            Key := VOID;
end;

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
