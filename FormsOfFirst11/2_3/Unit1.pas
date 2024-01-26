Unit Unit1;

Interface

Uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
    System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtDlgs, Vcl.Menus, Vcl.StdCtrls,
    Unit2, Unit3, Vcl.Grids, Vcl.Buttons, Vcl.Mask, Vcl.ExtCtrls, Vcl.DBCtrls;

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
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    Label3: TLabel;
        Procedure N5Click(Sender: TObject);
        Procedure N6Click(Sender: TObject);
        Procedure FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
        Procedure N7Click(Sender: TObject);
        Procedure FormCreate(Sender: TObject);
        Procedure N2Click(Sender: TObject);
        Procedure N4Click(Sender: TObject);
        Procedure StringGrid1KeyPress(Sender: TObject; Var Key: Char);
        Procedure StringGrid1KeyDown(Sender: TObject; Var Key: Word;
          Shift: TShiftState);
        Procedure Edit1Change(Sender: TObject);
        Procedure Edit1KeyPress(Sender: TObject; Var Key: Char);
        Procedure CheckButtonClick(Sender: TObject);
        Procedure Edit1KeyDown(Sender: TObject; Var Key: Word;
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
    OneSizeArr = Array Of Integer;
    TwoSizeArr = Array Of OneSizeArr;

Const
    INFTEXT = 'Дана двумерная матрица A порядка n. Расставить элементы строк с'
               + 'четными номерами матрицы в порядке убывания.';
    DIGITS = ['0' .. '9'];
    VOID = #0;
    BACKSPACE = #8;
    MAX_NUMB = MaxInt Div 100;
    MIN_NUMB = -MaxInt Div 100;
    MAX_SIZE = 100;
    MIN_SIZE = 1;
    ERRORS: Array [ERRORS_CODE] Of String = ('Successfull',
      'Данные в файле не корректные',
      'В файле неверное количество элементов или стоит лишний пробел',
      'Числа должны быть в диапазоне [-21474836, 21474836]',
      'Размер должен быть в диапазоне [0, 100]');

Var
    Form1: TForm1;
    IsSaved: Boolean = True;

Implementation

{$R *.dfm}

Function SortArr(Arr: OneSizeArr): OneSizeArr;
Var
    I, J, Bufer: Integer;
    IsNotSort: Boolean;
Begin
    IsNotSort := True;
    While IsNotSort Do
    Begin
        IsNotSort := False;
        For I := 1 To High(Arr) Do
            For J := I To High(Arr) Do
                If Arr[J - 1] < Arr[J] Then
                Begin
                    IsNotSort := True;
                    Bufer := Arr[J];
                    Arr[J] := Arr[J - 1];
                    Arr[J - 1] := Bufer;
                End;
    End;
    SortArr := Arr;
End;

Procedure SortEvenRow(Var Arr: TwoSizeArr);
Var
    I: Integer;
Begin
    If High(Arr) > 0 Then
    Begin
        I := 1;
        While (I < Length(Arr)) Do
        Begin
            Arr[I] := SortArr(Arr[I]);
            Inc(I, 2);
        End;
    End;
End;

Procedure FillGrid(Size: Integer; Grid: TStringGrid);
Var
    I: Integer;
Begin
    Grid.Visible := True;
    If Size > 3 Then
    Begin
        Grid.Width := (Grid.DefaultColWidth + 3) * 4 + 24;
        Grid.Height := (Grid.DefaultRowHeight + 3) * 4 + 25;
    End
    Else
    Begin
        Grid.Width := (Grid.DefaultColWidth + 3) * (Size+1);
        Grid.Height := (Grid.DefaultRowHeight + 3) * (Size+1);
    End;
    Grid.Enabled := True;
    Grid.ColCount := Size+1;
    Grid.RowCount := Size+1;
    Grid.Cells[0, 0] := '    \';
    For I := 1 To Size Do
        Grid.Cells[I, 0] := IntToStr(I);
    For I := 1 To Size Do
        Grid.Cells[0, I] := IntToStr(I);
    For I := 1 To Size Do
        Grid.Cells[0, I] := IntToStr(I);
End;

Procedure ClearGrid(Grid: TStringGrid);
Var
    J, I: Integer;
Begin
    Grid.Visible := False;
    For I := 0 To Grid.ColCount - 1 Do
        For J := 0 To Grid.RowCount - 1 Do
            Grid.Cells[I, J] := '';
    Grid.Enabled := False;
End;

Procedure FillSecondGrid(Grid: TStringGrid; Arr: TwoSizeArr; Size: Integer);
Var
    I, J: Integer;
Begin
    FillGrid(Size, Grid);
    For I := 0 To Grid.ColCount - 2 Do
        For J := 0 To Grid.RowCount - 2 Do
            Grid.Cells[I+1, J+1] := IntToStr(Arr[J, I]);
End;

Procedure TForm1.CheckButtonClick(Sender: TObject);
Var
    Arr: TwoSizeArr;
    I, J: Integer;
Begin
    SetLength(Arr, StrToInt(Edit1.Text), StrToInt(Edit1.Text));
    For I := 0 To StringGrid1.RowCount - 2 Do
        For J := 0 To StringGrid1.ColCount - 2 Do
            Arr[J, I] := StrToInt(StringGrid1.Cells[I+1, J+1]);
    SortEvenRow(Arr);
    Label3.Visible := True;
    FillSecondGrid(StringGrid2, Arr, StrToInt(Edit1.Text));
    N4.Enabled := True;
    IsSaved := False;
End;

Procedure TForm1.Edit1Change(Sender: TObject);
Begin
    ClearGrid(StringGrid2);
    Label3.Visible := False;
    If Edit1.Text = '' Then
    Begin
        Label2.Visible := False;
        ClearGrid(StringGrid1);
    End
    Else
    Begin
        Label2.Visible := True;
        ClearGrid(StringGrid1);
        FillGrid(StrToInt(Edit1.Text), StringGrid1);
    End;
End;

Procedure TForm1.Edit1KeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
    If ((SsShift In Shift) Or (SsCtrl In Shift)) And
      Not((Key = VK_RIGHT) Or (Key = VK_LEFT)) Then
        Key := 0;
    If Key = VK_DELETE Then
        Key := 0;
    If (Key = VK_DOWN) And (StringGrid1.Visible) Then
        StringGrid1.SetFocus;
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

Procedure TotalKeyPress(Var Key: Char; SelStart, SelLength: Integer; Const MIN, MAX: Integer; Text: String; IsNumPositive: Boolean = False);
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
            if SelStart = 0 then
                Key := VOID;
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
                If (ResultNum > MAX) Or (ResultNum < MIN) Then
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
Var
    ResultNum: Integer;
Begin
    TotalKeyPress(Key, Edit1.SelStart, Edit1.SelLength, MIN_SIZE, MAX_SIZE, Edit1.Text, True);
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
    Edit1.Text := '';
End;

Function ReadOneFromFile(Var Numb: Integer; Var MyFile: TextFile; isElemRead: Boolean = True): ERRORS_CODE;
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
        if IsElemRead then
            If (NumbInt > MAX_NUMB) Or (NumbInt < MIN_NUMB) Then
                Err := OUT_OF_BORDER
            Else
                Numb := NumbInt
        Else
            If (NumbInt > MAX_SIZE) Or (NumbInt < MIN_SIZE) Then
                Err := OUT_OF_BORDER_SIZE
            Else
                Numb := NumbInt;
    ReadOneFromFile := Err;
End;

Procedure TForm1.N2Click(Sender: TObject);
Var
    InfFile: TextFile;
    Size, I, J: Integer;
    Arr: TwoSizeArr;
    Err: ERRORS_CODE;
Begin
    Err := SUCCESS;
    I := 0;
    J := 0;
    If OpenTextFileDialog1.Execute() Then
    Begin
        AssignFile(InfFile, OpenTextFileDialog1.FileName);
        Reset(InfFile);
        Err := ReadOneFromFile(Size, InfFile, False);
        If Err = SUCCESS Then
        Begin
            SetLength(Arr, Size, Size);
            while (I < Size) And (Err = SUCCESS) do
            Begin
                while (J < Size) And (Err = SUCCESS) do
                Begin
                    if Eof(InfFile) then
                        Err := A_LOT_OF_DATA_FILE;
                    Err := ReadOneFromFile(Arr[I][J], InfFile);
                    Inc(J);
                End;
                J := 0;
                Inc(I);
            End;
        End;
        if Not EoF(InfFile) then
            Err := A_LOT_OF_DATA_FILE;
        if Err = SUCCESS then
        Begin
            Edit1.Text := IntToStr(Size);
            FillGrid(Size, StringGrid1);
            for I := 0 to High(Arr) do
                for J := 0 to High(Arr) do
                    StringGrid1.Cells[J+1, I+1] := IntToStr(Arr[I][J]);
            CheckButton.Enabled := True;
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
    I, J: Integer;
Begin
    If SaveTextFileDialog1.Execute() Then
    Begin
        AssignFile(OutFile, SaveTextFileDialog1.FileName);
        Rewrite(OutFile);
        Writeln(OutFile, Label2.Caption);
        With StringGrid1 do
            for I := 1 to RowCount-1 do
            Begin
                for J := 1 to ColCount-1 do
                    Write(OutFile, Cells[J, I] + ' ');
                Write(OutFile, #13#10);
            End;
        Writeln(OutFile, Label3.Caption);
        With StringGrid2 do
            for I := 1 to RowCount-1 do
            Begin
                for J := 1 to ColCount-1 do
                    Write(OutFile, Cells[J, I] + ' ');
                Write(OutFile, #13#10);
            End;
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

Function IsAllCellFill(Grid: TStringGrid; Key: Char; SelStart: Integer): Boolean;
Var
    IsFilled: Boolean;
    I, J: Integer;
Begin
    IsFilled := True;
    For I := 1 To Grid.ColCount - 1 Do
        For J := 1 To Grid.RowCount - 1 Do
    Begin
        if (Grid.Col = I) And (Grid.Row = j) And Not (Key = VOID) then
        Begin
            if (Grid.Cells[I, J] = '') And Not CharInSet(Key, DIGITS) then
                isFilled := False;

            If (Length(Grid.Cells[I, J]) = 1) And ((Key = BACKSPACE) And (SelStart = 1)) then
                IsFilled := False;

            if (Length(Grid.Cells[I, J]) = 2) And (Key = BACKSPACE) And
               (SelStart = 2) And (Grid.Cells[I, J][1] = '-') then
                IsFilled := False;
        End
        Else
            If (Grid.Cells[I, J] = '') Or (Grid.Cells[I, 1] = '-') Then
            IsFilled := False;
    End;
    IsAllCellFill := IsFilled;
End;

Procedure TForm1.StringGrid1KeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
    If ((SsShift In Shift) Or (SsCtrl In Shift)) And
      Not((Key = VK_RIGHT) Or (Key = VK_LEFT)) Then
        Key := 0;
    If Key = VK_DELETE Then
        Key := 0;
    If (Key = VK_RETURN) And (CheckButton.Enabled) Then
        CheckButton.Click;
    If (Key = VK_DOWN) And CheckButton.Enabled And (StringGrid1.Row = StringGrid1.RowCount) Then
        CheckButton.SetFocus;
    If (Key = VK_UP) And (StringGrid1.Row = 1) Then
        Edit1.SetFocus;

End;

Procedure TForm1.StringGrid1KeyPress(Sender: TObject; Var Key: Char);
Var
    GridCel: TGridCracker;
    EditingCell: TInplaceEdit;
    ResultNum, RBorder: Integer;
    Buffer: String;
Begin
    GridCel := TGridCracker(Sender);
    EditingCell := GridCel.InplaceEditor; // некае гамно
    TotalKeyPress(Key, EditingCell.SelStart, EditingCell.SelLength, MIN_NUMB, MAX_NUMB, EditingCell.Text);
    If IsAllCellFill(GridCel, Key, EditingCell.SelStart) then
        CheckButton.Enabled := True
    Else
    Begin
        CheckButton.Enabled := False;
        ClearGrid(StringGrid2);
        Label3.Visible := False;
    End;
    if Not (Key = VOID) then
    Begin
        ClearGrid(StringGrid2);
        Label3.Visible := False;
    End;
End;

End.
