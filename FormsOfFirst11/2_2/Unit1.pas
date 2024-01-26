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
        Label1: TLabel;
        Label2: TLabel;
    Memo1: TMemo;
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
    function FormHelp(Command: Word; Data: NativeInt;
      var CallHelp: Boolean): Boolean;
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Type
    ERRORS_CODE = (SUCCESS, INCORRECT_DATA_FILE, A_LOT_OF_DATA_FILE,
      OUT_OF_BORDER);

Const
    INFTEXT = 'Дано натуральное число n. Найти все меньшие n числа Мерсена. (Простое '
            + 'число называется числом Мерсена, если оно может быть представлено в '
            + 'виде 2^р – 1, где р – тоже простое число.';
    DIGITS = ['0' .. '9'];
    VOID = #0;
    BACKSPACE = #8;
    MAX_NUMB = 2000000000;
    MIN_NUMB = 1;
    ERRORS: Array [ERRORS_CODE] Of String = ('Successfull',
      'Данные в файле не корректные', 'В файле должно быть только 1 число',
      'Числа должны быть в диапазоне [0, 2000000000]');

Var
    Form1: TForm1;
    IsSaved: Boolean = True;

Implementation

{$R *.dfm}

Function IsNumSimpl(Numb: FixedUInt): Boolean;
Var
    IsSimpl: Boolean;
    NumbSqrt, I: Integer;
Begin
    NumbSqrt := Trunc(Sqrt(Numb));
    IsSimpl := True;
    If (Numb > 3) Then
        For I := 2 To NumbSqrt Do
            If (Numb Mod I = 0) Then
                IsSimpl := False;

    IsNumSimpl := IsSimpl;
End;

Function GetLineMersen(Number: Integer): String;
Var
    Line: String;
    IsBordIncross: Boolean;
    MersenNum, I: Integer;
Begin
    MersenNum := 1;
    I := 2;
    IsBordIncross := True;
    While IsBordIncross Do
    Begin
        MersenNum := MersenNum * 2 + 1;
        IsBordIncross := MersenNum < Number;
        If (IsBordIncross And IsNumSimpl(I) And IsNumSimpl(MersenNum)) Then
            Line := Line + 'Mersen(' + IntToStr(I) + ') -- ' + IntToStr(MersenNum) + #13#10;
        Inc(I);
    End;
    GetLineMersen := Line;
End;

Procedure TForm1.CheckButtonClick(Sender: TObject);
Var
    Line: String;
Begin
    Line := GetLineMersen(StrToInt(Edit1.Text));
    if Line = '' then
        Memo1.Text := 'Таких чисел Мерсена не существует'
    Else
        Memo1.Text := Line;
    N4.Enabled := True;
    IsSaved := False;
End;

Procedure TForm1.CheckButtonExit(Sender: TObject);
Begin
    Edit1.SetFocus;
End;

Procedure TForm1.Edit1Change(Sender: TObject);
Begin
    Memo1.Text := '';
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

Function InsertKey(Index: Integer; SubStr: Char; SelLen: Integer;
  Text: String): String;
Var
    ResultText: String;
    I: Integer;
Begin
    ResultText := '';
    If Length(Text) = SelLen Then
        ResultText := Substr
    Else If (Index = 0) Then
    Begin
        if (SelLen = 0) then
            ResultText := SubStr + Text
        Else
        Begin
            ResultText := Substr;
            For I := Index + SelLen + 1 To Length(Text) Do
                ResultText := ResultText + Text[I];
        End;
    End
    Else If Index = Length(Text) Then
        ResultText := Text + SubStr
    Else
    Begin
        For I := 1 To Index Do
            ResultText := ResultText + Text[I];
        ResultText := ResultText + SubStr;
        For I := Index + SelLen + 1 To Length(Text) Do
            ResultText := ResultText + Text[I];
    End;

    InsertKey := ResultText;
End;

Procedure TotalKeyPress(Var Key: Char; SelStart, SelLength: Integer; Text: String; IsNumPositive: Boolean = False);
Var
    ResultNum, RBorder: Integer;
    Buffer: String;
Begin
    // некае гамно
    If (Key = '0') Then
    Begin
        If (SelStart = 0) Then
        Begin
            Buffer := Key + Text;
            If (Length(Buffer) > 1) And Not(SelLength = Length(Text)) Then
                Key := VOID;
        End
        Else
        Begin
            Buffer := Text;
            If (Buffer[SelStart] = '-') Or
            ((Buffer[SelStart] = '0') And (SelStart = 1)) Then
                Key := VOID;
        End;
    End;
    If (Key = BACKSPACE) Then
    Begin
        If SelLength = 0 Then
        Begin
            If (SelStart = 1) And (Length(Text) > 1) And
              (Text[SelStart + 1] = '0') Then
                Key := VOID;
            If (SelStart = 2) And (Length(Text) > 2) And (Text[SelStart + 1] = '0')
             And (Text[1] = '-') Then
                Key := VOID;
        End
        Else
        Begin
            RBorder := SelStart + SelLength;
            If (SelStart = 0) And (Length(Text) > SelLength) And
              (Text[SelLength + 1] = '0') And (Length(Text) > RBorder+1) Then
                Key := VOID;
            If (SelStart = 1) And (Length(Text) - SelLength > 1) And
              (Text[RBorder + 1] = '0') And (Text[1] = '-') Then
                Key := VOID;
        End;
    End
    Else If (Key = '-') And (SelStart = 0) Then
    Begin
        Buffer := Key + Text;
        If (Length(Buffer) > 1) And ((Buffer[2] = '-') Or (Buffer[2] = '0')) Then
            Key := VOID;
    End
    Else If CharInSet(Key, DIGITS) Then
    Begin
        If (Length(Text) > 0) And (Text[1] = '-') And
          (SelStart = 0) And (SelLength = 0) Then
            Key := VOID
        Else If (Text = '0') And (SelStart = 1) Then
            Key := VOID
        Else
        Begin
            Try
                ResultNum := StrToInt(InsertKey(SelStart, Key, SelLength, Text));
                If (ResultNum > MAX_NUMB) Or (ResultNum < MIN_NUMB) Then
                    Key := VOID;
            Except
                Key := VOID;
            End;
        End;
    End
    Else
        Key := VOID;
    if IsNumPositive And (Key = '-') then
        Key := VOID;
End;

Procedure TForm1.Edit1KeyPress(Sender: TObject; Var Key: Char);
Begin
    TotalKeyPress(Key, Edit1.SelStart, Edit1.SelLength, Edit1.Text, True);
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

function TForm1.FormHelp(Command: Word; Data: NativeInt;
  var CallHelp: Boolean): Boolean;
begin
    if Command = VK_F1 then
        CallHelp := False;
end;

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
        Write(OutFile, Memo1.Text);
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
