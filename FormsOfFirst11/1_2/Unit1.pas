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
        Edit2: TEdit;
        Label2: TLabel;
        Procedure N5Click(Sender: TObject);
        Procedure N6Click(Sender: TObject);
        Procedure FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
        Procedure N7Click(Sender: TObject);
        Procedure FormCreate(Sender: TObject);
        Procedure Edit1Change(Sender: TObject);
        Procedure Edit1KeyPress(Sender: TObject; Var Key: Char);
        Procedure Edit1KeyDown(Sender: TObject; Var Key: Word;
          Shift: TShiftState);
        Procedure CheckButtonClick(Sender: TObject);
        Procedure CheckButtonExit(Sender: TObject);
        Procedure N2Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Type
    ERRORS_CODE = (SUCCESS, INCORRECT_DATA_FILE, A_LOT_OF_DATA_FILE,
      OUT_OF_BORDER);

Const
    INFTEXT = '��������� ������������' + #13#10 +
      '� = 2 * 4 * 6 * 8 * ... * 2n ��� ��������� n.';
    DIGITS = ['0' .. '9'];
    VOID = #0;
    BACKSPACE = #8;
    MIN_NUMB = 1;
    MAX_NUMB = 15;
    ERRORS: Array [ERRORS_CODE] Of String = ('Successfull',
      '������ � ����� �� ����������', '� ����� ������ ���� ������ 1 �����',
      '����� ������ ���� � ��������� [1, 15]');

Var
    Form1: TForm1;
    IsSaved: Boolean = True;

Implementation

{$R *.dfm}

Function MultiOddNum(Num: Integer): Int64;
Var
    I: Integer;
    Multi: Int64;
Begin
    Multi := 2;
    For I := 2 To Num Do
        Multi := Multi * 2 * I;
    MultiOddNum := Multi;
End;

Procedure TForm1.CheckButtonClick(Sender: TObject);
Begin
    Edit2.Text := IntToStr(MultiOddNum(StrToInt(Edit1.Text)));
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
    If (Key = VK_DOWN) And (CheckButton.Enabled) Then
        CheckButton.SetFocus;
    If (Key = VK_RETURN) And CheckButton.Enabled Then
        CheckButton.Click;
End;

Procedure TForm1.Edit1KeyPress(Sender: TObject; Var Key: Char);
Var
    MidleRes: String;
Begin
    If (Edit1.SelStart = 0) And (Key = '0') Then
        Key := VOID;

    // Check selected text
    If Edit1.SelLength = 0 Then
    Begin
        If (Key = BACKSPACE) And (Edit1.SelStart = 1) And
          (Length(Edit1.Text) > 1) And
          (Edit1.Text[Edit1.SelStart + 1] = '0') Then
            Key := VOID;

        // Check the range
        If CharInSet(Key, DIGITS) Then
        Begin
            If Edit1.SelStart = 0 Then
                MidleRes := Key + Edit1.Text
            Else
                MidleRes := Edit1.Text + Key;

            If StrToInt(MidleRes) > MAX_NUMB Then
                Key := VOID;
        End
        Else If Not(Key = BACKSPACE) Then
            Key := VOID;
    End
    Else If CharInSet(Key, DIGITS) Then
    Begin
        If (Length(Edit1.Text) > Edit1.SelLength) And
          (Edit1.Text[Edit1.SelLength + 1] = '0') And (Key = BACKSPACE) Then
            Key := VOID;
        If Not(Edit1.SelLength = Length(Edit1.Text)) And Not(Key = VOID) And
          (StrToInt(Key + Edit1.Text[2]) > MAX_NUMB) Then
            Key := VOID;
    End
    Else If Not(Key = BACKSPACE) Then
        Key := VOID;
End;

Procedure TForm1.FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
Begin
    If N4.Enabled And Not IsSaved Then
        Case Application.MessageBox('��������� ������ ����� �������?', '�����',
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
        Case Application.MessageBox('�� ����� ������ �����?', '�����',
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
            Application.MessageBox(PChar(ERRORS[Err]), '�������� �����',
              MB_OK + MB_ICONERROR);
        CloseFile(InfFile);
    End;
End;

procedure TForm1.N4Click(Sender: TObject);
Var
    OutFile: TextFile;
    I: Integer;
Begin
    If SaveTextFileDialog1.Execute() Then
    Begin
        I := 2;
        AssignFile(OutFile, SaveTextFileDialog1.FileName);
        Rewrite(OutFile);
        Write(OutFile, '2');
        while I <= StrToInt(Edit1.Text) do
        Begin
            Write(OutFile, ' * ' + IntToStr(I*2));
            Inc(I);
        End;
        Write(OutFile, ' = ' + Edit2.Text);
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
