Unit AddUnit;

Interface

Uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
    System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
    BackUnit, LinkedListUnit;

Type
    TAddForm = Class(TForm)
        AddButton: TButton;
        CancelButton: TButton;
        NewElemEdit: TEdit;
        NewElemLabel: TLabel;
        Procedure NewElemEditKeyPress(Sender: TObject; Var Key: Char);
        Procedure FormCreate(HeadPt: ListPointer; Sender: TObject);
        Procedure AddButtonClick(Sender: TObject);
        Procedure FormShow(Sender: TObject);
        Procedure NewElemEditChange(Sender: TObject);
        Procedure NewElemEditKeyDown(Sender: TObject; Var Key: Word;
          Shift: TShiftState);
    Private
        HeadPt: ListPointer;
    Public
        { Public declarations }
    End;

Var
    AddForm: TAddForm;

Implementation

{$R *.dfm}

Procedure TAddForm.AddButtonClick(Sender: TObject);
Begin
    Add(HeadPt, StrToInt(NewElemEdit.Text));
End;

Procedure TAddForm.FormCreate(HeadPt: ListPointer; Sender: TObject);
Begin
    Self.HeadPt := HeadPt;
End;

Procedure TAddForm.FormShow(Sender: TObject);
Begin
    NewElemEdit.SetFocus();
End;

Procedure TAddForm.NewElemEditChange(Sender: TObject);
Begin
    AddButton.Enabled := NewElemEdit.Text <> '';
End;

Procedure TAddForm.NewElemEditKeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
    If (Key = VK_RETURN) And (AddButton.Enabled) Then
        AddButton.Click();
    If ((SsShift In Shift) Or (SsCtrl In Shift)) And
      Not((Key = VK_RIGHT) Or (Key = VK_LEFT)) Then
        Key := 0;
    If Key = VK_DELETE Then
        Key := 0;
End;

Procedure TAddForm.NewElemEditKeyPress(Sender: TObject; Var Key: Char);
Begin
    With NewElemEdit Do
        TotalKeyPress(Key, SelStart, SelLength, MIN_NUMB, MAX_NUMB, Text);
End;

End.
