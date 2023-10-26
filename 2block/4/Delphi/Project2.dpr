Program Project2;

Uses
    System.SysUtils;

Type
    TArray = Array Of Char;

Const
    MIN_ELEM = -MaxInt - 1;
    MAX_ELEM = MaxInt;
    ERRORS: Array [0 .. 9] Of String = ('Successfull',
      'Data is not correct, or number is too large',
      'Enter the number within the borders', 'This is not a .txt file',
      'This file is not exist',
      'Data in file is not correct, or number is too large',
      'There is only one number in file should be (without whitespace)',
      'File is can not be opened', 'File is can not be opened',
      'File is not exist');

Procedure PrintInf();
Begin
    Writeln('Program converts decimal to hexadecimal');
End;

Function GetLenOfNum(Num: Integer): Integer;
Var
    Len: Integer;
Begin
    Len := 1;
    While Num > 9 Do
    Begin
        Inc(Len);
        Num := Num Div 10;
    End;
    GetLenOfNum := Len;
End;

Procedure FillWithZero(Var Arr: Array Of Char);
Var
    I: Integer;
Begin
    For I := 0 To High(Arr) Do
        Arr[I] := '0';
End;

Function IntToHexArr(Num: Integer; IsNumNegative: Boolean): TArray;
Const
    HEX_ELEM: Array [0 .. 16] Of Char = ('0', '1', '2', '3', '4', '5', '6', '7',
      '8', '9', 'A', 'B', 'C', 'D', 'E', 'F', '-');
Var
    Index, Size: Integer;
    Arr: TArray;
Begin
    If IsNumNegative Then
        Num := -Num;
    Index := 0;
    Size := GetLenOfNum(Num);
    SetLength(Arr, Size);
    FillWithZero(Arr);
    If Num > 15 Then
        While Num > 1 Do
        Begin
            Arr[Index] := HEX_ELEM[Num Mod 16];
            Num := Num Div 16;
            Inc(Index);
        End
    Else
    Begin
        Arr[Index] := HEX_ELEM[Num];
        Inc(Index);
    End;

    If IsNumNegative Then
        Arr[Index] := HEX_ELEM[16];
    IntToHexArr := Arr;
End;

Function ReversArr(Arr: TArray): TArray;
Var
    ReversedArr: TArray;
    Index, I: Integer;
Begin
    Index := 0;
    I := High(Arr);
    SetLength(ReversedArr, Length(Arr));
    While Index < Length(Arr) Do
    Begin
        ReversedArr[Index] := Arr[I];
        Dec(I);
        Inc(Index);
    End;
    ReversArr := ReversedArr;
End;

Function InpValidNum(Var Num: Integer; Const MIN, MAX: Integer): Integer;
Var
    IsCorrect: Boolean;
    Err: Integer;
Begin
    Err := 0;
    Try
        Readln(Num);
        IsCorrect := True;
    Except
        Err := 1;
        IsCorrect := False;
    End;
    If IsCorrect And ((Num < MIN) Or (Num > MAX)) Then
    Begin
        Err := 2;
    End;
    InpValidNum := Err;
End;

Function UserChoice(): Integer;
Var
    Choice, Err: Integer;
Begin
    Writeln('Choose a way of input/output of data', #13#10, '1 -- Console',
      #13#10, '2 -- File');
    Err := InpValidNum(Choice, 1, 2);
    While (Err > 0) Do
    Begin
        Writeln(ERRORS[Err]);
        Writeln('Please, enter again');
        Err := InpValidNum(Choice, 1, 2);
    End;
    UserChoice := Choice;
End;

Procedure InputFromConsole(Var Num: Integer);
Var
    Err: Integer;
Begin
    Writeln('Enter the number from ', MIN_ELEM, ' to ', MAX_ELEM);
    Err := InpValidNum(Num, MIN_ELEM, MAX_ELEM);
    While Err > 0 Do
    Begin
        Writeln(ERRORS[Err]);
        Writeln('Please, enter again');
        Err := InpValidNum(Num, MIN_ELEM, MAX_ELEM);
    End;
End;

Function FileAvailable(Name: String; ForReset: Boolean): Integer;
Var
    Err: Integer;
    MyFile: TextFile;
Begin
    Err := 0;
    AssignFile(MyFile, Name);
    If ForReset Then
        Try
            Try
                Reset(MyFile);
            Finally
                Close(MyFile);
            End;
        Except
            Err := 7;
        End
    Else
        Try
            Try
                Rewrite(MyFile);
            Finally
                Close(MyFile);
            End;
        Except
            Err := 8;
        End;
    FileAvailable := Err;
End;

Function FileTxt(Name: String): Integer;
Var
    Err: Integer;
Begin
    Err := 0;
    If ExtractFileExt(Name) <> '.txt' Then
        Err := 3;
    FileTxt := Err;
End;

Function FileExist(Name: String): Integer;
Var
    Err: Integer;
Begin
    Err := 0;
    If Not FileExists(Name) Then
        Err := 9;
    FileExist := Err;
End;

Function GetFileName(ForReset: Boolean): String;
Var
    IsCorrect: Boolean;
    ErrExist, ErrTxt, ErrAvailable: Integer;
    FileName: String;
Begin
    Repeat
        IsCorrect := True;
        Readln(FileName);
        ErrExist := FileExist(FileName);
        ErrTxt := FileTxt(FileName);
        If (ErrExist > 0) Then
        Begin
            Writeln(ERRORS[9]);
            IsCorrect := False;
        End
        Else If (ErrTxt > 0) Then
        Begin
            Writeln(ERRORS[ErrTxt]);
            IsCorrect := False;
        End;
        if ((ErrExist = 0) And (ErrTxt = 0)) then
        Begin
            ErrAvailable := FileAvailable(FileName, ForReset);
            If (ErrAvailable > 0) Then
            Begin
                Writeln(ERRORS[ErrAvailable]);
                IsCorrect := False;
            End;
        End;
    Until IsCorrect;
    GetFileName := FileName;
End;

Function ReadFile(Var Num: Integer; Name: String): Integer;
Var
    Err: Integer;
    IsCorrect: Boolean;
    InfFile: TextFile;
Begin
    AssignFile(InfFile, Name);
    Reset(InfFile);
    IsCorrect := True;
    Err := 0;
    Try
        Read(InfFile, Num);
    Except
        Err := 5;
        IsCorrect := False;
    End;
    If IsCorrect And ((Num < MIN_ELEM) Or (Num > MAX_ELEM)) Then
    Begin
        IsCorrect := False;
        Err := 2;
    End;
    If IsCorrect And Not EoF(InfFile) Then
    Begin
        IsCorrect := False;
        Err := 6;
    End;
    CloseFile(InfFile);
    ReadFile := Err;
End;

Procedure InputFromFile(Var Num: Integer);
Var
    Err: Integer;
    FileName: String;
Begin
    Writeln('Enter full path to file');
    FileName := GetFileName(True);
    Err := ReadFile(Num, FileName);
    While (Err > 0) Do
    Begin
        Writeln(ERRORS[Err]);
        Writeln('Please, enter full path again');
        FileName := GetFileName(True);
        Err := ReadFile(Num, FileName);
    End;
    Writeln('Reading is successfull');

End;

Function InputInf(): Integer;
Var
    Num, Choice: Integer;
Begin
    Choice := UserChoice();
    If (Choice = 1) Then
        InputFromConsole(Num)
    Else
        InputFromFile(Num);
    InputInf := Num;
End;

Function GetArrOfHexDigit(Num: Integer): TArray;
Var
    Size: Integer;
    IsNumNegative: Boolean;
    Arr: TArray;
Begin
    IsNumNegative := Num < 0;
    Arr := IntToHexArr(Num, IsNumNegative);
    GetArrOfHexDigit := ReversArr(Arr);
End;

Procedure OutputInConsole(Num: Integer; Arr: TArray);
Var
    Index, I: Integer;
Begin
    Index := 0;
    Writeln('Decimal number:');
    Writeln(Num);
    Writeln('Hexadecimal number:');
    If (High(Arr) > 0) Then
    Begin
        While (Arr[Index] = '0') Do
            Inc(Index);
        For I := Index To High(Arr) Do
            Write(Arr[I]);
    End
    Else
        Writeln(Arr[Index]);
End;

Procedure OutputInFile(Num: Integer; Arr: TArray);
Var
    Index, I: Integer;
    FileName: String;
    MyFile: TextFile;
Begin
    Writeln('Enter full path to file');
    FileName := GetFileName(False);
    AssignFile(MyFile, FileName);
    Rewrite(MyFile);

    Writeln(MyFile, 'Decimal number:');
    Writeln(MyFile, Num);
    Writeln(MyFile, 'Hexadecimal number:');
    If (High(Arr) > 0) Then
    Begin
        While (Arr[Index] = '0') Do
            Inc(Index);
        For I := Index To High(Arr) Do
            Write(MyFile, Arr[I]);
    End
    Else
        Writeln(MyFile, Arr[Index]);
    CloseFile(MyFile);
    Writeln('Writing is successfull');
End;

Procedure OutputInf(Num: Integer; ArrOfDigit: TArray);
Var
    Choice: Integer;
Begin
    Choice := UserChoice();
    If (Choice = 1) Then
        OutputInConsole(Num, ArrOfDigit)
    Else
        OutputInFile(Num, ArrOfDigit);
End;

Var
    Num: Integer;
    ArrOfDigit: TArray;

Begin
    PrintInf();
    Num := InputInf();
    ArrOfDigit := GetArrOfHexDigit(Num);
    OutputInf(Num, ArrOfDigit);
    Readln;

End.
