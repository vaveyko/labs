Unit Unit1;

Interface

Uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
    System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtDlgs, Vcl.Menus, Vcl.StdCtrls,
    Unit2, Unit3;

Type
    TForm1 = Class(TForm)
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
        Edit2: TEdit;
        Label1: TLabel;
        Label2: TLabel;
        Procedure N5Click(Sender: TObject);
        Procedure N6Click(Sender: TObject);
        Procedure FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
        Procedure N7Click(Sender: TObject);
        Procedure FormCreate(Sender: TObject);
        Procedure N2Click(Sender: TObject);
        Procedure N4Click(Sender: TObject);
        Procedure Edit1Change(Sender: TObject);
        Procedure Edit1KeyPress(Sender: TObject; Var Key: Char);
        Procedure Edit1KeyDown(Sender: TObject; Var Key: Word;
          Shift: TShiftState);
        Procedure CheckButtonClick(Sender: TObject);
        Procedure CheckButtonExit(Sender: TObject);
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Type
    ERRORS_CODE = (SUCCESS, INCORRECT_DATA_FILE, A_LOT_OF_DATA_FILE,
      OUT_OF_BORDER);

Const
    INFTEXT = 'Ввести натуральное число n.' + #13#10 +
      'Подсчитать количество цифр в этом числе.';
    DIGITS = ['0' .. '9'];
    VOID = #0;
    BACKSPACE = #8;
    MAX_NUMB = 999999999;
    MIN_NUMB = 0;
    ERRORS: Array [ERRORS_CODE] Of String = ('Successfull',
      'Данные в файле не корректные', 'В файле должно быть только 1 число',
      'Числа должны быть в диапазоне [0, 999999999]');

Var
    Form1: TForm1;
    IsSaved: Boolean = True;

Implementation

{$R *.dfm}

Function FoundLenNum(Number: Integer): Integer;
Var
    Len: Integer;
Begin
    Len := 0;
    While Number > 0 Do
    Begin
        Inc(Len);
        Number := Number Div 10;
    End;
    FoundLenNum := Len;
End;

Procedure TForm1.CheckButtonClick(Sender: TObject);
Begin
    Edit2.Text := IntToStr(FoundLenNum(StrToInt(Edit1.Text)));
    N4.Enabled := True;
    IsSaved := False;
End;

Procedure TForm1.CheckButtonExit(Sender: TObject);
Begin
    Edit1.SetFocus;
End;

Procedure TForm1.Edit1Change(Sender: TObject);
Begin
    Edit2.Text := '';
    N4.Enabled := False;
    If Edit1.Text = '' Then
        CheckButton.Enabled := False
    Else
        CheckButton.Enabled := True;
End;

Procedure TForm1.Edit1KeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
    If ((SsShift In Shift) Or (SsCtrl In Shift)) And
      ((Key = VK_RIGHT) Or (Key = VK_LEFT)) Then
        Key := Key
    Else If (SsShift In Shift) Or (SsCtrl In Shift) Then
        Key := 0;
    If Key = VK_DELETE Then
        Key := 0;
    If ((Key = VK_DOWN) Or (Key = VK_UP)) And CheckButton.Enabled Then
        CheckButton.SetFocus;
    if (Key = VK_RIGHT) And (Edit1.SelStart = Length(Edit1.Text)) And CheckButton.Enabled then
        CheckButton.SetFocus;
    If (Key = VK_RETURN) And Not(Edit1.Text = '') Then
        CheckButton.Click;
End;

Procedure TForm1.Edit1KeyPress(Sender: TObject; Var Key: Char);
Begin
    If (Edit1.SelStart = 0) And (Key = '0') And (Length(Edit1.Text) > 0) And Not (Edit1.SelLength = Length(Edit1.Text)) Then
        Key := VOID;
    If (Edit1.Text = '0') And (Key = '0') Then
        Key := VOID;
    If Not((CharInSet(Key, DIGITS)) Or (Key = BACKSPACE)) Then
        Key := VOID;
    If Edit1.SelLength = 0 Then
    Begin
        If (Key = BACKSPACE) And (Edit1.SelStart = 1) And
          (Length(Edit1.Text) > 1) And
          (Edit1.Text[Edit1.SelStart + 1] = '0') Then
            Key := VOID;
    End
    Else If (Length(Edit1.Text) > Edit1.SelLength) And
      (Edit1.Text[Edit1.SelLength + 1] = '0') And (Key = BACKSPACE) Then
        Key := VOID;
End;

Procedure TForm1.FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
Begin
    If N4.Enabled And Not IsSaved Then
        Case Application.MessageBox('Сохранить данные перед выходом?', 'Выход',
          MB_YESNOCANCEL + MB_ICONQUESTION + MB_DEFBUTTON3) Of
            IDYES:
                Begin
                    N4.Click;
                    CanClose := True;
                End;
            IDNO:
                CanClose := True;
            IDCANCEL:
                CanClose := False;
        End
    Else
        Case Application.MessageBox('Вы точно хотите выйти?', 'Выход',
          MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2) Of
            IDYES:
                CanClose := True;
            IDNO:
                CanClose := False;
        End;
End;

Procedure TForm1.FormCreate(Sender: TObject);
Begin
    InfLabel.Caption := INFTEXT;
End;

Function ReadOneFromFile(Var Numb: Integer; Var MyFile: TextFile): ERRORS_CODE;
Var
    Err: ERRORS_CODE;
    IsCorrect: Boolean;
    NumbInt: Integer;
Begin
    Err := SUCCESS;
    NumbInt := 0;
    IsCorrect := True;
    Try
        Read(MyFile, NumbInt);
    Except
        Err := INCORRECT_DATA_FILE;
        IsCorrect := False;
    End;
    If IsCorrect Then
        If (NumbInt > MAX_NUMB) Or (NumbInt < MIN_NUMB) Then
            Err := OUT_OF_BORDER
        Else
            Numb := NumbInt;
    ReadOneFromFile := Err;
End;

Procedure TForm1.N2Click(Sender: TObject);
Var
    InfFile: TextFile;
    Number: Integer;
    Err: ERRORS_CODE;
Begin
    Err := SUCCESS;
    If OpenTextFileDialog1.Execute() Then
    Begin
        AssignFile(InfFile, OpenTextFileDialog1.FileName);
        Reset(InfFile);
        Err := ReadOneFromFile(Number, InfFile);
        If Err = SUCCESS Then
        Begin
            If Not EoF(InfFile) Then
                Err := A_LOT_OF_DATA_FILE;
        End;
        If Err = SUCCESS Then
        Begin
            Edit1.Text := IntToStr(Number);
        End
        Else
            Application.MessageBox(PChar(ERRORS[Err]), 'Ошибочка вышла',
              MB_OK + MB_ICONERROR);
        CloseFile(InfFile);
    End;
End;

Procedure TForm1.N4Click(Sender: TObject);
Var
    OutFile: TextFile;
Begin
    If SaveTextFileDialog1.Execute() Then
    Begin
        AssignFile(OutFile, SaveTextFileDialog1.FileName);
        Rewrite(OutFile);
        Write(OutFile, 'Длинна числа ' + Edit1.Text + ': ');
        Write(OutFile, Edit2.Text);
        CloseFile(OutFile);
        IsSaved := True;
    End;
End;

Procedure TForm1.N5Click(Sender: TObject);
Var
    Form2: TForm2;
Begin
    Form2 := TForm2.Create(Self);
    Form2.ShowModal;
    Form2.Free;
End;

Procedure TForm1.N6Click(Sender: TObject);
Var
    Form3: TForm3;
Begin
    Form3 := TForm3.Create(Self);
    Form3.ShowModal;
    Form3.Free;
End;

Procedure TForm1.N7Click(Sender: TObject);
Begin
    Form1.Close;
End;

End.
