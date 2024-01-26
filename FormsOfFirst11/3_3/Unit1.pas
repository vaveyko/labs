Unit Unit1;

Interface

Uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
    System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtDlgs, Vcl.Menus, Vcl.StdCtrls,
    Unit2, Unit3, Unit4, Vcl.Grids, Vcl.Buttons, Vcl.Mask, Vcl.ExtCtrls,
    Vcl.DBCtrls;

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
        Label1: TLabel;
        Label2: TLabel;
        StringGrid2: TStringGrid;
        Button1: TButton;
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
        Procedure Button1Click(Sender: TObject);
    procedure CheckButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    Private
        { Private declarations }
    Public
        Form4: TForm4;
    End;

Type
    TArray = Array Of Integer;
    ERRORS_CODE = (SUCCESS, INCORRECT_DATA_FILE, A_LOT_OF_DATA_FILE,
      OUT_OF_BORDER, OUT_OF_BORDER_SIZE);
    TGridCracker = Class(TStringGrid);

Const
    INFTEXT = 'Отсортировать массив методом естественных двухпутевых вставок.';
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

Function MergeWithPointers(Var Arr, PointersArr: TArray): TArray;
Var
    Start1, Stop1, Start2, Stop2: Integer;
    I, J, Counter, SizeArr, PointerInd: Integer;
    MergedArr: TArray;
Begin
    I := 0;
    Counter := Length(PointersArr) - Length(PointersArr) Mod 4;
    SizeArr := Length(PointersArr) Div 2;
    PointerInd := 0;
    SetLength(MergedArr, Length(Arr));
    Repeat
        Start1 := PointersArr[PointerInd];
        Inc(PointerInd);
        Stop1 := PointersArr[PointerInd];
        Inc(PointerInd);
        Start2 := PointersArr[PointerInd];
        Inc(PointerInd);
        Stop2 := PointersArr[PointerInd];
        Inc(PointerInd);
        While (Start1 < Stop1) And (Start2 < Stop2) Do
            If Arr[Start1] > Arr[Start2] Then
            Begin
                MergedArr[I] := Arr[Start2];
                Inc(I);
                Inc(Start2);
            End
            Else
            Begin
                MergedArr[I] := Arr[Start1];
                Inc(I);
                Inc(Start1);
            End;
        While Start1 < Stop1 Do
        Begin
            MergedArr[I] := Arr[Start1];
            Inc(I);
            Inc(Start1);
        End;
        While Start2 < Stop2 Do
        Begin
            MergedArr[I] := Arr[Start2];
            Inc(I);
            Inc(Start2);
        End;

    Until (PointerInd = Counter) Or (PointersArr[PointerInd] = 0);
    If (I < SizeArr) Then
        For J := PointersArr[PointerInd] To PointersArr[PointerInd + 1] - 1 Do
        Begin
            MergedArr[I] := Arr[J];
            Inc(I);
        End;
    MergeWithPointers := MergedArr;
End;

Procedure FillWithZero(Var Arr: TArray);
Var
    I: Integer;
Begin
    For I := 0 To High(Arr) Do
        Arr[I] := 0;
End;

Procedure FillNextLine(Arr, PointersArr: TArray; Form4: TForm4);
var
  I, J, CurCell, CountSections, CountCells, Delta: Integer;
Begin
    With Form4.StringGrid1 Do
    Begin
        CountSections := 1;
        while (CountSections < Length(PointersArr)) And (PointersArr[CountSections] > 0) do
            Inc(CountSections, 2);

        ColCount := ColCount + 1;
        CountCells := Length(Arr) + ((CountSections div 2) - 1);
        if ColCount = 2 then
            RowCount := CountCells + 1;
            // CountElements + CountSpaces + OneFixedCol

        Cells[ColCount-1, 0] := IntToStr(ColCount-1) + '.';

        Delta := (RowCount-1 - CountCells) div 2;
        J := 1;
        I := PointersArr[J-1];
        CurCell := 1;
        while (J < Length(PointersArr)) And (PointersArr[J] > 0) do
        Begin
            For I := PointersArr[J-1] to PointersArr[J]-1 do
            Begin
                Cells[ColCount-1, CurCell + Delta] := IntToStr(Arr[I]);
                Inc(CurCell);
            End;
            Inc(CurCell);
            Inc(J, 2);
        End;


    End;
End;

Function MergeSort(Var Arr: TArray; Form4: TForm4): TArray;
Var
    I, PointInd, SizePointers: Integer;
    PointersArr: TArray;
Begin
    SizePointers := 2 * Length(Arr);
    SetLength(PointersArr, SizePointers);
    Repeat
        FillWithZero(PointersArr);
        PointInd := 0;
        PointersArr[PointInd] := 0;
        Inc(PointInd);
        For I := 1 To High(Arr) Do
            If Arr[I] < Arr[I - 1] Then
            Begin
                PointersArr[PointInd] := I;
                Inc(PointInd);
                PointersArr[PointInd] := I;
                Inc(PointInd);
            End;
        PointersArr[PointInd] := Length(Arr);

        FillNextLine(Arr, PointersArr, Form4);

        Arr := MergeWithPointers(Arr, PointersArr);

    Until PointersArr[1] = Length(Arr);
    MergeSort := Arr;
End;

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

Procedure TForm1.Button1Click(Sender: TObject);
var
  I, Delta: Integer;
Begin
    With self.Form4.StringGrid1 do
    Begin
        Width := (DefaultColWidth + 3) * 6 + 25;
        Height := (DefaultRowHeight + 2) * 15;
        Delta := (RowCount-1 - StringGrid1.ColCount) div 2;
        Cells[0, 0] := '0.';
        for I := 0 to StringGrid1.ColCount-1 do
            Cells[0, I+1 + Delta] := StringGrid1.Cells[I, 1];
        Enabled := True;
    End;
    Self.Form4.ShowModal;
End;

procedure TForm1.Button1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if (Key = VK_UP) then
        StringGrid1.SetFocus;
end;

Procedure TForm1.CheckButtonClick(Sender: TObject);
Var
    Arr: TArray;
    I: Integer;
Begin
    SetLength(Arr, StringGrid1.ColCount);
    For I := 0 To StringGrid1.ColCount - 1 Do
        Arr[I] := StrToInt(StringGrid1.Cells[I, 1]);
    Arr := MergeSort(Arr, Self.Form4);

    StringGrid2.Visible := True;
    Button1.Visible := True;
    FillGrid(Length(Arr), StringGrid2);
    For I := 0 To High(Arr) Do
        StringGrid2.Cells[I, 1] := IntToStr(Arr[I]);

    (Sender as TButton).Enabled := False;
    Button1.SetFocus;
    N4.Enabled := True;
    IsSaved := False;
End;

procedure TForm1.CheckButtonKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key = VK_UP then
        StringGrid1.SetFocus;
    if (Key = VK_RIGHT) And (Button1.Visible) then
    Button1.SetFocus;
end;

Procedure TForm1.Edit1Change(Sender: TObject);
Begin
    ClearGrid(StringGrid2);
    CheckButton.Enabled := False;
    StringGrid2.Visible := False;
    Button1.Visible := False;
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
        If (SelLen = 0) Then
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
    Self.Form4 := TForm4.Create(Self);
    InfLabel.Caption := INFTEXT;
    Edit1.Text := '';
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

Procedure TForm1.N2Click(Sender: TObject);
Var
    InfFile: TextFile;
    Size, I: Integer;
    Arr: Array Of Integer;
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
            While (I < Size) And (Err = SUCCESS) Do
            Begin
                If Eof(InfFile) Then
                    Err := A_LOT_OF_DATA_FILE;
                Err := ReadOneFromFile(Arr[I], InfFile);
                Inc(I);
            End;
        End;
        If Err = SUCCESS Then
        Begin
            Edit1.Text := IntToStr(Size);
            FillGrid(Size, StringGrid1);
            For I := 0 To High(Arr) Do
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
        Writeln(OutFile, 'Исходный массив:');
        With StringGrid1 Do
            For I := 0 To ColCount Do
                Write(OutFile, Cells[I, 1] + ' ');
        Writeln(OutFile, #13#10 + 'Отсортированный массив:');
        With StringGrid2 Do
            For I := 0 To ColCount Do
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

Function IsAllCellFill(Grid: TStringGrid; Key: Char;
  Col, SelStart: Integer): Boolean;
Var
    IsFilled: Boolean;
    I: Integer;
Begin
    IsFilled := True;
    For I := 0 To Grid.ColCount - 1 Do
    Begin
        If (Col = I) And Not(Key = VOID) Then
        Begin
            If (Grid.Cells[I, 1] = '') And Not CharInSet(Key, DIGITS) Then
                IsFilled := False;

            If (Length(Grid.Cells[I, 1]) = 1) And
              ((Key = BACKSPACE) And (SelStart = 1)) Then
                IsFilled := False;

            If (Length(Grid.Cells[I, 1]) = 2) And (Key = BACKSPACE) And
              (SelStart = 2) And (Grid.Cells[I, 1][1] = '-') Then
                IsFilled := False;
        End
        Else If (Grid.Cells[I, 1] = '') Or (Grid.Cells[I, 1] = '-') Then
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
            If EditingCell.SelStart = 0 Then
                Key := VOID;
        End
        Else
        Begin
            RBorder := EditingCell.SelStart + EditingCell.SelLength;
            If (EditingCell.SelStart = 0) And
              (EditingCell.GetTextLen > EditingCell.SelLength) And
              (EditingCell.Text[EditingCell.SelLength + 1] = '0') And
              (EditingCell.GetTextLen > RBorder + 1) Then
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
    If IsAllCellFill(StringGrid1, Key, StringGrid1.Col,
      EditingCell.SelStart) Then
    Begin
        CheckButton.Enabled := True;
        If (Key <> VOID) Then
        Begin
            ClearGrid(StringGrid2);
            StringGrid2.Visible := False;
            Button1.Visible := False;
            ClearGrid(Form4.StringGrid1);
            N4.Enabled := False;
            IsSaved := False;
        End;
    End
    Else
    Begin
        CheckButton.Enabled := False;
        ClearGrid(StringGrid2);
        StringGrid2.Visible := False;
        Button1.Visible := False;
        ClearGrid(Form4.StringGrid1);
        N4.Enabled := False;
        IsSaved := False;
    End;

End;

End.
