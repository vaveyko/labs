Program Project2;

Uses
    System.SysUtils;

Type
    OneSizeArr = Array Of Integer;
    TwoSizeArr = Array Of OneSizeArr;

Procedure PrintInf();
Begin
    Writeln('Program sort even rows of square matrix from larger to smaller');
End;

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
            If Arr[I - 1] < Arr[I] Then
            Begin
                IsNotSort := True;
                Bufer := Arr[I];
                Arr[I] := Arr[I - 1];
                Arr[I - 1] := Bufer;
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
    If High(Arr) > 0 Then
    Begin
        I := 1;
        While (I < Row) Do
        Begin
            Arr[I] := SortArr(Arr[I]);
            Inc(I, 2);
        End;
    End;
    SortEvenRow := Arr;
End;

Function ReadSizeFile(MinSize, MaxSize: Integer; Var InfFile: TextFile)
  : Integer;
Var
    IsCorrect: Boolean;
    Size: Integer;
Begin
    Size := 0;

    Try
        Read(InfFile, Size);
    Except
        Writeln('Size is not correct');
        Size := 0;
        IsCorrect := False;
    End;
    If IsCorrect And ((Size < MinSize) Or (Size > MaxSize)) Then
    Begin
        Writeln('Size of array should be from ', MinSize, ' to ', MaxSize);
        IsCorrect := False;
        Size := 0;
    End;
    ReadSizeFile := Size;
End;

Function IsFileCorrect(Var InfFile: TextFile): Boolean;
Var
    IsCanReset: Boolean;
Begin
    IsCanReset := True;
    Try
        Try
            Reset(InfFile);
        Finally
            Close(InfFile);
        End;
    Except
        IsCanReset := False;
        Writeln('File is can not be opened');
    End;
    IsFileCorrect := IsCanReset;
End;

Function IsFileTxt(Name: String): Boolean;
Begin
    If Copy(Name, Length(Name) - 3, Length(Name)) = '.txt' Then
        IsFileTxt := True
    Else
    Begin
        Writeln('File is not .txt');
        IsFileTxt := False;
    End;

End;

Function IsFileOk(FileName: String): Boolean;
Var
    MyFile: TextFile;
Begin
    AssignFile(MyFile, FileName);
    If Not FileExists(FileName) Then
        Writeln('File is not exist');
    IsFileOk := IsFileTxt(FileName) And FileExists(FileName) And
      IsFileCorrect(MyFile);

End;

Procedure ChekFileAfterReading(Var IsCorrect: Boolean; Var MyFile: TextFile; IsElemIncorrect: Boolean);
Begin
    if IsElemIncorrect then
    Begin
        Writeln('One of the element is incorrect');
        IsCorrect := False;
    End
    Else If Eof(MyFile) And IsCorrect Then
    Begin
        Writeln('Reading is successfull')
    End
    Else If IsCorrect Then
    Begin
        Writeln('Count of element is too a lot');
        IsCorrect := False;
    End
    Else
    Begin
        Writeln('Count of element is not enough');
        IsCorrect := False;
    End;
End;

Function ReadValidFileInf(Name: String; Var Size: Integer;
  MinSize, MaxSize: Integer): TwoSizeArr;
Var
    InfFile: TextFile;
    IsCorrect, IsElemIncorrect: Boolean;
    I, J, Buffer: Integer;
    Arr: TwoSizeArr;
Begin
    IsCorrect := True;
    AssignFile(InfFile, Name);
    If IsFileOk(Name) Then
    Begin
        Reset(InfFile);

        Size := ReadSizeFile(MinSize, MaxSize, InfFile);
        IsCorrect := Size > 1;
        IsElemIncorrect := False;
        SetLength(Arr, Size, Size);
        For I := 0 To High(Arr) Do
            For J := 0 To High(Arr[I]) Do
            Begin
                If Eof(InfFile) Then
                    IsCorrect := False
                Else
                Begin
                    Try
                        Read(InfFile, Arr[I][J]);
                    Except
                        IsElemIncorrect := True;
                    End;
                End;
            End;

        ChekFileAfterReading(IsCorrect, InfFile, IsElemIncorrect);
        CloseFile(InfFile);
    End
    Else
        IsCorrect := False;
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
    AssignFile(OutFile, Name);
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

Function ButtonInf(): Integer;
Var
    Button: Integer;
Begin
    Writeln('Choose a way of input/output of data', #13#10, '1 -- Console',
      #13#10, '2 -- File');
    Button := InpValidNum(1, 2);
    ButtonInf := Button;
End;

Function InputInf(Butt: Integer; Var Size: Integer; Var Name: String)
  : TwoSizeArr;
Const
    MAX_SIZE = 100;
    MIN_SIZE = 2;
    MIN_ELEM = -MaxInt - 1;
    MAX_ELEM = MaxInt;
Var
    Arr: TwoSizeArr;
    IsCorrect: Boolean;
Begin
    If (Butt = 1) Then
    Begin
        Writeln('Enter size of array, please');
        Size := InpValidNum(MIN_SIZE, MAX_SIZE);
        Writeln('Now enter the elements');
        Arr := EnterArr(Size, Size, MIN_ELEM, MAX_ELEM);
    End
    Else
    Begin
        Repeat
            IsCorrect := True;
            Writeln('Please enter the full path to file');
            Readln(Name);

            If IsFileOk(Name) Then
                Arr := ReadValidFileInf(Name, Size, MIN_SIZE, MAX_SIZE)
            Else
                IsCorrect := False;
        Until IsCorrect;
    End;
    InputInf := Arr;
End;

Procedure OutputInf(DefoltArr, SortedArr: TwoSizeArr; Size, Butt: Integer;
  Name: String);
Begin
    If Butt = 1 Then
    Begin
        Writeln('Defolt Array');
        PrintArr(DefoltArr, Size, Size);
        Writeln('Sorted Array');
        SortedArr := SortEvenRow(DefoltArr, Size);
        PrintArr(SortedArr, Size, Size);
    End
    Else
    Begin
        If Length(DefoltArr) > 1 Then
            WriteInfFile(Name, DefoltArr, SortedArr, Size);
    End;
End;

Var
    Size, Button, I, J: Integer;
    ArrOfNum, SortedArr, Arr: TwoSizeArr;
    FileName: String;

Begin
    PrintInf;
    Button := ButtonInf();
    ArrOfNum := InputInf(Button, Size, FileName);
    SortedArr := MakeCopy(ArrOfNum);
    SortedArr := SortEvenRow(SortedArr, Size);
    OutputInf(ArrOfNum, SortedArr, Size, Button, FileName);

    Readln;

End.
