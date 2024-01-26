Unit Unit1;

Interface

Uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
    System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ExtCtrls, Vcl.StdCtrls,
    Vcl.Imaging.Pngimage, Vcl.ExtDlgs,
    Unit2, Unit3;

Type
    TForm1 = Class(TForm)
        MainMenu1: TMainMenu;
        N1: TMenuItem;
        N2: TMenuItem;
        N4: TMenuItem;
        N5: TMenuItem;
        N6: TMenuItem;
        Edit1: TEdit;
        Label1: TLabel;
        Image1: TImage;
        Edit2: TEdit;
        Edit3: TEdit;
        Button1: TButton;
        Edit4: TEdit;
        PopupMenu1: TPopupMenu;
        OpenTextFileDialog1: TOpenTextFileDialog;
        SaveTextFileDialog1: TSaveTextFileDialog;
        N3: TMenuItem;
        N7: TMenuItem;
        Procedure Button1Click(Sender: TObject);
        Procedure CheckEdit(Sender: TObject);
        Procedure Edit1KeyDown(Sender: TObject; Var Key: Word;
          Shift: TShiftState);
        Procedure Edit3KeyDown(Sender: TObject; Var Key: Word;
          Shift: TShiftState);
        Procedure Edit2KeyDown(Sender: TObject; Var Key: Word;
          Shift: TShiftState);
        Procedure Edit3Change(Sender: TObject);
        Procedure Edit1Change(Sender: TObject);
        Procedure Edit2Change(Sender: TObject);
        Procedure Edit2KeyPress(Sender: TObject; Var Key: Char);
        Procedure Edit3KeyPress(Sender: TObject; Var Key: Char);
        Procedure Edit1KeyPress(Sender: TObject; Var Key: Char);
        Procedure FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
        Procedure N2Click(Sender: TObject);
        Procedure N5Click(Sender: TObject);
        Procedure N6Click(Sender: TObject);
        Procedure N7Click(Sender: TObject);
        Procedure N4Click(Sender: TObject);
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Type
    ERRORS_CODE = (SUCCESS, INCORRECT_DATA_FILE, A_LOT_OF_DATA_FILE,
      OUT_OF_BORDER);

Const
    DIGITS = ['0' .. '9'];
    VOID = #0;
    BACKSPACE = #8;
    MAX_NUMB = 999;
    MIN_NUMB = 1;
    ERRORS: Array [ERRORS_CODE] Of String = ('Successfull',
      'Данные в файле не корректные', 'В файле должно быть только 3 числа',
      'Числа должны быть в диапазоне [0, 999]');

Var
    Form1: TForm1;
    IsSaved: Boolean = True;

Implementation

{$R *.dfm}

Function IsTriangleIsosceles(FirstS, SecondS, ThirdS: Integer): Boolean;
Begin
    IsTriangleIsosceles := (FirstS = SecondS) Or (FirstS = ThirdS) Or
      (SecondS = ThirdS);
End;

Function IsTriangleExist(FirstS, SecondS, ThirdS: Integer): Boolean;
Begin
    IsTriangleExist := (FirstS + SecondS > ThirdS) And
      (FirstS + ThirdS > SecondS) And (ThirdS + SecondS > FirstS);
End;

Procedure TForm1.Button1Click(Sender: TObject);
Begin
    If IsTriangleExist(StrToInt(Edit1.Text), StrToInt(Edit2.Text),
      StrToInt(Edit3.Text)) Then
    Begin
        If IsTriangleIsosceles(StrToInt(Edit1.Text), StrToInt(Edit2.Text),
          StrToInt(Edit3.Text)) Then
            Edit4.Text := 'Равнобедренный'
        Else
            Edit4.Text := 'Не равнобедренный';
        N4.Enabled := True;
        IsSaved := False;
    End

    Else
    Begin
        Application.MessageBox('Треугольника с такими сторонами не существует',
          'Внимание', MB_OK + MB_ICONEXCLAMATION);
        Edit1.Clear;
        Edit2.Clear;
        Edit3.Clear;
        Edit1.SetFocus;
    End;
End;

Function IsEditsNotEmpty(Edit1, Edit2, Edit3: TEdit): Boolean;
Begin
    IsEditsNotEmpty := (Edit1.Text <> '') And (Edit2.Text <> '') And
      (Edit3.Text <> '');
End;

Procedure TForm1.CheckEdit(Sender: TObject);
Begin
    Edit4.Text := '';
    N4.Enabled := False;
    If IsEditsNotEmpty(Edit1, Edit2, Edit3) Then
        Button1.Enabled := True
    Else
        Button1.Enabled := False;
End;

Procedure TForm1.Edit1Change(Sender: TObject);
Begin
    CheckEdit(Sender);
End;

Procedure TForm1.Edit1KeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
    If ((SsShift In Shift) Or (SsCtrl In Shift)) And
      Not((Key = VK_RIGHT) Or (Key = VK_LEFT)) Then
        Key := 0;
    If Key = VK_DELETE Then
        Key := 0;
    If (Key = VK_RIGHT) And (Edit1.SelStart = Length(Edit1.Text)) Then
        Edit2.SetFocus;
    If Key = VK_DOWN Then
        Edit3.SetFocus;
    If (Key = VK_RETURN) And IsEditsNotEmpty(Edit1, Edit2, Edit3) Then
        Button1.Click;
End;

Procedure TForm1.Edit1KeyPress(Sender: TObject; Var Key: Char);
Begin
    If (Edit1.SelStart = 0) And (Key = '0') Then
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

Procedure TForm1.Edit2Change(Sender: TObject);
Begin
    CheckEdit(Sender);
End;

Procedure TForm1.Edit2KeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
    If ((SsShift In Shift) Or (SsCtrl In Shift)) And
      Not((Key = VK_RIGHT) Or (Key = VK_LEFT)) Then
        Key := 0;
    If Key = VK_DELETE Then
        Key := 0;
    If (Key = VK_LEFT) And (Edit2.SelStart = 0) Then
        Edit1.SetFocus;
    If Key = VK_DOWN Then
        Edit3.SetFocus;
    If (Key = VK_RETURN) And IsEditsNotEmpty(Edit1, Edit2, Edit3) Then
        Button1.Click;
End;

Procedure TForm1.Edit2KeyPress(Sender: TObject; Var Key: Char);
Begin
    If (Edit2.SelStart = 0) And (Key = '0') Then
        Key := VOID;
    If Not((CharInSet(Key, DIGITS)) Or (Key = BACKSPACE)) Then
        Key := VOID;
    If Edit1.SelLength = 0 Then
    Begin
        If (Key = BACKSPACE) And (Edit2.SelStart = 1) And
          (Length(Edit2.Text) > 1) And
          (Edit2.Text[Edit2.SelStart + 1] = '0') Then
            Key := VOID;
    End
    Else If (Length(Edit2.Text) > Edit2.SelLength) And
      (Edit2.Text[Edit2.SelLength + 1] = '0') And (Key = BACKSPACE) Then
        Key := VOID;
End;

Procedure TForm1.Edit3Change(Sender: TObject);
Begin
    CheckEdit(Sender);
End;

Procedure TForm1.Edit3KeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
    If ((SsShift In Shift) Or (SsCtrl In Shift)) And
      Not((Key = VK_RIGHT) Or (Key = VK_LEFT)) Then
        Key := 0;
    If Key = VK_DELETE Then
        Key := 0;
    If (Key = VK_RIGHT) And (Edit3.SelStart = Length(Edit3.Text)) Then
        Edit2.SetFocus;
    If (Key = VK_LEFT) And (Edit3.SelStart = 0) Then
        Edit1.SetFocus;
    If (Key = VK_UP) Then
        Edit1.SetFocus;
    If (Key = VK_DOWN) And Button1.Enabled Then
        Button1.SetFocus;
    If (Key = VK_RETURN) And IsEditsNotEmpty(Edit1, Edit2, Edit3) Then
        Button1.Click;
End;

Procedure TForm1.Edit3KeyPress(Sender: TObject; Var Key: Char);
Begin
    If (Edit3.SelStart = 0) And (Key = '0') Then
        Key := VOID;
    If Not((CharInSet(Key, DIGITS)) Or (Key = BACKSPACE)) Then
        Key := VOID;
    If Edit1.SelLength = 0 Then
    Begin
        If (Key = BACKSPACE) And (Edit3.SelStart = 1) And
          (Length(Edit3.Text) > 1) And
          (Edit3.Text[Edit3.SelStart + 1] = '0') Then
            Key := VOID;
    End
    Else If (Length(Edit3.Text) > Edit3.SelLength) And
      (Edit3.Text[Edit3.SelLength + 1] = '0') And (Key = BACKSPACE) Then
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

Function ReadOneFromFile(Var Numb: Integer; Var MyFile: TextFile): ERRORS_CODE;
Var
    Err: ERRORS_CODE;
    IsCorrect: Boolean;
    NumbInt: Integer;
Begin
    NumbInt := 0;
    Err := SUCCESS;
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
    Size1, Size2, Size3: Integer;
    Err: ERRORS_CODE;
Begin
    Err := SUCCESS;
    If OpenTextFileDialog1.Execute() Then
    Begin
        AssignFile(InfFile, OpenTextFileDialog1.FileName);
        Reset(InfFile);
        Err := ReadOneFromFile(Size1, InfFile);
        If Err = SUCCESS Then
        Begin
            Err := ReadOneFromFile(Size2, InfFile);
            If Err = SUCCESS Then
            Begin
                Err := ReadOneFromFile(Size3, InfFile);
                If Err = SUCCESS Then
                Begin
                    If Not EoF(InfFile) Then
                        Err := A_LOT_OF_DATA_FILE;
                End;
            End;

        End;
        If Err = SUCCESS Then
        Begin
            Edit1.Text := IntToStr(Size1);
            Edit2.Text := IntToStr(Size2);
            Edit3.Text := IntToStr(Size3);
        End
        Else
        Begin
            Application.MessageBox(PChar(ERRORS[Err]), 'Ошибочка вышла',
              MB_OK + MB_ICONERROR);
        End;
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
        Writeln(OutFile, 'Треугольник со сторонами: ' + Edit1.Text + ', ' + Edit2.Text + ', ' + Edit3.Text);
        Write(OutFile, Edit4.Text);
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
