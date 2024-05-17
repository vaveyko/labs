Unit MainUnit;

Interface

Uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Forms,
    Vcl.ExtDlgs, Vcl.Menus, Vcl.StdCtrls, Vcl.Grids, Vcl.Dialogs, Vcl.Controls,
    ManualUnit, DevInfUnit, Vcl.ExtCtrls;

Type
    TManeForm = Class(TForm)
        MainMenu: TMainMenu;
        FileButtonMenu: TMenuItem;
        OpenButtonMenu: TMenuItem;
        SaveButtonMenu: TMenuItem;
        LineMenu: TMenuItem;
        ExitButtonMenu: TMenuItem;
        ManualButtonMenu: TMenuItem;
        DeveloperButtonMenu: TMenuItem;
        PopupMenu: TPopupMenu;
        OpenTextFileDialog: TOpenTextFileDialog;
        SaveTextFileDialog: TSaveTextFileDialog;
        CheckButton: TButton;
        InfLabel: TLabel;
        SizeEdit: TEdit;
        SizeLabel: TLabel;
        MatrixLabel: TLabel;
        SquareGrid: TStringGrid;
        Timer: TTimer;
        Procedure ManualButtonMenuClick(Sender: TObject);
        Procedure DeveloperButtonMenuClick(Sender: TObject);
        Procedure FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
        Procedure ExitButtonMenuClick(Sender: TObject);
        Procedure FormCreate(Sender: TObject);
        Procedure OpenButtonMenuClick(Sender: TObject);
        Procedure SaveButtonMenuClick(Sender: TObject);
        Procedure SizeEditChange(Sender: TObject);
        Procedure SizeEditKeyPress(Sender: TObject; Var Key: Char);
        Procedure SizeEditKeyDown(Sender: TObject; Var Key: Word;
          Shift: TShiftState);
        Procedure CheckButtonKeyDown(Sender: TObject; Var Key: Word;
          Shift: TShiftState);
        Procedure CheckButtonClick(Sender: TObject);
        Procedure TimerTimer(Sender: TObject);
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Type
    ERRORS_CODE = (SUCCESS, INCORRECT_DATA_FILE, A_LOT_OF_DATA_FILE,
      OUT_OF_BORDER, OUT_OF_BORDER_SIZE);
    TGridCracker = Class(TStringGrid);
    TSquare = Array Of Array Of Integer;

Const
    INFTEXT = 'Построить Магический квадрат четно-нечетного порядка';
    DIGITS = ['0' .. '9'];
    VOID = #0;
    BACKSPACE = #8;
    MAX_SIZE = 18;
    MIN_SIZE = 1;
    ERRORS: Array [ERRORS_CODE] Of String = ('Successfull',
      'Данные в файле некорректные',
      'В файле неверное количество элементов или стоит лишний пробел',
      'Числа должны быть в диапазоне [-70, 70]',
      'Размер должен быть в диапазоне [1, 5]');

Var
    ManeForm: TManeForm;
    IsSaved: Boolean = True;

    TotalCounter: Integer;
    FindedSquare: TSquare;

Implementation

{$R *.dfm}

Procedure SwapElem(Arr: TSquare; I1, J1, I2, J2: Integer);
Var
    Buff: Integer;
Begin
    Buff := Arr[I1, J1];
    Arr[I1, J1] := Arr[I2, J2];
    Arr[I2, J2] := Buff;
End;

Function MagicBox(Size: Integer): TSquare;
Var
    HalfSize, I, J, Number: Integer;
    Square: TSquare;
Begin
    SetLength(Square, Size, Size);
    HalfSize := Size Div 2;

    // Построение четырех квадратов порядка n / 2
    I := 0;
    J := (HalfSize - 1) Div 2;
    Number := 1;

    While Number <= HalfSize * HalfSize Do
    Begin
        If I < 0 Then
            Inc(I, HalfSize);
        If I >= HalfSize Then
            Dec(I, HalfSize);
        If J >= HalfSize Then
            Dec(J, HalfSize);
        If J < 0 Then
            Inc(J, HalfSize);

        Square[J, I] := Number;
        Square[J + HalfSize, I + HalfSize] := Number + HalfSize * HalfSize;
        Square[J, I + HalfSize] := Number + 2 * HalfSize * HalfSize;
        Square[J + HalfSize, I] := Number + 3 * HalfSize * HalfSize;

        If Number Mod HalfSize = 0 Then
        Begin
            Inc(I);
            Dec(J); // for iteration
            Inc(I);
        End;

        Inc(Number);
        Inc(J);
        Dec(I);
    End;

    // Меняем местами ломанные
    SwapElem(Square, 0, 0, HalfSize, 0);
    SwapElem(Square, HalfSize - 1, 0, Size - 1, 0);

    For I := 1 To HalfSize - 2 Do
    Begin
        SwapElem(Square, I, 1, I + HalfSize, 1)
    End;

    // Меняем местами столбцы
    For J := HalfSize - ((HalfSize - 3) Div 2) To HalfSize + (HalfSize - 3)
      Div 2 - 1 Do
    Begin
        For I := 0 To HalfSize - 1 Do
        Begin
            SwapElem(Square, J, I, J, I + HalfSize)
        End;
    End;
    MagicBox := Square;
End;

Procedure FillGrid(Size: Integer; Grid: TStringGrid);
Var
    I: Integer;
Begin
    Grid.Visible := True;

    Grid.Width := (Grid.DefaultColWidth + 3) * Size;
    Grid.Height := (Grid.DefaultRowHeight + 3) * Size;

    Grid.ColCount := Size;
    Grid.RowCount := Size;
End;

Procedure ClearGrid(Grid: TStringGrid);
Var
    J, I: Integer;
Begin
    Grid.Visible := False;
    For I := 0 To Grid.ColCount - 1 Do
        For J := 0 To Grid.RowCount - 1 Do
            Grid.Cells[I, J] := '';
End;

Procedure TManeForm.SizeEditChange(Sender: TObject);
Begin
    CheckButton.Enabled := False;
    SaveButtonMenu.Enabled := False;
    If SizeEdit.Text = '' Then
    Begin
        MatrixLabel.Visible := False;
        ClearGrid(SquareGrid);
        CheckButton.Enabled := False;
    End
    Else If (StrToInt(SizeEdit.Text) Mod 2 = 0) And
      (StrToInt(SizeEdit.Text) Mod 4 <> 0) And
      (StrToInt(SizeEdit.Text) > 2) Then

    Begin
        MatrixLabel.Visible := True;
        ClearGrid(SquareGrid);
        FillGrid(StrToInt(SizeEdit.Text), SquareGrid);
        CheckButton.Enabled := True;
    End;
End;

Procedure TManeForm.SizeEditKeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
    If ((SsShift In Shift) Or (SsCtrl In Shift)) And
      Not((Key = VK_RIGHT) Or (Key = VK_LEFT)) Then
        Key := 0;
    If Key = VK_DELETE Then
        Key := 0;
    If (Key = VK_DOWN) And (SquareGrid.Visible) Then
        SquareGrid.SetFocus;
End;

Function InsertKey(Index: Integer; SubStr: Char; SelLen: Integer;
  Text: String): String;
Var
    ResultText: String;
Begin
    ResultText := Text;
    If (SubStr = BACKSPACE) And (SelLen = 0) Then
        Delete(ResultText, Index, 1)
    Else
    Begin
        Delete(ResultText, Index + 1, SelLen);
        If Substr <> BACKSPACE Then
            ResultText.Insert(Index, String(SubStr));
    End;

    InsertKey := ResultText;
End;

Function CountOfSymbolInt(Num: Integer): Integer;
Var
    NumLen: Integer;
Begin
    NumLen := 0;
    If Num < 0 Then
        Inc(NumLen);
    Repeat
        Inc(NumLen);
        Num := Num Div 10;
    Until (Num = 0);
    CountOfSymbolInt := NumLen;
End;

Procedure TotalKeyPress(Var Key: Char; SelStart, SelLength: Integer;
  Const MIN, MAX: Integer; Text: String);
Var
    ResultNum, RBorder, NumLen: Integer;
    Buffer, Output: String;
Begin
    Output := InsertKey(SelStart, Key, SelLength, Text);
    If (Length(Output) <> 0) And (Output <> '-') And (Output <> '') Then
    Begin
        Try
            ResultNum := StrToInt(Output);
        Except
            Key := VOID;
        End;
        If Key <> VOID Then
        Begin
            NumLen := CountOfSymbolInt(ResultNum);
            If NumLen <> Length(Output) Then
                Key := VOID;
            If (ResultNum > MAX) Or (ResultNum < MIN) Then
                Key := VOID;
        End;
    End;
End;

Procedure TManeForm.SizeEditKeyPress(Sender: TObject; Var Key: Char);
Var
    ResultNum: Integer;
Begin
    TotalKeyPress(Key, SizeEdit.SelStart, SizeEdit.SelLength, MIN_SIZE,
      MAX_SIZE, SizeEdit.Text);
End;

Procedure TManeForm.TimerTimer(Sender: TObject);
Var
    I, J: Integer;
Begin
    For I := Low(FindedSquare) To High(FindedSquare) Do
        For J := Low(FindedSquare) To High(FindedSquare) Do
            if FindedSquare[I, J] = TotalCounter then
                SquareGrid.Cells[J, I] := IntTostr(FindedSquare[I, J]);
    Inc(TotalCounter);
    if TotalCounter > SquareGrid.ColCount * SquareGrid.ColCount then
        Timer.Interval := 0;
End;

Procedure TManeForm.FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
Begin
    If SaveButtonMenu.Enabled And Not IsSaved Then
        Case Application.MessageBox('Сохранить данные перед выходом?', 'Выход',
          MB_YESNOCANCEL + MB_ICONQUESTION + MB_DEFBUTTON3) Of
            IDYES:
                Begin
                    SaveButtonMenu.Click;
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

Procedure TManeForm.FormCreate(Sender: TObject);
Begin
    InfLabel.Caption := INFTEXT;
    SizeEdit.Text := '';
End;

Function ReadOneFromFile(Var Numb: Integer; Var MyFile: TextFile): ERRORS_CODE;
Var
    Err: ERRORS_CODE;
    NumbInt: Integer;
    NumbStr: String;
Begin
    Err := SUCCESS;
    NumbInt := 0;
    Try
        Read(MyFile, NumbInt);
    Except
        Err := INCORRECT_DATA_FILE;
    End;
    If Err = SUCCESS Then
        If (NumbInt > MAX_SIZE) Or (NumbInt < MIN_SIZE) Then
            Err := OUT_OF_BORDER_SIZE
        Else
            Numb := NumbInt;
    ReadOneFromFile := Err;
End;

Procedure TManeForm.OpenButtonMenuClick(Sender: TObject);
Var
    InfFile: TextFile;
    Size: Integer;
    Err: ERRORS_CODE;
Begin
    Err := SUCCESS;
    If OpenTextFileDialog.Execute() Then
    Begin
        AssignFile(InfFile, OpenTextFileDialog.FileName);
        Reset(InfFile);
        Err := ReadOneFromFile(Size, InfFile);
        If Not EoF(InfFile) Then
            Err := A_LOT_OF_DATA_FILE;
        If Err = SUCCESS Then
        Begin
            SizeEdit.Text := IntToStr(Size);
            FillGrid(Size, SquareGrid);
            CheckButton.Enabled := True;
        End
        Else
            Application.MessageBox(PChar(ERRORS[Err]), 'Ошибочка вышла',
              MB_OK + MB_ICONERROR);
        CloseFile(InfFile);
    End;
End;

Procedure TManeForm.SaveButtonMenuClick(Sender: TObject);
Var
    OutFile: TextFile;
    I, J: Integer;
Begin
    If SaveTextFileDialog.Execute() Then
    Begin
        AssignFile(OutFile, SaveTextFileDialog.FileName);
        Rewrite(OutFile);

        With SquareGrid Do
        Begin
            For I := 0 To ColCount - 1 Do
            Begin
                For J := 0 To ColCount - 1 Do
                    Write(OutFile, Cells[I, J] + ' ');
                Writeln(OutFile);
            End;
        End;

        CloseFile(OutFile);
        IsSaved := True;
    End;
End;

Procedure TManeForm.ManualButtonMenuClick(Sender: TObject);
Var
    Form2: TManualForm;
Begin
    Form2 := TManualForm.Create(Self);
    Form2.ShowModal;
    Form2.Free;
End;

Procedure TManeForm.CheckButtonClick(Sender: TObject);
Var
    Size: Integer;
Begin
    Size := StrToInt(SizeEdit.Text);
    SetLength(FindedSquare, Size, Size);
    FindedSquare := MagicBox(Size);

    Timer.Interval := 500;
    TotalCounter := 1;

    SaveButtonMenu.Enabled := True;
End;

Procedure TManeForm.CheckButtonKeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
    If (Key = VK_UP) Then
        SquareGrid.SetFocus;
End;

Procedure TManeForm.DeveloperButtonMenuClick(Sender: TObject);
Var
    Form3: TDeveloperForm;
Begin
    Form3 := TDeveloperForm.Create(Self);
    Form3.ShowModal;
    Form3.Free;
End;

Procedure TManeForm.ExitButtonMenuClick(Sender: TObject);
Begin
    Close();
End;

End.
