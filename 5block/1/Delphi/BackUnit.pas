Unit BackUnit;

Interface

Uses
    SysUtils;

Type
    ERRORS_CODE = (SUCCESS, INCORRECT_DATA_FILE, A_LOT_OF_DATA_FILE,
      OUT_OF_BORDER, OUT_OF_BORDER_SIZE);
    IntArr = Array Of Integer;
    Matrix = Array Of IntArr;

Const
    INFTEXT = 'Разработать программу слияния двух односвязных упорядоченных по '
      + 'неубыванию линейных списков в один упорядоченный список.';
    DIGITS = ['0' .. '9'];
    VOID = #0;
    BACKSPACE = #8;
    MAX_NUMB = 99999999;
    MIN_NUMB = 0;
    MAX_SIZE = 9;
    MIN_SIZE = 1;
    ERRORS: Array [ERRORS_CODE] Of String = ('Successfull',
      'Данные в файле некорректные',
      'В файле неверное количество элементов или стоит лишний пробел',
      'Числа должны быть в диапазоне [-70, 70]',
      'Размер должен быть в диапазоне [1, 5]');

Procedure TotalKeyPress(Var Key: Char; SelStart, SelLength: Integer;
  Const MIN, MAX: Integer; Text: String);
Function CountOfSymbolInt(Num: Integer): Integer;
Function InsertKey(Index: Integer; SubStr: Char; SelLen: Integer;
  Text: String): String;

Implementation

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
