Unit AddRecUnit;

Interface

Uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
    System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, BackEndUnit;

Type
    TAddRecForm = Class(TForm)
        NameLabel: TLabel;
        CostLabel: TLabel;
        CountLabel: TLabel;
        AgeLabel: TLabel;
        FromLabel: TLabel;
        ToLabel: TLabel;
        RecNameEdit: TEdit;
        RecCostEdit: TEdit;
        RecCountEdit: TEdit;
        MinAgeEdit: TEdit;
        MaxAgeEdit: TEdit;
        AddRecButton: TButton;
        Procedure RecCostEditKeyPress(Sender: TObject; Var Key: Char);
        Procedure RecCountEditKeyPress(Sender: TObject; Var Key: Char);
        Procedure AgeEditKeyPress(Sender: TObject; Var Key: Char);
        Procedure AddRecButtonClick(Sender: TObject);
        Function IsAllFieldCorrect(): Boolean;
        Procedure AnyEditChange(Sender: TObject);
        Procedure RecNameEditKeyDown(Sender: TObject; Var Key: Word;
          Shift: TShiftState);
        Procedure RecCostEditKeyDown(Sender: TObject; Var Key: Word;
          Shift: TShiftState);
        Procedure RecCountEditKeyDown(Sender: TObject; Var Key: Word;
          Shift: TShiftState);
        Procedure MinAgeEditKeyDown(Sender: TObject; Var Key: Word;
          Shift: TShiftState);
        Procedure MaxAgeEditKeyDown(Sender: TObject; Var Key: Word;
          Shift: TShiftState);
    Private
        { Private declarations }
    Public
    End;

Var
    AddRecForm: TAddRecForm;

Implementation

{$R *.dfm}

Procedure TAddRecForm.AddRecButtonClick(Sender: TObject);
Var
    Toy: RToy;
Begin
    Toy.Name := RecNameEdit.Text;
    Toy.Cost := StrToInt(RecCostEdit.Text);
    Toy.Count := StrToInt(RecCountEdit.Text);
    Toy.MinAge := StrToInt(MinAgeEdit.Text);
    Toy.MaxAge := StrToInt(MaxAgeEdit.Text);
    AddRecord(Toy);
End;

Function TAddRecForm.IsAllFieldCorrect: Boolean;
Var
    LBorder, RBorder: Integer;
    IsAllFilled, IsCorrect: Boolean;
Begin
    IsAllFilled := (RecNameEdit.Text <> '') And (RecCostEdit.Text <> '') And
      (RecCountEdit.Text <> '') And (MinAgeEdit.Text <> '') And
      (MaxAgeEdit.Text <> '');
    If IsAllFilled Then
    Begin
        LBorder := StrToInt(MinAgeEdit.Text);
        RBorder := StrToInt(MAxAgeEdit.Text);
        IsCorrect := IsAllFilled And (LBorder < RBorder)
    End
    Else
        IsCorrect := False;
    IsAllFieldCorrect := IsCorrect;
End;

Procedure TAddRecForm.MaxAgeEditKeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
    If ((SsShift In Shift) Or (SsCtrl In Shift)) And
      Not((Key = VK_RIGHT) Or (Key = VK_LEFT)) Then
        Key := 0;
    If Key = VK_DELETE Then
        Key := 0;
    If (Key = VK_RETURN) And AddRecButton.Enabled Then
        AddRecButton.Click();
    If (Key = VK_DOWN) And AddRecButton.Enabled Then
        AddRecButton.SetFocus();
    If (Key = VK_UP) Or (Key = VK_LEFT) Then
        MinAgeEdit.SetFocus();
End;

Procedure TAddRecForm.AgeEditKeyPress(Sender: TObject; Var Key: Char);
Begin
    With Sender As TEdit Do
        TotalKeyPress(Key, SelStart, SelLength, MIN_AGE, MAX_AGE, Text);
End;

Procedure TAddRecForm.MinAgeEditKeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
    If ((SsShift In Shift) Or (SsCtrl In Shift)) And
      Not((Key = VK_RIGHT) Or (Key = VK_LEFT)) Then
        Key := 0;
    If Key = VK_DELETE Then
        Key := 0;
    If (Key = VK_RETURN) And AddRecButton.Enabled Then
        AddRecButton.Click();
    If (Key = VK_DOWN) Or (Key = VK_RIGHT) Or (Key = VK_RETURN) Then
        MaxAgeEdit.SetFocus();
    If (Key = VK_UP) Then
        RecCountEdit.SetFocus();
End;

Procedure TAddRecForm.AnyEditChange(Sender: TObject);
Begin
    AddRecButton.Enabled := IsAllFieldCorrect();
End;

Procedure TAddRecForm.RecCostEditKeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
    If ((SsShift In Shift) Or (SsCtrl In Shift)) And
      Not((Key = VK_RIGHT) Or (Key = VK_LEFT)) Then
        Key := 0;
    If Key = VK_DELETE Then
        Key := 0;
    If (Key = VK_RETURN) And AddRecButton.Enabled Then
        AddRecButton.Click();
    If (Key = VK_RETURN) Or (Key = VK_DOWN) Then
        RecCountEdit.SetFocus();
    If (Key = VK_UP) Then
        RecNameEdit.SetFocus();
End;

Procedure TAddRecForm.RecCostEditKeyPress(Sender: TObject; Var Key: Char);
Begin
    With RecCostEdit Do
        TotalKeyPress(Key, SelStart, SelLength, MIN_COST, MAX_COST, Text);
End;

Procedure TAddRecForm.RecCountEditKeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
    If ((SsShift In Shift) Or (SsCtrl In Shift)) And
      Not((Key = VK_RIGHT) Or (Key = VK_LEFT)) Then
        Key := 0;
    If Key = VK_DELETE Then
        Key := 0;
    If (Key = VK_RETURN) And AddRecButton.Enabled Then
        AddRecButton.Click();
    If (Key = VK_RETURN) Or (Key = VK_DOWN) Then
        MinAgeEdit.SetFocus();
    If (Key = VK_UP) Then
        RecCostEdit.SetFocus();
End;

Procedure TAddRecForm.RecCountEditKeyPress(Sender: TObject; Var Key: Char);
Begin
    With RecCountEdit Do
        TotalKeyPress(Key, SelStart, SelLength, MIN_COUNT, MAX_COUNT, Text);
End;

Procedure TAddRecForm.RecNameEditKeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
    If ((SsShift In Shift) Or (SsCtrl In Shift)) And
      Not((Key = VK_RIGHT) Or (Key = VK_LEFT)) Then
        Key := 0;
    If Key = VK_DELETE Then
        Key := 0;
    If (Key = VK_RETURN) And AddRecButton.Enabled Then
        AddRecButton.Click();
    If (Key = VK_RETURN) Or (Key = VK_DOWN) Then
        RecCostEdit.SetFocus();
End;

End.
