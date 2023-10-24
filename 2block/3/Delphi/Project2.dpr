Program Project2;

Uses
    System.SysUtils;

Type
    OneSizeArr = Array Of Integer;
    TwoSizeArr = Array Of OneSizeArr;

Const
    MAX_SIZE = 100;
    MIN_SIZE = 2;
    MIN_ELEM = -MaxInt - 1;
    MAX_ELEM = MaxInt;

Procedure PrintInf();
Begin
    Writeln('Program sort even rows of square matrix from larger to smaller');
End;

Function SortArr(Arr: OneSizeArr): OneSizeArr;
Var
    I, J, Bufer: Integer;
    IsNotSort: Boolean;
Begin
    IsNotSort := True;
    While IsNotSort Do
    Begin
        IsNotSort := False;
        For I := 1 To High(Arr) Do
            For J := I To High(Arr) Do
                If Arr[J - 1] < Arr[J] Then
                Begin
                    IsNotSort := True;
                    Bufer := Arr[J];
                    Arr[J] := Arr[J - 1];
                    Arr[J - 1] := Bufer;
                End;
    End;
    SortArr := Arr;
End;

Function InpValidNum(Const MIN, MAX: Integer): Integer;
Var
    IsCorrect: Boolean;
    Num: Integer;
Begin
    Repeat
        Try
            Readln(Num);
            IsCorrect := True;
        Except
            Writeln('Data is not correct, or number is too large',
              ' (it should be from ', MIN, ' to ', MAX, ' )');
            IsCorrect := False;
            Writeln('Please, enter again');
        End;
        If IsCorrect And ((Num < MIN) Or (Num > MAX)) Then
        Begin
            Writeln('It should be from ', MIN, ' to ', MAX);
            IsCorrect := False;
            Writeln('Please, enter again');
        End;
    Until IsCorrect;
    InpValidNum := Num;
End;

Function EnterArr(Row, Column: Integer): TwoSizeArr;
Var
    Arr: TwoSizeArr;
    I, J: Integer;
Begin
    SetLength(Arr, Row, Column);
    For I := 0 To High(Arr) Do
        For J := 0 To High(Arr[I]) Do
        Begin
            Writeln('Enter a', I + 1, J + 1, ' element');
            Arr[I][J] := InpValidNum(MIN_ELEM, MAX_ELEM);
        End;
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
        Writeln;
    End;

End;

Function MakeCopy(DefaultArr: TwoSizeArr): TwoSizeArr;
Var
    CopyArr: TwoSizeArr;
    I, J: Integer;
Begin
    SetLength(CopyArr, Length(DefaultArr), Length(DefaultArr));
    For I := 0 To High(CopyArr) Do
        For J := 0 To High(CopyArr[I]) Do
            CopyArr[I][J] := DefaultArr[I][J];
    MakeCopy := CopyArr;
End;

Function SortEvenRow(DefaultArr: TwoSizeArr; Row: Integer): TwoSizeArr;
Var
    I: Integer;
    Arr: TwoSizeArr;
Begin
    Arr := MakeCopy(DefaultArr);
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

Function ReadSizeFromFile(Var InfFile: TextFile): Integer;
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
    If IsCorrect And ((Size < MIN_SIZE) Or (Size > MAX_SIZE)) Then
    Begin
        Writeln('Size of array should be from ', MIN_SIZE, ' to ', MAX_SIZE);
        IsCorrect := False;
        Size := 0;
    End;
    ReadSizeFromFile := Size;
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
Var
    LastFourChar: String;
Begin
    LastFourChar := Copy(Name, Length(Name) - 3, Length(Name));
    If LastFourChar = '.txt' Then
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
    IsFileOk := IsFileTxt(FileName) And FileExists(FileName) And IsFileCorrect(MyFile);

End;

Procedure ChekFileAfterReading(Var IsCorrect: Boolean; Var MyFile: TextFile;
  IsElemIncorrect: Boolean);
Begin
    If IsElemIncorrect Then
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

Function ReadValidFileInf(Name: String; Var Size: Integer): TwoSizeArr;
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

        Size := ReadSizeFromFile(InfFile);
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
    If Not IsCorrect Then
        Arr := [[]];
    ReadValidFileInf := Arr;
End;

Procedure WriteInfFile(Name: String; Var DefaultArr, SortedArr: TwoSizeArr;
  Size: Integer);
Var
    OutFile: TextFile;
    I, J: Integer;
Begin
    AssignFile(OutFile, Name);
    Rewrite(OutFile);
    Writeln(OutFile, 'Default array');
    For I := 0 To High(DefaultArr) Do
    Begin
        For J := 0 To High(DefaultArr) Do
            Write(OutFile, DefaultArr[I][J], ' ');
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

Function UserChoice(): Integer;
Var
    Choice: Integer;
Begin
    Writeln('Choose a way of input/output of data', #13#10, '1 -- Console',
      #13#10, '2 -- File');
    Choice := InpValidNum(1, 2);
    UserChoice := Choice;
End;

Procedure InputFromConsole(Var Size: Integer; Var Arr: TwoSizeArr);
Begin
    Writeln('Enter size of array, please');
    Size := InpValidNum(MIN_SIZE, MAX_SIZE);
    Writeln('Now enter the elements');
    Arr := EnterArr(Size, Size);
End;

Procedure InputFromFile(Var Size: Integer; Var Arr: TwoSizeArr);
Var
    IsCorrect: Boolean;
    Name: String;
Begin
    Repeat
        IsCorrect := True;
        Writeln('Please enter the full path to file');
        Readln(Name);

        If IsFileOk(Name) Then
            Arr := ReadValidFileInf(Name, Size)
        Else
            IsCorrect := False;
    Until IsCorrect;
End;

Function InputInf(Var Size: Integer): TwoSizeArr;
Var
    Arr: TwoSizeArr;
    ChoiceInp: Integer;
Begin
    ChoiceInp := UserChoice();
    If ChoiceInp = 1 Then
        InputFromConsole(Size, Arr)
    Else
        InputFromFile(Size, Arr);
    InputInf := Arr;
End;

Procedure OutputInConsole(DefaultArr, SortedArr: TwoSizeArr; Size: Integer);
Begin
    Writeln('Default Array');
    PrintArr(DefaultArr, Size, Size);
    Writeln('Sorted Array');
    PrintArr(SortedArr, Size, Size);
End;

Procedure OutputInFile(DefaultArr, SortedArr: TwoSizeArr; Size: Integer);
Var
    IsCorrect: Boolean;
    Name: String;
Begin
    Repeat
        IsCorrect := True;
        Writeln('Please enter the full path to file');
        Readln(Name);

        If IsFileOk(Name) Then
            WriteInfFile(Name, DefaultArr, SortedArr, Size)
        Else
            IsCorrect := False;
    Until IsCorrect;
End;

Procedure OutputInf(DefaultArr, SortedArr: TwoSizeArr; Size: Integer);
Var
    ChoiceOut: Integer;
Begin
    If (Length(DefaultArr) > 1) Then
    Begin
        ChoiceOut := UserChoice();
        If (ChoiceOut = 1) Then
            OutputInConsole(DefaultArr, SortedArr, Size)
        Else
            OutputInFile(DefaultArr, SortedArr, Size);
    End;
End;

Var
    Size, ChoiceInp, ChoiceOut, I, J: Integer;
    ArrOfNum, SortedArr, Arr: TwoSizeArr;
    FileName: String;

Begin
    PrintInf;
    ArrOfNum := InputInf(Size);
    SortedArr := SortEvenRow(ArrOfNum, Size);
    OutputInf(ArrOfNum, SortedArr, Size);

    Readln;

End.
