Unit FindRecUnit;

Interface

Uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
    System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, BackEndUnit;

Type
    TFindRecForm = Class(TForm)
        RecordsGrid: TStringGrid;
        AgeCharacterLabel: TLabel;
        CostCharacterLabel: TLabel;
        AgeEdit: TEdit;
        RecCostEdit: TEdit;
        Procedure AgeEditKeyPress(Sender: TObject; Var Key: Char);
        Procedure RecCostEditKeyPress(Sender: TObject; Var Key: Char);
        Procedure RecCostEditKeyDown(Sender: TObject; Var Key: Word;
          Shift: TShiftState);
        Procedure AgeEditKeyDown(Sender: TObject; Var Key: Word;
          Shift: TShiftState);
        Procedure FormCreate(Sender: TObject);
        Procedure AnyEditChange(Sender: TObject);
    Private
        Procedure WriteCorrectRecToFile(Path: String);
        Function IsAllFieldCorrect(): Boolean;
    Public
        { Public declarations }
    End;

Var
    FindRecForm: TFindRecForm;

Implementation

{$R *.dfm}

Procedure TFindRecForm.AgeEditKeyPress(Sender: TObject; Var Key: Char);
Begin
    With Sender As TEdit Do
        TotalKeyPress(Key, SelStart, SelLength, MIN_AGE, MAX_AGE, Text);
End;

Procedure TFindRecForm.WriteCorrectRecToFile(Path: String);
Var
    CorrectionFile, BufferFile: TToyFile;
    I, Age, MaxCost: Integer;
    Toy: RToy;
Begin
    Age := StrToInt(AgeEdit.Text);
    MaxCost := StrToInt(RecCostEdit.Text);

    OpenFile(СORRECTION_FILE_PATH, CorrectionFile, FmReset);
    OpenFile(BUFFER_FILE_PATH, BufferFile, FmRewrite);

    For I := 1 To FileSize(CorrectionFile) Do
    Begin
        Read(CorrectionFile, Toy);
        If (Toy.Cost <= MaxCost) And (Toy.MinAge <= Age) Then
            Write(BufferFile, Toy);
    End;

    CloseFile(CorrectionFile);
    CloseFile(BufferFile);
End;

Procedure TFindRecForm.FormCreate(Sender: TObject);
Begin
    // Draw FixedRow information
    RecordsGrid.Cells[0, 0] := '№';
    RecordsGrid.Cells[1, 0] := 'Название';
    RecordsGrid.Cells[2, 0] := 'Цена(BYN)';
    RecordsGrid.Cells[3, 0] := 'Количество';
    RecordsGrid.Cells[4, 0] := 'Возраст';

    WriteCorrectRecToFile(BUFFER_FILE_PATH);
    DrawRecordOnGrid(RecordsGrid, BUFFER_FILE_PATH);
    DeleteFile(BUFFER_FILE_PATH);

End;

Function TFindRecForm.IsAllFieldCorrect: Boolean;
Var
    IsCorrect: Boolean;
Begin
    IsCorrect := (RecCostEdit.Text <> '') And (AgeEdit.Text <> '');
    IsAllFieldCorrect := IsCorrect;
End;

Procedure TFindRecForm.AnyEditChange(Sender: TObject);
Begin
    If IsAllFieldCorrect() Then
    Begin
        WriteCorrectRecToFile(BUFFER_FILE_PATH);
        DrawRecordOnGrid(RecordsGrid, BUFFER_FILE_PATH);
    End
    Else
        DrawRecordOnGrid(RecordsGrid, BUFFER_FILE_PATH);

    DeleteFile(BUFFER_FILE_PATH);
End;

Procedure TFindRecForm.AgeEditKeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
    If ((SsShift In Shift) Or (SsCtrl In Shift)) And
      Not((Key = VK_RIGHT) Or (Key = VK_LEFT)) Then
        Key := 0;
    If Key = VK_DELETE Then
        Key := 0;
    If (Key = VK_DOWN) Then
        RecCostEdit.SetFocus();
End;

Procedure TFindRecForm.RecCostEditKeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
    If ((SsShift In Shift) Or (SsCtrl In Shift)) And
      Not((Key = VK_RIGHT) Or (Key = VK_LEFT)) Then
        Key := 0;
    If Key = VK_DELETE Then
        Key := 0;
    If (Key = VK_UP) Then
        AgeEdit.SetFocus();
End;

Procedure TFindRecForm.RecCostEditKeyPress(Sender: TObject; Var Key: Char);
Begin
    With RecCostEdit Do
        TotalKeyPress(Key, SelStart, SelLength, MIN_COST, MAX_COST, Text);
End;

End.
