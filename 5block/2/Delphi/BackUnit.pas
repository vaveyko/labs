Unit BackUnit;

Interface

Uses
    SysUtils, TreeUnit, VCL.Graphics;

Const
    INFTEXT = '–азработать программу сли€ни€ двух односв€зных упор€доченных по '
      + 'неубыванию линейных списков в один упор€доченный список.';
    VOID = #0;
    BACKSPACE = #8;
    MAX_NODE = 99999;
    MIN_NODE = -99999;
    LAYER_SIZE = 70;
    NODE_SIZE = 60;
    B_PADDING = 50;
    FONT_SIZE = 8;

Procedure TotalKeyPress(Var Key: Char; SelStart, SelLength: Integer;
  Const MIN, MAX: Integer; Text: String);
Function CountOfSymbolInt(Num: Integer): Integer;
Function InsertKey(Index: Integer; SubStr: Char; SelLen: Integer;
  Text: String): String;
Function Pow(Base, Degree: Integer): Integer;
Procedure PrintTree(Node: TNodePointer; Canvas: TCanvas;
  LBorder, RBorder, Layer, Num: Integer);

Implementation

Procedure PrintTree(Node: TNodePointer; Canvas: TCanvas;
  LBorder, RBorder, Layer, Num: Integer);
Var
    Center, TextX, TextY, CurLayer: Integer;
    Text: String;
Begin
    If Node <> Nil Then
        With Canvas Do
        Begin
            Center := LBorder + (RBorder - LBorder) Div 2;
            CurLayer := Layer * LAYER_SIZE;

            // draw line from previous Node
            LineTo(Center, CurLayer + NODE_SIZE Div 2);

            // set some settings
            if Node^.Data = Num then
                Canvas.Brush.Color := ClRed
            Else
                Canvas.Brush.Color := ClWhite;
            Canvas.Font.Color := ClBlack;
            Canvas.Font.Size := FONT_SIZE;

            // draw Node
            Ellipse(Center - NODE_SIZE Div 2, CurLayer,
              Center + NODE_SIZE Div 2, CurLayer + NODE_SIZE);

            // draw Node data
            Text := IntToStr(Node^.Data);
            TextX := Center - TextWidth(Text) Div 2;
            TextY := CurLayer + (NODE_SIZE - TextHeight(Text)) Div 2;
            TextOut(TextX, TextY, Text);

            MoveTo(Center, CurLayer + NODE_SIZE);
            If Node^.Right <> Nil Then
                PrintTree(Node^.Right, Canvas, Center, RBorder, Layer + 1, Num);

            MoveTo(Center, CurLayer + NODE_SIZE);
            If Node^.Left <> Nil Then
                PrintTree(Node^.Left, Canvas, LBorder, Center, Layer + 1, Num);
        End;

End;

Function Pow(Base, Degree: Integer): Integer;
Var
    Number: Integer;
    I: Integer;
Begin
    Number := 1;
    If Degree > 0 Then
    Begin
        Number := 1;
        For I := 1 To Degree Do
            Number := Number * Base;
    End;
    Pow := Number;
End;

Function InsertKey(Index: Integer; SubStr: Char; SelLen: Integer;
  Text: String): String;
Var
    ResultText: String;
Begin
    ResultText := Text;
    If (SubStr = BACKSPACE) And (SelLen = 0) Then
        Delete(ResultText, Index, 1)
    Else
    Begin
        Delete(ResultText, Index + 1, SelLen);
        If Substr <> BACKSPACE Then
            ResultText.Insert(Index, String(SubStr));
    End;

    InsertKey := ResultText;
End;

Function CountOfSymbolInt(Num: Integer): Integer;
Var
    NumLen: Integer;
Begin
    NumLen := 0;
    If Num < 0 Then
        Inc(NumLen);
    Repeat
        Inc(NumLen);
        Num := Num Div 10;
    Until (Num = 0);
    CountOfSymbolInt := NumLen;
End;

Procedure TotalKeyPress(Var Key: Char; SelStart, SelLength: Integer;
  Const MIN, MAX: Integer; Text: String);
Var
    ResultNum, RBorder, NumLen: Integer;
    Buffer, Output: String;
Begin
    Output := InsertKey(SelStart, Key, SelLength, Text);
    If (Length(Output) <> 0) And (Output <> '-') Then
    Begin
        Try
            ResultNum := StrToInt(Output);
        Except
            Key := VOID;
        End;
        If Key <> VOID Then
        Begin
            NumLen := CountOfSymbolInt(ResultNum);
            If NumLen <> Length(Output) Then
                Key := VOID;
            If (ResultNum > MAX) Or (ResultNum < MIN) Then
                Key := VOID;
        End;
    End
    Else If (Output = '-') And (MIN >= 0) Then
        Key := VOID;
End;

End.
