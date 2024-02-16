Unit ChangeRecUnit;

Interface

Uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
    System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, BackEndUnit;

Type
    TChangeRecForm = Class(TForm)
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
        ChangeRecButton: TButton;
        Procedure ChangeRecButtonClick(Sender: TObject);
        Function IsAllFieldCorrect(): Boolean;
        Procedure AnyEditChange(Sender: TObject);
        Procedure AgeEditKeyPress(Sender: TObject; Var Key: Char);
        Procedure RecCostEditKeyPress(Sender: TObject; Var Key: Char);
        Procedure RecCountEditKeyPress(Sender: TObject; Var Key: Char);
        Procedure FormCreate(RecIndex: Integer; Sender: TObject);
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
        CurIndex: Integer;
    Public
        { Public declarations }
    End;

Var
    ChangeRecForm: TChangeRecForm;

Implementation

{$R *.dfm}

Procedure TChangeRecForm.ChangeRecButtonClick(Sender: TObject);
Var
    CurToy: RToy;
Begin
    CurToy.Name := RecNameEdit.Text;
    CurToy.Cost := StrToInt(RecCostEdit.Text);
    CurToy.Count := StrToInt(RecCountEdit.Text);
    CurToy.MinAge := StrToInt(MinAgeEdit.Text);
    CurToy.MaxAge := StrToInt(MaxAgeEdit.Text);
    ChangeToy(CurIndex, CurToy);
End;

Procedure TChangeRecForm.FormCreate(RecIndex: Integer; Sender: TObject);
Var
    CurToy: RToy;
Begin
    CurIndex := RecIndex;
    CurToy := GetRecFromFile(CurIndex);
    RecNameEdit.Text := CurToy.Name;
    RecCostEdit.Text := IntToStr(CurToy.Cost);
    RecCountEdit.Text := IntToStr(CurToy.Count);
    MinAgeEdit.Text := IntToStr(CurToy.MinAge);
    MaxAgeEdit.Text := IntToStr(CurToy.MaxAge);
End;

Function TChangeRecForm.IsAllFieldCorrect(): Boolean;
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

Procedure TChangeRecForm.AnyEditChange(Sender: TObject);
Begin
    ChangeRecButton.Enabled := IsAllFieldCorrect();
End;

Procedure TChangeRecForm.MaxAgeEditKeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
    If ((SsShift In Shift) Or (SsCtrl In Shift)) And
      Not((Key = VK_RIGHT) Or (Key = VK_LEFT)) Then
        Key := 0;
    If Key = VK_DELETE Then
        Key := 0;
    If (Key = VK_RETURN) And ChangeRecButton.Enabled Then
        ChangeRecButton.Click();
    If (Key = VK_DOWN) And ChangeRecButton.Enabled Then
        ChangeRecButton.SetFocus();
    If (Key = VK_UP) Or (Key = VK_LEFT) Then
        MinAgeEdit.SetFocus();
End;

Procedure TChangeRecForm.AgeEditKeyPress(Sender: TObject; Var Key: Char);
Begin
    With Sender as TEdit Do
        TotalKeyPress(Key, SelStart, SelLength, MIN_AGE, MAX_AGE, Text);
End;

Procedure TChangeRecForm.MinAgeEditKeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
    If ((SsShift In Shift) Or (SsCtrl In Shift)) And
      Not((Key = VK_RIGHT) Or (Key = VK_LEFT)) Then
        Key := 0;
    If Key = VK_DELETE Then
        Key := 0;
    If (Key = VK_RETURN) And ChangeRecButton.Enabled Then
        ChangeRecButton.Click();
    If (Key = VK_DOWN) Or (Key = VK_RIGHT) Or (Key = VK_RETURN) Then
        MaxAgeEdit.SetFocus();
    If (Key = VK_UP) Then
        RecCountEdit.SetFocus();
End;

Procedure TChangeRecForm.RecCostEditKeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
    If ((SsShift In Shift) Or (SsCtrl In Shift)) And
      Not((Key = VK_RIGHT) Or (Key = VK_LEFT)) Then
        Key := 0;
    If Key = VK_DELETE Then
        Key := 0;
    If (Key = VK_RETURN) And ChangeRecButton.Enabled Then
        ChangeRecButton.Click();
    If (Key = VK_RETURN) Or (Key = VK_DOWN) Then
        RecCountEdit.SetFocus();
    If (Key = VK_UP) Then
        RecNameEdit.SetFocus();
End;

Procedure TChangeRecForm.RecCostEditKeyPress(Sender: TObject; Var Key: Char);
Begin
    With RecCostEdit Do
        TotalKeyPress(Key, SelStart, SelLength, MIN_COST, MAX_COST, Text);
End;

Procedure TChangeRecForm.RecCountEditKeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
    If ((SsShift In Shift) Or (SsCtrl In Shift)) And
      Not((Key = VK_RIGHT) Or (Key = VK_LEFT)) Then
        Key := 0;
    If Key = VK_DELETE Then
        Key := 0;
    If (Key = VK_RETURN) And ChangeRecButton.Enabled Then
        ChangeRecButton.Click();
    If (Key = VK_RETURN) Or (Key = VK_DOWN) Then
        MinAgeEdit.SetFocus();
    If (Key = VK_UP) Then
        RecCostEdit.SetFocus();
End;

Procedure TChangeRecForm.RecCountEditKeyPress(Sender: TObject; Var Key: Char);
Begin
    With RecCountEdit Do
        TotalKeyPress(Key, SelStart, SelLength, MIN_COUNT, MAX_COUNT, Text);
End;

Procedure TChangeRecForm.RecNameEditKeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
    If ((SsShift In Shift) Or (SsCtrl In Shift)) And
      Not((Key = VK_RIGHT) Or (Key = VK_LEFT)) Then
        Key := 0;
    If Key = VK_DELETE Then
        Key := 0;
    If (Key = VK_RETURN) And ChangeRecButton.Enabled Then
        ChangeRecButton.Click();
    If (Key = VK_RETURN) Or (Key = VK_DOWN) Then
        RecCostEdit.SetFocus();
End;

End.
