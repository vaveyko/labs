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
        Procedure Edit1KeyPress(Sender: TObject; Var Key: Char);
        Procedure Edit1KeyDown(Sender: TObject; Var Key: Word;
          Shift: TShiftState);
        Procedure Edit1Change(Sender: TObject);
        Procedure CheckButtonClick(Sender: TObject);
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Type
    ERRORS_CODE = (SUCCESS, A_LOT_OF_DATA_FILE, INCORRECT_LINE);

Const
    ValidSymbols: Array Of Char = ['1', '2', '3', '4', '5', '6', '7', '8', '9',
      '0', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
      'o', 'p', 'q', 'r', 's', 't', 'y', 'v', 'w', 'z', 'y', 'z', '.', '-', '+',
      'а', 'б', 'в', 'г', 'д', 'е', 'ё', 'ж', 'з', 'и', 'й', 'к', 'л', 'м', 'н',
      'о', 'п', 'р', 'с', 'т', 'у', 'ф', 'х', 'ц', 'ч', 'щ', 'ъ', 'ы', 'ь',
      'э', 'ю', 'я'];
    INFTEXT = 'Задана строка символов, состоящая из букв, цифр, точек, символов «+»'
              + ' и «-». Выделить подстроку, состоящую из цифр, соответствующую'
              + ' целому числу (т.е. начинается со знака «+» или «-» и внутри подстроки'
              + ' нет букв и точки).';
    DIGITS = ['0' .. '9'];
    VOID = #0;
    BACKSPACE = #8;
    MAX_NUMB = 999;
    MIN_NUMB = 1;
    ERRORS: Array [ERRORS_CODE] Of String = ('Successfull',
      'В файле должна быть одна строка',
      'Строка может содержать только цифры, буквы, точку, знаки плюса и минуса');

Var
    Form1: TForm1;
    IsSaved: Boolean = True;

Implementation

{$R *.dfm}

Function GetNumFromLine(Line: String): String;
Var
    IsNumbNotExist: Boolean;
    I, Size: Integer;
    Numb: String;
Begin
    Numb := 'not exist';
    IsNumbNotExist := True;
    Size := Length(Line) + 1;
    I := 1;
    While I < Size Do
    Begin
        If (IsNumbNotExist And ((Line[I] = '+') Or (Line[I] = '-'))) Then
        Begin
            Numb := Line[I];
            Inc(I);
            While ((I < Size) And (Line[I] In DIGITS)) Do
            Begin
                Numb := Numb + Line[I];
                Inc(I);
            End;
            IsNumbNotExist := Length(Numb) = 1;
            If IsNumbNotExist Then
                Numb := 'not exist';
        End
        Else
            Inc(I);
    End;
    GetNumFromLine := Numb;
End;

Procedure TForm1.CheckButtonClick(Sender: TObject);
Begin
    N4.Enabled := True;
    IsSaved := False;
    Edit2.Text := GetNumFromLine(Edit1.Text);
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
      Not((Key = VK_RIGHT) Or (Key = VK_LEFT) Or (Key = 187)) Then
        Key := 0;
    If Key = VK_DELETE Then
        Key := 0;
End;

Function ArrContainElem(Element: Char): Boolean;
Var
    IsContain: Boolean;
    I: Integer;
Begin
    IsContain := False;
    For I := 0 To High(ValidSymbols) Do
        If ValidSymbols[I] = Element Then
            IsContain := True;
    ArrContainElem := IsContain;
End;

Procedure TForm1.Edit1KeyPress(Sender: TObject; Var Key: Char);
Begin
    If Not(ArrContainElem(Key) Or (Key = #8)) Then
        Key := #0;
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

Procedure TForm1.N2Click(Sender: TObject);
Var
    InfFile: TextFile;
    Line: String;
    Err: ERRORS_CODE;
    I: Integer;
Begin
    Err := SUCCESS;
    If OpenTextFileDialog1.Execute() Then
    Begin
        AssignFile(InfFile, OpenTextFileDialog1.FileName);
        Reset(InfFile);

        Read(InfFile, Line);
        If (Line = '') Or Not(EoF(InfFile)) Then
            Err := A_LOT_OF_DATA_FILE;

        If Err = SUCCESS Then
            For I := 1 To High(Line) Do
                If Not ArrContainElem(Line[I]) Then
                    Err := INCORRECT_LINE;

        If Err = SUCCESS Then
            Edit1.Text := Line
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
        Writeln(OutFile, 'Исходная строка: ' + Edit1.Text);
        Write(OutFile, 'Подстрока-число: ' + Edit2.Text);
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
