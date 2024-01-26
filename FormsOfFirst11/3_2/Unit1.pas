Unit Unit1;

Interface

Uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
    System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtDlgs, Vcl.Menus, Vcl.StdCtrls,
    Unit2, Unit3, Vcl.Grids;

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
    StringGrid1: TStringGrid;
    Label1: TLabel;
    Label2: TLabel;
    Edit2: TEdit;
    StringGrid2: TStringGrid;
    StringGrid3: TStringGrid;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
        Procedure N5Click(Sender: TObject);
        Procedure N6Click(Sender: TObject);
        Procedure FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
        Procedure N7Click(Sender: TObject);
        Procedure FormCreate(Sender: TObject);
        Procedure N2Click(Sender: TObject);
        Procedure N4Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Edit2KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure CheckButtonClick(Sender: TObject);
    procedure CheckButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Type
    ERRORS_CODE = (SUCCESS, INCORRECT_DATA_FILE, A_LOT_OF_DATA_FILE,
      OUT_OF_BORDER, INCORRECT_BORDERS);
    TSet = Set of Byte;

Const
    INFTEXT = 'Имеется множество, содержащее натуральные числа из некоторого'
              +' диапазона. Сформировать два множества, первое из которых содержит'
              +'все простые числа из данного множества, а второе все составные.';
    DIGITS = ['0' .. '9'];
    VOID = #0;
    BACKSPACE = #8;
    MAX_NUMB = 255;
    MIN_NUMB = 1;
    ERRORS: Array [ERRORS_CODE] Of String = ('Successfull',
      'Данные в файле не корректные', 'В файле должно быть только 2 числа',
      'Границы должны быть в диапазоне [1, 255]',
      'Границы множества неверные');

Var
    Form1: TForm1;
    IsSaved: Boolean = True;

Implementation

{$R *.dfm}

Function IsNumbSimple(Numb: Integer): Boolean;
Var
    IsSimple: Boolean;
    RightBord, I: Integer;
Begin
    RightBord := Trunc(Sqrt(Numb));
    IsSimple := True;
    if Numb > 3 then
        For I := 2 To RightBord Do
            If Numb Mod I = 0 Then
                IsSimple := False;
    IsNumbSimple := IsSimple;
End;

Function CreateSetWhithBorders(LBorder, RBorder: Integer): TSet;
Var
    NumSet: TSet;
    I: Byte;
Begin
    NumSet := [];
    for I := LBorder to RBorder do
        Include(NumSet, I);
    CreateSetWhithBorders := NumSet;
End;

Function GetSetOfSimple(DefaultSet: TSet): TSet;
Var
    SimpleSet: TSet;
    Numb: Byte;
Begin
    SimpleSet := [];
    For Numb in DefaultSet do
        If IsNumbSimple(Numb) then
            Include(SimpleSet, Numb);
    GetSetOfSimple := SimpleSet;
End;

Function GetSetOfComposit(DefaultSet, SimpleSet: TSet): TSet;
Var
    CompositSet: TSet;
Begin
    CompositSet := [];
    CompositSet := DefaultSet - SimpleSet;
    GetSetOfComposit := CompositSet;
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

Function IsBorderCorrect(LBorder, RBorder: Integer): Boolean;
Var
    IsCorrect: Boolean;
Begin
    IsCorrect := RBorder > LBorder;
    IsBorderCorrect := IsCorrect;
End;

Function LengthSet(NumbSet: TSet): Integer;
Var
    Len: Integer;
    Element: Integer;
Begin
    Len := 0;
    for Element in NumbSet do
        Inc(Len);
    LengthSet := Len;
End;

Procedure FillGrid(SomeSet: TSet; Grid: TStringGrid);
Var
    I, ColNum: Integer;
    Element: Byte;
Begin
    ColNum := LengthSet(SomeSet);
    If ColNum > 5 Then
    Begin
        Grid.DefaultColWidth := 100;
        Grid.Width := (Grid.DefaultColWidth + 3) * 5;
        Grid.Height := (Grid.DefaultRowHeight - 2) * 2;
        Grid.ScrollBars := ssHorizontal;
    End
    Else if ColNum > 0 then
    Begin
        Grid.Width := 100;
        Grid.DefaultColWidth := Grid.Width;
        Grid.Width := (Grid.DefaultColWidth + 4) * ColNum;
        Grid.Height := (Grid.DefaultRowHeight + 3) * 1;
        Grid.ScrollBars := ssNone;
    End
    Else
    Begin
        Grid.Width := 180;
        Grid.DefaultColWidth := Grid.Width;
        Grid.Height := (Grid.DefaultRowHeight + 3) * 1;
        Grid.ScrollBars := ssNone;
        Grid.Cells[0, 0] := 'не существует';
    End;
    Grid.Enabled := True;
    Grid.ColCount := ColNum;
    I := 0;
    for Element in SomeSet do
    Begin
        Grid.Cells[I, 0] := IntToStr(Element);
        Inc(I);
    End;
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

procedure TForm1.CheckButtonClick(Sender: TObject);
Var
    DefaultSet, SimpleSet, CompositeSet: TSet;
begin
    DefaultSet := CreateSetWhithBorders(StrToInt(Edit1.Text), StrToInt(Edit2.Text));
    SimpleSet := GetSetOfSimple(DefaultSet);
    CompositeSet := GetSetOfComposit(DefaultSet, SimpleSet);

    ClearGrid(StringGrid1);
    ClearGrid(StringGrid2);
    ClearGrid(StringGrid3);
    FillGrid(DefaultSet, StringGrid1);
    FillGrid(SimpleSet, StringGrid2);
    FillGrid(CompositeSet, StringGrid3);

    StringGrid1.Visible := True;
    Label5.Visible := True;
    StringGrid2.Visible := True;
    Label3.Visible := True;
    StringGrid3.Visible := True;
    Label4.Visible := True;

    IsSaved := False;
    N4.Enabled := True
end;

procedure TForm1.CheckButtonKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key = VK_LEFT then
        Edit2.SetFocus;
end;

procedure TForm1.Edit1Change(Sender: TObject);
Var
    RBorder, LBorder: Integer;
begin
    ClearGrid(StringGrid1);
    ClearGrid(StringGrid2);
    ClearGrid(StringGrid3);

    StringGrid1.Visible := False;
    Label5.Visible := False;
    StringGrid2.Visible := False;
    Label3.Visible := False;
    StringGrid3.Visible := False;
    Label4.Visible := False;

    if Edit2.Text <> '' then
    Begin
        RBorder := StrToInt(Edit2.Text);
        LBorder := StrToInt(Edit1.Text);
        if IsBorderCorrect(LBorder, RBorder) then
            CheckButton.Enabled := True
        Else
            CheckButton.Enabled := False;
        IsSaved := False;
        N4.Enabled := False;
    End;
end;

procedure TForm1.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    If ((SsShift In Shift) Or (SsCtrl In Shift)) And
      Not((Key = VK_RIGHT) Or (Key = VK_LEFT)) Then
        Key := 0;
    If Key = VK_DELETE Then
        Key := 0;
    if (Key = VK_RIGHT) And (Edit1.SelStart = Length(Edit1.Text)) And (Edit2.SelLength = 0) then
        Edit2.SetFocus;
end;

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
Var
    RBorder, LBorder: Integer;
begin
    TotalKeyPress(Key, Edit1.SelStart, Edit1.SelLength, Edit1.Text, True);
end;

procedure TForm1.Edit2Change(Sender: TObject);
Var
    RBorder, LBorder: Integer;
begin
    ClearGrid(StringGrid1);
    ClearGrid(StringGrid2);
    ClearGrid(StringGrid3);

    StringGrid1.Visible := False;
    Label5.Visible := False;
    StringGrid2.Visible := False;
    Label3.Visible := False;
    StringGrid3.Visible := False;
    Label4.Visible := False;

    if Edit2.Text <> '' then
    Begin
        RBorder := StrToInt(Edit2.Text);
        LBorder := StrToInt(Edit1.Text);
        if IsBorderCorrect(LBorder, RBorder) then
            CheckButton.Enabled := True
        Else
            CheckButton.Enabled := False;
        IsSaved := False;
        N4.Enabled := False;
    End;
end;

procedure TForm1.Edit2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
        If ((SsShift In Shift) Or (SsCtrl In Shift)) And
      Not((Key = VK_RIGHT) Or (Key = VK_LEFT)) Then
        Key := 0;
    If Key = VK_DELETE Then
        Key := 0;
    if (Key = VK_RIGHT) And (CheckButton.Enabled) And (Edit2.SelLength = 0) then
        CheckButton.SetFocus;
    if (Key = VK_LEFT) And (Edit2.SelStart = 0) And (Edit2.SelLength = 0) then
        Edit1.SetFocus;
end;

procedure TForm1.Edit2KeyPress(Sender: TObject; var Key: Char);
Var
    RBorder, LBorder: Integer;
begin
    TotalKeyPress(Key, Edit2.SelStart, Edit2.SelLength, Edit2.Text, True);
end;

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
        If (NumbInt > MAX_NUMB) Or (NumbInt < MIN_NUMB) Then
            Err := OUT_OF_BORDER
        Else
            Numb := NumbInt;
    ReadOneFromFile := Err;
End;

Procedure TForm1.N2Click(Sender: TObject);
Var
    InfFile: TextFile;
    LBorder, RBorder: Integer;
    Err: ERRORS_CODE;
Begin
    If OpenTextFileDialog1.Execute() Then
    Begin
        AssignFile(InfFile, OpenTextFileDialog1.FileName);
        Reset(InfFile);
        Err := ReadOneFromFile(LBorder, InfFile);
        if Err = SUCCESS then
            if EoF(InfFile) then
                Err := A_LOT_OF_DATA_FILE
            Else
            Begin
                Err := ReadOneFromFile(RBorder, InfFile);
                if Err = SUCCESS then
                Begin
                    if Not IsBorderCorrect(LBorder, RBorder) then
                        Err := INCORRECT_BORDERS;
                    if Not Eof(InfFile) then
                        Err := A_LOT_OF_DATA_FILE;
                End;
            End;
        if Err = SUCCESS then
        Begin
            Edit1.Text := IntToStr(LBorder);
            Edit2.Text := IntToStr(RBorder);
            CheckButton.Enabled := True;
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
    I: Integer;
Begin
    If SaveTextFileDialog1.Execute() Then
    Begin
        AssignFile(OutFile, SaveTextFileDialog1.FileName);
        Rewrite(OutFile);
        Write(OutFile, Label5.Caption + #13#10);
        With StringGrid1 do
            for I := 0 to ColCount do
                Write(OutFile, Cells[I, 0] + ' ');

        Write(OutFile, #13#10 + Label3.Caption + #13#10);
        With StringGrid2 do
            for I := 0 to ColCount do
                Write(OutFile, Cells[I, 0] + ' ');

        Write(OutFile, #13#10 + Label4.Caption + #13#10);
        With StringGrid3 do
            for I := 0 to ColCount do
                Write(OutFile, Cells[I, 0] + ' ');
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
