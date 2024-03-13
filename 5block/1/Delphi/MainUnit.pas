Unit MainUnit;

Interface

Uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Forms,
    Vcl.ExtDlgs, Vcl.Menus, Vcl.StdCtrls, Vcl.Grids, Vcl.Dialogs, Vcl.Controls,
    ManualUnit, DevInfUnit, AddUnit, BackUnit, LinkedListUnit;

Type
    TManeForm = Class(TForm)
        MainMenu: TMainMenu;
        FileButtonMenu: TMenuItem;
        LineMenu: TMenuItem;
        ExitButtonMenu: TMenuItem;
        ManualButtonMenu: TMenuItem;
        DeveloperButtonMenu: TMenuItem;
        PopupMenu: TPopupMenu;
        SaveTextFileDialog: TSaveTextFileDialog;
        CheckButton: TButton;
        InfLabel: TLabel;
        FirstListLabel: TLabel;
        SecondListLabel: TLabel;
        SecondListGrid: TStringGrid;
        AddFirstButton: TButton;
        AddSecondButton: TButton;
        SaveButtonMenu: TMenuItem;
        FirstListGrid: TStringGrid;
        MergedListGrid: TStringGrid;
        Procedure ManualButtonMenuClick(Sender: TObject);
        Procedure DeveloperButtonMenuClick(Sender: TObject);
        Procedure FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
        Procedure ExitButtonMenuClick(Sender: TObject);
        Procedure FormCreate(Sender: TObject);
        Procedure SaveButtonMenuClick(Sender: TObject);
        Procedure ListGridKeyPress(Sender: TObject; Var Key: Char);
        Procedure ListGridKeyDown(Sender: TObject; Var Key: Word;
          Shift: TShiftState);
        Procedure AddFirstButtonClick(Sender: TObject);
        Procedure AddSecondButtonClick(Sender: TObject);
        Procedure CheckButtonClick(Sender: TObject);
        Function FormHelp(Command: Word; Data: NativeInt;
          Var CallHelp: Boolean): Boolean;
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Type
    TGridCracker = Class(TStringGrid);

Var
    ManeForm: TManeForm;
    IsSaved: Boolean = True;
    FirstHead, SecondHead: ListPointer;

Implementation

{$R *.dfm}

Procedure FillGrid(HeadPt: ListPointer; Grid: TStringGrid);
Var
    I, Size: Integer;
Begin
    Grid.Visible := True;
    Size := Len(HeadPt);
    If Size > 5 Then
    Begin
        Grid.Width := (Grid.DefaultColWidth + 3) * 5;
        Grid.Height := (Grid.DefaultRowHeight + 3) * 2 + 25;
    End
    Else
    Begin
        Grid.Width := (Grid.DefaultColWidth + 4) * Size;
        Grid.Height := (Grid.DefaultRowHeight + 3) * 2;
    End;
    Grid.ColCount := Size;
    Grid.RowCount := 2;
    For I := 0 To Size - 1 Do
    Begin
        HeadPt := HeadPt^.Next;
        Grid.Cells[I, 0] := IntToStr(I + 1);
        Grid.Cells[I, 1] := IntToStr(HeadPt^.Data);
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
    New(FirstHead);
    FirstHead^.Next := Nil;
    New(SecondHead);
    SecondHead^.Next := Nil;
    InfLabel.Caption := INFTEXT;
End;

Function TManeForm.FormHelp(Command: Word; Data: NativeInt;
  Var CallHelp: Boolean): Boolean;
Begin
    ManualButtonMenu.Click();
    CallHelp := False;
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

Procedure TManeForm.SaveButtonMenuClick(Sender: TObject);
Var
    OutFile: TextFile;
    I, J: Integer;
Begin
    If SaveTextFileDialog.Execute() Then
    Begin
        AssignFile(OutFile, SaveTextFileDialog.FileName);
        Rewrite(OutFile);

        Writeln(OutFile, 'Merget List');
        For I := 0 To MergedListGrid.ColCount - 1 Do
            Write(OutFile, MergedListGrid.Cells[I, 1] + ' ');

        CloseFile(OutFile);
        IsSaved := True;
    End;
End;

Procedure TManeForm.ManualButtonMenuClick(Sender: TObject);
Var
    ManualForm: TManualForm;
Begin
    ManualForm := TManualForm.Create(Self);
    ManualForm.ShowModal;
    ManualForm.Free;
End;

Procedure TManeForm.AddFirstButtonClick(Sender: TObject);
Var
    AddForm: TAddForm;
    Res: TModalResult;
    NewElem: Integer;
Begin
    AddForm := TAddForm.Create(Self);
    AddForm.FormCreate(FirstHead, Self);
    Res := AddForm.ShowModal();
    If Res = MrOk Then
    Begin
        FillGrid(FirstHead, FirstListGrid);
        ClearGrid(MergedListGrid);
    End;
    AddForm.Free();
    If FirstListGrid.Visible And SecondListGrid.Visible Then
        CheckButton.Enabled := True;
End;

Procedure TManeForm.AddSecondButtonClick(Sender: TObject);
Var
    AddForm: TAddForm;
    Res: TModalResult;
    NewElem: Integer;
Begin
    AddForm := TAddForm.Create(Self);
    AddForm.FormCreate(SecondHead, Self);
    Res := AddForm.ShowModal();
    If Res = MrOk Then
        FillGrid(SecondHead, SecondListGrid);
    AddForm.Free();
    If FirstListGrid.Visible And SecondListGrid.Visible Then
        CheckButton.Enabled := True;
End;

Procedure TManeForm.CheckButtonClick(Sender: TObject);
Var
    MergedHead: ListPointer;
Begin
    New(MergedHead);
    Merge(MergedHead, FirstHead, SecondHead);
    FillGrid(MergedHead, MergedListGrid);
    SaveButtonMenu.Enabled := True;
    IsSaved := False;
End;

Procedure TManeForm.DeveloperButtonMenuClick(Sender: TObject);
Var
    DeveloperForm: TDeveloperForm;
Begin
    DeveloperForm := TDeveloperForm.Create(Self);
    DeveloperForm.ShowModal;
    DeveloperForm.Free;
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

Procedure TManeForm.ListGridKeyDown(Sender: TObject; Var Key: Word;
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

End;

Procedure TManeForm.ListGridKeyPress(Sender: TObject; Var Key: Char);
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
    Begin
        SaveButtonMenu.Enabled := False;
    End;
End;

End.
