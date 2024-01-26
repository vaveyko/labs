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
        StringGrid1: TStringGrid;
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

Const
    INFTEXT = 'Дана последовательность х1 ,х2 ,…,хn . Найти номер элемента, который '
               + 'отличается от среднего арифметического значения элементов '
               + 'последовательности на минимальную величину.';
    DIGITS = ['0' .. '9'];
    VOID = #0;
    BACKSPACE = #8;
    MAX_NUMB = MaxInt Div 100;
    MIN_NUMB = -MaxInt Div 100;
    MAX_SIZE = 100;
    MIN_SIZE = 1;
    ERRORS: Array [ERRORS_CODE] Of String = ('Successfull',
      'Данные в файле не корректные', 'В файле неверное количество элементов',
      'Числа должны быть в диапазоне [-21474836, 21474836]',
      'Размер должен быть в диапазоне [0, 100]');

Var
    Form1: TForm1;
    IsSaved: Boolean = True;

Implementation

{$R *.dfm}

Procedure FillGrid(ColNum: Integer; Grid: TStringGrid);
Var
    I: Integer;
Begin
    If ColNum > 5 Then
    Begin
        Grid.Width := (Grid.DefaultColWidth + 3) * 5;
        Grid.Height := Grid.DefaultRowHeight * 3;
    End
    Else
    Begin
        Grid.Width := (Grid.DefaultColWidth + 4) * ColNum;
        Grid.Height := (Grid.DefaultRowHeight + 4) * 2;
    End;
    Grid.Enabled := True;
    Grid.ColCount := ColNum;
    For I := 0 To ColNum - 1 Do
        Grid.Cells[I, 0] := IntToStr(I + 1);
End;

Procedure ClearGrid(Grid: TStringGrid);
Var
    J, I: Integer;
Begin
    For I := 0 To Grid.ColCount - 1 Do
        For J := 0 To Grid.RowCount - 1 Do
            Grid.Cells[I, J] := '';
    Grid.ColCount := 0;
    Grid.Enabled := False;
End;

Function FindIndexMidle(ArrOfNum: Array of Integer): Integer;
Var
    Index, I, Sum: Integer;
    Average, AbsDistanse, MinAbsDistanse: Real;
Begin
    Sum := 0;
    Index := 0;
    For I := 0 To High(ArrOfNum) Do
        Sum := Sum + ArrOfNum[I];
    Average := Sum / Length(ArrOfNum);
    MinAbsDistanse := Abs(Average - ArrOfNum[0]);
    For I := 0 To High(ArrOfNum) Do
    Begin
        AbsDistanse := Abs(Average - ArrOfNum[I]);
        If AbsDistanse < MinAbsDistanse Then
        Begin
            MinAbsDistanse := AbsDistanse;
            Index := I;
        End;
    End;
    FindIndexMidle := Index + 1;
End;

Procedure TForm1.CheckButtonClick(Sender: TObject);
Var
    Arr: Array Of Integer;
    I: Integer;
Begin
    SetLength(Arr, StringGrid1.ColCount);
    For I := 0 To StringGrid1.ColCount - 1 Do
        Arr[I] := StrToInt(StringGrid1.Cells[I, 1]);
    Edit2.Text := IntToStr(FindIndexMidle(Arr));
    N4.Enabled := True;
    IsSaved := False;
End;

Procedure TForm1.Edit1Change(Sender: TObject);
Begin
    Edit2.Text := '';
    If Edit1.Text = '' Then
    Begin
        StringGrid1.Visible := False;
        Label2.Visible := False;
        ClearGrid(StringGrid1);
    End
    Else
    Begin
        StringGrid1.Visible := True;
        Label2.Visible := True;
        ClearGrid(StringGrid1);
        FillGrid(StrToInt(Edit1.Text), StringGrid1);
    End;
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

Procedure TForm1.Edit1KeyPress(Sender: TObject; Var Key: Char);
Var
    ResultNum: Integer;
Begin
    If (Edit1.SelStart = 0) And (Key = '0') Then
        Key := VOID;
    If Key = BACKSPACE Then
    Begin
        If Edit1.SelLength = 0 Then
        Begin
            If (Edit1.SelStart = 1) And (Length(Edit1.Text) > 1) And
              (Edit1.Text[Edit1.SelStart + 1] = '0') Then
                Key := VOID;
        End
        Else If (Edit1.GetTextLen > Edit1.SelLength) And
          (Edit1.Text[Edit1.SelLength + 1] = '0') Then
            Key := VOID;
    End
    Else If CharInSet(Key, DIGITS) Then
    Begin
        ResultNum := StrToInt(InsertKey(Edit1.SelStart, Key, Edit1.SelLength,
          Edit1.Text));
        If (ResultNum > MAX_SIZE) Or (ResultNum < MIN_SIZE) Then
            Key := VOID;
    End
    Else
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
    Size, I: Integer;
    Arr: Array of Integer;
    Err: ERRORS_CODE;
Begin
    Err := SUCCESS;
    I := 0;
    If OpenTextFileDialog1.Execute() Then
    Begin
        AssignFile(InfFile, OpenTextFileDialog1.FileName);
        Reset(InfFile);
        Err := ReadOneFromFile(Size, InfFile, False);
        If Err = SUCCESS Then
        Begin
            SetLength(Arr, Size);
            while (I < Size) And (Err = SUCCESS) do
            Begin
                if Eof(InfFile) then
                    Err := A_LOT_OF_DATA_FILE;
                Err := ReadOneFromFile(Arr[I], InfFile);
                Inc(I);
            End;
        End;
        if Err = SUCCESS then
        Begin
            Edit1.Text := IntToStr(Size);
            FillGrid(Size, StringGrid1);
            for I := 0 to High(Arr) do
                StringGrid1.Cells[I, 1] := IntToStr(Arr[I]);
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
    I: Integer;
Begin
    If SaveTextFileDialog1.Execute() Then
    Begin
        AssignFile(OutFile, SaveTextFileDialog1.FileName);
        Rewrite(OutFile);
        Write(OutFile, 'Номер элемента, который ближе всего к среднему арифметическому элементов последовательности: ');
        Writeln(OutFile, Edit2.Text);
        With StringGrid1 do
            for I := 0 to ColCount do
                Write(OutFile, Cells[I, 1] + ' ');
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

Function IsAllCellFill(Grid: TStringGrid; Key: Char; Col, SelStart: Integer): Boolean;
Var
    IsFilled: Boolean;
    I: Integer;
Begin
    IsFilled := True;
    For I := 0 To Grid.ColCount - 1 Do
    Begin
        if (Col = I) And Not (Key = VOID) then
        Begin
            if (Grid.Cells[I, 1] = '') And Not CharInSet(Key, DIGITS) then
                isFilled := False;

            If (Length(Grid.Cells[I, 1]) = 1) And ((Key = BACKSPACE) And (SelStart = 1)) then
                IsFilled := False;

            if (Length(Grid.Cells[I, 1]) = 2) And (Key = BACKSPACE) And
               (SelStart = 2) And (Grid.Cells[I, 1][1] = '-') then
                IsFilled := False;
        End
        Else
            If (Grid.Cells[I, 1] = '') Or (Grid.Cells[I, 1] = '-') Then
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
    If (Key = VK_DOWN) And CheckButton.Enabled Then
        CheckButton.SetFocus;
    If Key = VK_UP Then
        Edit1.SetFocus;

End;

Procedure TForm1.StringGrid1KeyPress(Sender: TObject; Var Key: Char);
Var
    GridSel: TGridCracker;
    EditingCell: TInplaceEdit;
    ResultNum, RBorder: Integer;
    Buffer: String;
Begin
    GridSel := TGridCracker(Sender);
    EditingCell := GridSel.InplaceEditor; // некае гамно
    If (Key = '0') Then
    Begin
        If (EditingCell.SelStart = 0) Then
        Begin
            With StringGrid1 Do
                Buffer := Key + Cells[Col, Row];
            If (Length(Buffer) > 1) And
              Not(EditingCell.SelLength = EditingCell.GetTextLen) Then
                Key := VOID;
        End
        Else
        Begin
            With StringGrid1 Do
                Buffer := Cells[Col, Row];
            If (Buffer[EditingCell.SelStart] = '-') Or
              ((Buffer[EditingCell.SelStart] = '0') And
              (EditingCell.SelStart = 1)) Then
                Key := VOID;
        End;
    End;
    If (Key = BACKSPACE) Then
    Begin
        If EditingCell.SelLength = 0 Then
        Begin
            If (EditingCell.SelStart = 1) And (EditingCell.GetTextLen > 1) And
              (EditingCell.Text[EditingCell.SelStart + 1] = '0') Then
                Key := VOID;
            If (EditingCell.SelStart = 2) And (EditingCell.GetTextLen > 2) And
              (EditingCell.Text[EditingCell.SelStart + 1] = '0') And
              (EditingCell.Text[1] = '-') Then
                Key := VOID;
        End
        Else
        Begin
            RBorder := EditingCell.SelStart + EditingCell.SelLength;
            If (EditingCell.SelStart = 0) And
              (EditingCell.GetTextLen > EditingCell.SelLength) And
              (EditingCell.Text[EditingCell.SelLength + 1] = '0') And (EditingCell.GetTextLen > RBorder + 1) Then
                Key := VOID;
            If (EditingCell.SelStart = 1) And
              (EditingCell.GetTextLen - EditingCell.SelLength > 1) And
              (EditingCell.Text[RBorder + 1] = '0') And
              (EditingCell.Text[1] = '-') Then
                Key := VOID;
        End;
    End
    Else If (Key = '-') And (EditingCell.SelStart = 0) Then
    Begin
        With StringGrid1 Do
            Buffer := InsertKey(EditingCell.SelStart, Key,
                  EditingCell.SelLength, Cells[Col, Row]);
        If (Length(Buffer) > 1) And
          ((Buffer[2] = '-') Or (Buffer[2] = '0')) Then
            Key := VOID;
    End
    Else If CharInSet(Key, DIGITS) Then
    Begin
        With StringGrid1 Do
        Begin
            If (EditingCell.GetTextLen > 0) And (Cells[Col, Row][1] = '-') And
              (EditingCell.SelStart = 0) And (EditingCell.SelLength = 0) Then
                Key := VOID
            Else If (Cells[Col, Row] = '0') And (EditingCell.SelStart = 1) Then
                Key := VOID
            Else
            Begin
                ResultNum := StrToInt(InsertKey(EditingCell.SelStart, Key,
                  EditingCell.SelLength, Cells[Col, Row]));
                If (ResultNum > MAX_NUMB) Or (ResultNum < MIN_NUMB) Then
                    Key := VOID;
            End;
        End;
    End
    Else
        Key := VOID;
    If IsAllCellFill(StringGrid1, Key, StringGrid1.Col, EditingCell.SelStart) Then
    Begin
        CheckButton.Enabled := True;
        if Not (Key = VOID) then
        Begin
            Edit2.Text := '';
            N4.Enabled := False;
            IsSaved := False;
        End;
    End
    Else
    Begin
        CheckButton.Enabled := False;
        Edit2.Text := '';
        N4.Enabled := False;
        IsSaved := False;
    End;

End;

End.
