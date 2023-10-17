Program Project2;

Uses
    System.SysUtils;

Type
    OneSizeArr = Array Of Integer;
    TwoSizeArr = Array Of OneSizeArr;

Function SortArr(Arr: OneSizeArr): OneSizeArr;
Var
    I, Bufer: Integer;
    IsNotSort: Boolean;
Begin
    IsNotSort := True;
    While IsNotSort Do
    Begin
        IsNotSort := False;
        For I := 1 To High(Arr) Do
        Begin
            If Arr[I - 1] < Arr[I] Then
            Begin
                IsNotSort := True;
                Bufer := Arr[I];
                Arr[I] := Arr[I - 1];
                Arr[I - 1] := Bufer;
            End;
        End;
    End;
    SortArr := Arr;
End;

Function InpValidNum(Min, Max: Integer): Integer;
Var
    IsCorrect: Boolean;
    Num: Integer;
Begin
    Repeat
        Writeln('Please, enter the number');
        Try
            Readln(Num);
            IsCorrect := True;
        Except
            Writeln('Data is not correct, or number is too large',
              ' (it should be from ', Min, ' to ', Max, ' )');
            IsCorrect := False;
        End;
        If IsCorrect And ((Num < Min) Or (Num > Max)) Then
        Begin
            Writeln('It should be from ', Min, ' to ', Max);
            IsCorrect := False;
        End;
    Until IsCorrect;
    InpValidNum := Num;
End;

Function EnterArr(Row, Column, Min, Max: Integer): TwoSizeArr;
Var
    Arr: TwoSizeArr;
    I, J: Integer;
Begin
    SetLength(Arr, Row);
    For I := 0 To High(Arr) Do
        SetLength(Arr[I], Column);
    For I := 0 To High(Arr) Do
        For J := 0 To High(Arr[I]) Do
            Arr[I][J] := InpValidNum(Min, Max);
    EnterArr := Arr;
End;

Procedure PrintArr(Arr: TwoSizeArr; Row: Integer; Column: Integer);
Var
    I, J, RealRow, RealCol: Integer;
Begin
    RealRow := Row - 1;
    RealCol := Column - 1;
    For I := 0 To RealRow Do
    Begin
        For J := 0 To RealCol Do
            Write(Arr[I][J], ' ');
        Write(#13#10);
    End;

End;

Function SortEvenRow(Arr: TwoSizeArr; Row: Integer): TwoSizeArr;
Var
    I: Integer;
Begin
    I := 1;
    While (I < Row) Do
    Begin
        Arr[I] := SortArr(Arr[I]);
        Inc(I, 2);
    End;
    SortEvenRow := Arr;
End;

Function ReadValidFileInf(Name: String; Var Size: Integer; MinSize, MaxSize: Integer): TwoSizeArr;
Var
    InfFile: TextFile;
    IsCorrect: Boolean;
    I, J, Buffer: Integer;
    Arr: TwoSizeArr;
Begin
    IsCorrect := True;
    Size := 0;
    Assign(InfFile, Name);
    Reset(InfFile);

    Try
        Read(InfFile, Size);
    Except
        Writeln('Size is not correct');
        IsCorrect := False;
    End;
    if (Size < MinSize) Or (Size > MaxSize) then
    Begin
        Writeln('Size of array should be from ', MinSize, ' to ', MaxSize);
        IsCorrect := False;
        Size := 0;
    End;
    SetLength(Arr, Size);
    For I := 0 To High(Arr) Do
        SetLength(Arr[I], Size);

    For I := 0 To High(Arr) Do
        For J := 0 To High(Arr[I]) Do
            Read(InfFile, Arr[I][J]);

    If Eof(InfFile) Then
    Begin
        Writeln('data in file not enough');
        IsCorrect := False;
    End
    Else
    Begin
        Read(InfFile, Buffer);
        If Eof(InfFile) Then
            Writeln('Reading is successful')
        Else If IsCorrect Then
        Begin
            Writeln('Data is to a lot');
            IsCorrect := False;
        End;

    End;
    CloseFile(InfFile);
    If IsCorrect Then
        ReadValidFileInf := Arr
    Else
        ReadValidFileInf := [[]];
End;

Procedure WriteInfFile(Name: String; Var DefoltArr, SortedArr: TwoSizeArr;
  Size: Integer);
Var
    OutFile: TextFile;
    I, J: Integer;
Begin
    Assign(OutFile, Name);
    Rewrite(OutFile);
    Writeln(OutFile, 'Defolt array');
    For I := 0 To High(DefoltArr) Do
    Begin
        For J := 0 To High(DefoltArr) Do
            Write(OutFile, DefoltArr[I][J], ' ');
        Write(OutFile, #13#10);
    End;
    Writeln(OutFile, 'Sorted array');
    For I := 0 To High(SortedArr) Do
    Begin
        For J := 0 To High(SortedArr) Do
            Write(OutFile, SortedArr[I][J], ' ');
        Write(OutFile, #13#10);
    End;

    Close(OutFile);
    Writeln('Writing is successfull');
End;

Function IsFileTxt(Name: String): Boolean;
Begin
    IsFileTxt := Copy(Name, Length(Name)-3, Length(Name)) = '.txt'
End;

Function MakeCopy(DefoltArr: TwoSizeArr): TwoSizeArr;
Var
    CopyArr: TwoSizeArr;
    I, J: Integer;
Begin
    SetLength(CopyArr, Length(DefoltArr));
    For I := 0 To High(CopyArr) Do
    Begin
        Setlength(CopyArr[I], Length(DefoltArr[0]));
        For J := 0 To High(CopyArr[I]) Do
            CopyArr[I][J] := DefoltArr[I][J];
    End;
    MakeCopy := CopyArr;
End;

Const
    MAX_SIZE = 100;
    MIN_SIZE = 2;
    MIN_ELEM = -MaxInt - 1;
    MAX_ELEM = MaxInt;

Var
    Size, Button, I, J: Integer;
    ArrOfNum, SortedArr, Arr: TwoSizeArr;
    FileName: String;

Begin
    Writeln('Choose a way of input/output of data', #13#10,
            '1 -- Console', #13#10,
            '2 -- File');
    Button := InpValidNum(1, 2);
    If (Button = 1) Then
    Begin
        Writeln('Enter size of array, please');
        Size := InpValidNum(MIN_SIZE, MAX_SIZE);
        Writeln('Now enter the elements');
        ArrOfNum := EnterArr(Size, Size, MIN_ELEM, MAX_ELEM);
        Writeln('Defolt Array');
        PrintArr(ArrOfNum, Size, Size);
        Writeln('Sorted Array');
        SortedArr := SortEvenRow(ArrOfNum, Size);
        PrintArr(SortedArr, Size, Size);
    End
    Else
    Begin
        Writeln('Please enter the full path to file');
        Readln(FileName);
        if IsFileTxt(FileName) And FileExists(FileName) then
        Begin
            ArrOfNum := ReadValidFileInf(FileName, Size, MIN_SIZE, MAX_SIZE);
            If Length(ArrOfNum) > 1 Then
            Begin
                SortedArr := MakeCopy(ArrOfNum);
                SortedArr := SortEvenRow(SortedArr, Size);
                WriteInfFile(FIleName, ArrOfNum, SortedArr, Size);
            End;
        End
        Else
            Writeln('There is no such file or file is not ".txt"');
    End;

    Readln;

End.
