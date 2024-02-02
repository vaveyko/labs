Unit ManeUnit;

Interface

Uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
    System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtDlgs, Vcl.Menus, Vcl.StdCtrls,
    ManualUnit, DevInfUnit, Vcl.Grids, Vcl.Buttons, Vcl.Mask, Vcl.ExtCtrls,
    Vcl.DBCtrls;

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
        MatrixGrid: TStringGrid;
        DetLabel: TLabel;
        DetEdit: TEdit;
        Procedure ManualButtonMenuClick(Sender: TObject);
        Procedure DeveloperButtonMenuClick(Sender: TObject);
        Procedure FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
        Procedure ExitButtonMenuClick(Sender: TObject);
        Procedure FormCreate(Sender: TObject);
        Procedure OpenButtonMenuClick(Sender: TObject);
        Procedure SaveButtonMenuClick(Sender: TObject);
        Procedure MatrixGridKeyPress(Sender: TObject; Var Key: Char);
        Procedure MatrixGridKeyDown(Sender: TObject; Var Key: Word;
          Shift: TShiftState);
        Procedure SizeEditChange(Sender: TObject);
        Procedure SizeEditKeyPress(Sender: TObject; Var Key: Char);
        Procedure CheckButtonClick(Sender: TObject);
        Procedure SizeEditKeyDown(Sender: TObject; Var Key: Word;
          Shift: TShiftState);
        Procedure CheckButtonKeyDown(Sender: TObject; Var Key: Word;
          Shift: TShiftState);
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Type
    ERRORS_CODE = (SUCCESS, INCORRECT_DATA_FILE, A_LOT_OF_DATA_FILE,
      OUT_OF_BORDER, OUT_OF_BORDER_SIZE);
    TGridCracker = Class(TStringGrid);
    IntArr = Array Of Integer;
    Matrix = Array Of IntArr;

Const
    INFTEXT = 'Вычислить определитель матрицы А';
    DIGITS = ['0' .. '9'];
    VOID = #0;
    BACKSPACE = #8;
    MAX_NUMB = 70;
    MIN_NUMB = -70;
    MAX_SIZE = 5;
    MIN_SIZE = 1;
    ERRORS: Array [ERRORS_CODE] Of String = ('Successfull',
      'Данные в файле не корректные',
      'В файле неверное количество элементов или стоит лишний пробел',
      'Числа должны быть в диапазоне [-70, 70]',
      'Размер должен быть в диапазоне [1, 5]');

Var
    ManeForm: TManeForm;
    IsSaved: Boolean = True;

Implementation

{$R *.dfm}

Procedure DeleteColRow(Var NewMatrix: Matrix; OldMatrix: Matrix;
  ColInd: Integer; RowInd: Integer = 0);
Var
    Size, I, J, CurRow, CurCol: Integer;
Begin
    CurCol := 0;
    CurRow := 0;
    Size := Length(OldMatrix) - 1;
    SetLength(NewMatrix, Size, Size);

    For I := 0 To High(OldMatrix) Do
    Begin
        If I <> RowInd Then
        Begin
            For J := 0 To High(OldMatrix) Do
                If J <> ColInd Then
                Begin
                    NewMatrix[CurRow, CurCol] := OldMatrix[I, J];
                    Inc(CurCol);
                End;
            CurCol := 0;
            Inc(CurRow);
        End;
    End;
End;

Function CalcDet(CurMatrix: Matrix): Integer;
Var
    Det, I, Addition: Integer;
    NewMatrix: Matrix;
Begin
    Det := 0;
    If Length(CurMatrix) = 1 Then
        Det := CurMatrix[0, 0]
    Else
        For I := 0 To High(CurMatrix) Do
            If CurMatrix[0, I] <> 0 Then
            Begin
                DeleteColRow(NewMatrix, CurMatrix, I);
                Addition := CurMatrix[0, I] * CalcDet(NewMatrix);
                If I Mod 2 = 1 Then
                    Addition := -Addition;
                Inc(Det, Addition);
            End;
    CalcDet := Det;
End;

Procedure FillGrid(Size: Integer; Grid: TStringGrid);
Var
    I: Integer;
Begin
    Grid.Visible := True;

    Grid.ColWidths[0] := 50;
    If Size > 5 Then
    Begin
        Grid.Width := (Grid.DefaultColWidth + 3) * 5 + 25 + Grid.ColWidths[0];
        Grid.Height := (Grid.DefaultRowHeight + 3) * 6 + 25;
    End
    Else
    Begin
        Grid.Width := (Grid.DefaultColWidth + 4) * Size + Grid.ColWidths[0];
        Grid.Height := (Grid.DefaultRowHeight + 3) * (Size + 1);
    End;
    Grid.ColCount := Size + 1;
    Grid.RowCount := Size + 1;
    Grid.Cells[0, 0] := '\';
    For I := 1 To Size Do
    Begin
        Grid.Cells[I, 0] := IntToStr(I);
        Grid.Cells[0, I] := IntToStr(I);
    End;
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

Procedure TManeForm.CheckButtonClick(Sender: TObject);
Var
    Arr: Matrix;
    I, J: Integer;
Begin
    SetLength(Arr, StrToInt(SizeEdit.Text), StrToInt(SizeEdit.Text));
    For I := 0 To MatrixGrid.RowCount - 2 Do
        For J := 0 To MatrixGrid.ColCount - 2 Do
            Arr[J, I] := StrToInt(MatrixGrid.Cells[I + 1, J + 1]);

    DetEdit.Text := IntToStr(CalcDet(Arr));

    SaveButtonMenu.Enabled := True;
    IsSaved := False;
End;

Procedure TManeForm.SizeEditChange(Sender: TObject);
Begin
    DetEdit.Text := '';
    CheckButton.Enabled := False;
    If SizeEdit.Text = '' Then
    Begin
        MatrixLabel.Visible := False;
        ClearGrid(MatrixGrid);
    End
    Else
    Begin
        MatrixLabel.Visible := True;
        ClearGrid(MatrixGrid);
        FillGrid(StrToInt(SizeEdit.Text), MatrixGrid);
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
    If (Key = VK_DOWN) And (MatrixGrid.Visible) Then
        MatrixGrid.SetFocus;
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

Function ReadOneFromFile(Var Numb: Integer; Var MyFile: TextFile;
  IsElemRead: Boolean = True): ERRORS_CODE;
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
        If IsElemRead Then
            If (NumbInt > MAX_NUMB) Or (NumbInt < MIN_NUMB) Then
                Err := OUT_OF_BORDER
            Else
                Numb := NumbInt
        Else If (NumbInt > MAX_SIZE) Or (NumbInt < MIN_SIZE) Then
            Err := OUT_OF_BORDER_SIZE
        Else
            Numb := NumbInt;
    ReadOneFromFile := Err;
End;

Procedure TManeForm.OpenButtonMenuClick(Sender: TObject);
Var
    InfFile: TextFile;
    Size, I, J: Integer;
    Arr: Matrix;
    Err: ERRORS_CODE;
Begin
    Err := SUCCESS;
    I := 0;
    J := 0;
    If OpenTextFileDialog.Execute() Then
    Begin
        AssignFile(InfFile, OpenTextFileDialog.FileName);
        Reset(InfFile);
        Err := ReadOneFromFile(Size, InfFile, False);
        If Err = SUCCESS Then
        Begin
            SetLength(Arr, Size, Size);
            While (I < Size) And (Err = SUCCESS) Do
            Begin
                While (J < Size) And (Err = SUCCESS) Do
                Begin
                    If Eof(InfFile) Then
                        Err := A_LOT_OF_DATA_FILE;
                    Err := ReadOneFromFile(Arr[I][J], InfFile);
                    Inc(J);
                End;
                J := 0;
                Inc(I);
            End;
        End;
        If Not EoF(InfFile) Then
            Err := A_LOT_OF_DATA_FILE;
        If Err = SUCCESS Then
        Begin
            SizeEdit.Text := IntToStr(Size);
            FillGrid(Size, MatrixGrid);
            For I := 0 To High(Arr) Do
                For J := 0 To High(Arr) Do
                    MatrixGrid.Cells[J + 1, I + 1] := IntToStr(Arr[I][J]);
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
        Writeln(OutFile, MatrixLabel.Caption);
        With MatrixGrid Do
            For I := 1 To RowCount - 1 Do
            Begin
                For J := 1 To ColCount - 1 Do
                    Write(OutFile, Cells[J, I] + ' ');
                Write(OutFile, #13#10);
            End;
        Writeln(OutFile, DetLabel.Caption);

        Write(OutFile, #13#10 + DetEdit.Text);

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

Procedure TManeForm.CheckButtonKeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
    If (Key = VK_UP) Then
        MatrixGrid.SetFocus;
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

Function IsAllCellFill(Grid: TStringGrid; Key: Char;
  CurCell: TInplaceEdit): Boolean;
Var
    IsFilled: Boolean;
    I, J: Integer;
Begin
    IsFilled := True;
    For I := 1 To Grid.ColCount - 1 Do
        For J := 1 To Grid.RowCount - 1 Do
        Begin
            If (Grid.Col = I) And (Grid.Row = J) And Not(Key = VOID) Then
            Begin
                If (Grid.Cells[I, J] = '') And Not CharInSet(Key, DIGITS) Then
                    IsFilled := False;
                With CurCell Do
                    If (Key = BACKSPACE) And
                      (InsertKey(SelStart, Key, SelLength, Text) = '') Then
                        IsFilled := False;
            End
            Else If (Grid.Cells[I, J] = '') Or (Grid.Cells[I, J] = '-') Then
                IsFilled := False;
        End;
    IsAllCellFill := IsFilled;
End;

Procedure TManeForm.MatrixGridKeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
    If ((SsShift In Shift) Or (SsCtrl In Shift)) And
      Not((Key = VK_RIGHT) Or (Key = VK_LEFT)) Then
        Key := 0;
    If Key = VK_DELETE Then
        Key := 0;
    If (Key = VK_RETURN) And (CheckButton.Enabled) Then
        CheckButton.Click;
    If (Key = VK_DOWN) And CheckButton.Enabled And
      (MatrixGrid.Row = MatrixGrid.RowCount - 1) Then
        CheckButton.SetFocus;
    If (Key = VK_UP) And (MatrixGrid.Row = 1) Then
        SizeEdit.SetFocus;

End;

Procedure TManeForm.MatrixGridKeyPress(Sender: TObject; Var Key: Char);
Var
    GridCel: TGridCracker;
    EditingCell: TInplaceEdit;
Begin
    GridCel := TGridCracker(Sender);
    EditingCell := GridCel.InplaceEditor;
    TotalKeyPress(Key, EditingCell.SelStart, EditingCell.SelLength, MIN_NUMB,
      MAX_NUMB, EditingCell.Text);
    If IsAllCellFill(GridCel, Key, EditingCell) Then
        CheckButton.Enabled := True
    Else
        CheckButton.Enabled := False;
    If Key <> VOID Then
        DetEdit.Text := '';
End;

End.
