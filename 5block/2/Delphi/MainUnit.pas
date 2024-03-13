Unit MainUnit;

Interface

Uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
    System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
    Vcl.ExtCtrls, Vcl.Grids, Vcl.Menus,
    TreeUnit, BackUnit, DevInfUnit, ManualUnit;

Type
    TMainForm = Class(TForm)
        AddButton: TButton;
        NewNodeEdit: TEdit;
        MainPaintBox: TPaintBox;
        ScrollBox: TScrollBox;
        Timer: TTimer;
        FreeButton: TButton;
        StringGrid1: TStringGrid;
        MainMenu: TMainMenu;
        ManualButtonMenu: TMenuItem;
        DeveloperButtonMenu: TMenuItem;
        PopupMenu: TPopupMenu;
        TaskLabel: TLabel;
        Procedure AddButtonClick(Sender: TObject);
        Procedure FreeButtonClick(Sender: TObject);
        Procedure FormCreate(Sender: TObject);
        Procedure MainPaintBoxPaint(Sender: TObject);
        Procedure NewNodeEditKeyPress(Sender: TObject; Var Key: Char);
        Procedure FormResize(Sender: TObject);
        Procedure NewNodeEditChange(Sender: TObject);
        Procedure NewNodeEditKeyDown(Sender: TObject; Var Key: Word;
          Shift: TShiftState);
        Procedure AddElemToGrid(Grid: TStringGrid; Elem: Integer);
        Procedure StringGrid1Click(Sender: TObject);
        Procedure ErrMessage();
        Procedure DeveloperButtonMenuClick(Sender: TObject);
        Procedure ManualButtonMenuClick(Sender: TObject);
        Procedure FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Var
    MainForm: TMainForm;
    Tree: TTree;
    ChoosedNum: Integer;
    Node: TNodePointer;
Implementation

{$R *.dfm}

//Function GetHigh(): Integer; StdCall; External 'AwesomeLibrary.dll';
//Function Add(Elem: Integer): Boolean; StdCall; External 'AwesomeLibrary.dll';
//Procedure CreateTree(); StdCall; External 'AwesomeLibrary.dll';
//Procedure DeleteTree(); StdCall; External 'AwesomeLibrary.dll';

Procedure ClearGrid(Grid: TStringGrid);
Var
    J, I: Integer;
Begin
    Grid.Visible := False;
    For I := 0 To Grid.ColCount - 1 Do
        For J := 0 To Grid.RowCount - 1 Do
            Grid.Cells[I, J] := '';
    Grid.ColCount := 1;
End;

Procedure TMainForm.AddButtonClick(Sender: TObject);
Var
    NewNodeData, MaxCountOfNode, TreeHigh: Integer;
    IsAdded: Boolean;
Begin
    NewNodeData := StrToInt(NewNodeEdit.Text);
    NewNodeEdit.Text := '';
    If Add(Tree^.Next, NewNodeData) Then
    Begin
        AddElemToGrid(StringGrid1, NewNodeData);
        ChoosedNum := NewNodeData;
    End
    Else
        ErrMessage();

    If Tree^.Next <> Nil Then
        FreeButton.Enabled := True;

    TreeHigh := GetHigh(Tree^.Next);
    MaxCountOfNode := Pow(2, TreeHigh - 1);

    MainPaintBox.Width := NODE_SIZE * MaxCountOfNode;
    MainPaintBox.Height := LAYER_SIZE * TreeHigh;

    MainPaintBox.Canvas.MoveTo(MainPaintBox.Width Div 2, NODE_SIZE Div 2);
    PrintTree(Tree^.Next, MainPaintBox.Canvas, 0, MainPaintBox.Width, 0,
      ChoosedNum);
End;

Procedure TMainForm.AddElemToGrid(Grid: TStringGrid; Elem: Integer);
Begin
    With Grid Do
    Begin
        If Visible Then
        Begin
            ColCount := ColCount + 1;
        End
        Else
            Visible := True;
        Cells[ColCount - 1, 0] := IntToStr(ColCount) + '.';
        Cells[ColCount - 1, 1] := IntToStr(Elem);
    End;
End;

Procedure TMainForm.DeveloperButtonMenuClick(Sender: TObject);
Var
    DeveloperForm: TDeveloperForm;
Begin
    DeveloperForm := TDeveloperForm.Create(Self);
    DeveloperForm.ShowModal;
    DeveloperForm.Free;
End;

Procedure TMainForm.ErrMessage;
Begin
    Application.MessageBox('Такой элемент уже существует', 'Ошибочка',
      MB_OK + MB_ICONASTERISK + MB_DEFBUTTON2)
End;

Procedure TMainForm.FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
Begin
    Case Application.MessageBox('Вы точно хотите выйти?', 'Выход',
      MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2) Of
        IDYES:
            CanClose := True;
        IDNO:
            CanClose := False;
    End;
End;

Procedure TMainForm.FormCreate(Sender: TObject);
Begin
    Tree := CreateTree();

    NewNodeEdit.Left := B_PADDING;
    NewNodeEdit.Top := B_PADDING;

    AddButton.Top := B_PADDING;
    FreeButton.Top := B_PADDING;
    StringGrid1.Top := B_PADDING + FreeButton.Height + 3;
    StringGrid1.Left := B_PADDING;
End;

Procedure TMainForm.FormResize(Sender: TObject);
Begin
    ScrollBox.Left := B_PADDING;
    ScrollBox.Width := Self.ClientWidth - B_PADDING - ScrollBox.Left;
    ScrollBox.Height := Self.ClientHeight - B_PADDING - ScrollBox.Top;

    StringGrid1.Width := ScrollBox.Width;
    TaskLabel.Left := B_PADDING;
End;

Procedure TMainForm.FreeButtonClick(Sender: TObject);
Begin
    DeleteTree(Tree^.Next);
    FreeButton.Enabled := False;

    ClearGrid(StringGrid1);

    MainPaintBox.OnPaint(Sender);
End;

Procedure TMainForm.MainPaintBoxPaint(Sender: TObject);
Begin
    With MainPaintBox.Canvas Do
    Begin
        Pen.Width := 3;
        Brush.Color := ClMenu;
        FillRect(MainPaintBox.ClientRect);
    End;
    MainPaintBox.Canvas.MoveTo(MainPaintBox.Width Div 2, NODE_SIZE Div 2);
    PrintTree(Tree^.Next, MainPaintBox.Canvas, 0, MainPaintBox.Width, 0,
      ChoosedNum);
End;

Procedure TMainForm.ManualButtonMenuClick(Sender: TObject);
Var
    ManualForm: TManualForm;
Begin
    ManualForm := TManualForm.Create(Self);
    ManualForm.ShowModal;
    ManualForm.Free;
End;

Procedure TMainForm.NewNodeEditChange(Sender: TObject);
Begin
    With Sender As TEdit Do
        If (Text <> '') And (Text <> '-') Then
            AddButton.Enabled := True
        Else
            AddButton.Enabled := False;
End;

Procedure TMainForm.NewNodeEditKeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
    If ((SsShift In Shift) Or (SsCtrl In Shift)) And
      Not((Key = VK_RIGHT) Or (Key = VK_LEFT)) Then
        Key := 0;
    If Key = VK_DELETE Then
        Key := 0;
    If (Key = VK_RETURN) And AddButton.Enabled Then
        AddButton.Click();
End;

Procedure TMainForm.NewNodeEditKeyPress(Sender: TObject; Var Key: Char);
Begin
    With Sender As TEdit Do
        TotalKeyPress(Key, SelStart, SelLength, MIN_NODE, MAX_NODE, Text);
End;

Procedure TMainForm.StringGrid1Click(Sender: TObject);
Begin
    With Sender As TStringGrid Do
        ChoosedNum := StrToInt(Cells[Col, Row]);
    MainPaintBox.OnPaint(Sender);
End;

End.
