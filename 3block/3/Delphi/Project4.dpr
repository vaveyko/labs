Program Project4;

Uses
    System.SysUtils;

Type
    TArray = Array Of Integer;
    ERRORS_CODE = (SUCCESS, INCORRECT_DATA, EMPTY_LINE, NOT_TXT, FILE_NOT_EXIST,
      INCORRECT_DATA_FILE, A_LOT_OF_DATA_FILE, FILE_NOT_AVAILABLE,
      OUT_OF_BORDER_SIZE, OUT_OF_BORDER_NUMB, INCORRECT_BORDERS);

Const
    MAX_NUMB = 2000000000;
    MIN_NUMB = -2000000000;
    MAX_SIZE = 100;
    MIN_SIZE = 2;
    ERRORS: Array [ERRORS_CODE] Of String = ('Successfull',
      'Data is not correct', 'Line is empty, please be careful',
      'This is not a .txt file', 'This file is not exist',
      'Data in file is not correct', 'There are two numbers in file should be',
      'File is can not be opened', 'Out of border [2, 100]',
      'Out of border [-2000000000, 2000000000]', 'Incorrect borders');

Procedure PrintInf();
Begin
    Writeln('The program implements sorting by natural merging');
End;

Function MergeWithPointers(Var Arr, PointersArr: TArray): TArray;
Var
    Start1, Stop1, Start2, Stop2: Integer;
    I, J, Counter, SizeArr, PointerInd: Integer;
    MergedArr: TArray;
Begin
    I := 0;
    Counter := Length(PointersArr) - Length(PointersArr) Mod 4;
    SizeArr := Length(PointersArr) Div 2;
    PointerInd := 0;
    SetLength(MergedArr, Length(Arr));
    Repeat
        Start1 := PointersArr[PointerInd];
        Inc(PointerInd);
        Stop1 := PointersArr[PointerInd];
        Inc(PointerInd);
        Start2 := PointersArr[PointerInd];
        Inc(PointerInd);
        Stop2 := PointersArr[PointerInd];
        Inc(PointerInd);
        While (Start1 < Stop1) And (Start2 < Stop2) Do
            If Arr[Start1] > Arr[Start2] Then
            Begin
                MergedArr[I] := Arr[Start2];
                Inc(I);
                Inc(Start2);
            End
            Else
            Begin
                MergedArr[I] := Arr[Start1];
                Inc(I);
                Inc(Start1);
            End;
        While Start1 < Stop1 Do
        Begin
            MergedArr[I] := Arr[Start1];
            Inc(I);
            Inc(Start1);
        End;
        While Start2 < Stop2 Do
        Begin
            MergedArr[I] := Arr[Start2];
            Inc(I);
            Inc(Start2);
        End;

    Until (PointerInd = Counter) Or (PointersArr[PointerInd] = 0);
    If (I < SizeArr) Then
        For J := PointersArr[PointerInd] To PointersArr[PointerInd + 1] Do
        Begin
            MergedArr[I] := Arr[J];
            Inc(I);
        End;
    MergeWithPointers := MergedArr;
End;

Procedure FillWithZero(Var Arr: TArray);
Var
    I: Integer;
Begin
    For I := 0 To High(Arr) Do
        Arr[I] := 0;
End;

Function MergeSort(Var Arr: TArray): TArray;
Var
    I, PointInd, SizePointers: Integer;
    PointersArr: TArray;
Begin
    SizePointers := 2 * Length(Arr);
    SetLength(PointersArr, SizePointers);
    Repeat
        FillWithZero(PointersArr);
        PointInd := 0;
        PointersArr[PointInd] := 0;
        Inc(PointInd);
        For I := 1 To High(Arr) Do
            If Arr[I] < Arr[I - 1] Then
            Begin
                PointersArr[PointInd] := I;
                Inc(PointInd);
                PointersArr[PointInd] := I;
                Inc(PointInd);
            End;
        PointersArr[PointInd] := Length(Arr);

        Arr := MergeWithPointers(Arr, PointersArr);

    Until PointersArr[1] = Length(Arr);
    MergeSort := Arr;
End;

Function InpChoice(Var Choice: Integer): ERRORS_CODE;
Var
    Err: ERRORS_CODE;
    ChoiceStr: String;
Begin
    Err := SUCCESS;
    Readln(ChoiceStr);
    If (ChoiceStr = '1') Or (ChoiceStr = '2') Then
        Choice := StrToInt(ChoiceStr)
    Else If (Length(ChoiceStr) > 0) Then
        Err := INCORRECT_DATA
    Else
        Err := EMPTY_LINE;
    InpChoice := Err;
End;

Function UserChoice(): Integer;
Var
    Choice: Integer;
    Err: ERRORS_CODE;
Begin
    Writeln('Choose a way of input/output of data', #13#10, '1 -- Console',
      #13#10, '2 -- File');
    Repeat
        Err := InpChoice(Choice);
        If (Err <> SUCCESS) Then
            Writeln(ERRORS[Err], #13#10, 'Please, enter again');
    Until (Err = SUCCESS);
    UserChoice := Choice;
End;

Function InpValidSize(Var Size: Integer): ERRORS_CODE;
Var
    Err: ERRORS_CODE;
    Line: String;
Begin
    Err := SUCCESS;
    Readln(Line);
    Try
        Size := StrToInt(Line);
    Except
        Err := INCORRECT_DATA;
    End;
    If (Err = SUCCESS) And ((Size > MAX_SIZE) Or (Size < MIN_SIZE)) Then
        Err := OUT_OF_BORDER_SIZE;
    InpValidSize := Err;
End;

Function InpValidArr(Var Arr: TArray): ERRORS_CODE;
Var
    Err: ERRORS_CODE;
    I: Integer;
    Line: String;
Begin
    Err := SUCCESS;
    I := 0;
    While (I < Length(Arr)) And (Err = SUCCESS) Do
    Begin
        Readln(Line);
        Try
            Arr[I] := StrToInt(Line);
        Except
            Err := INCORRECT_DATA;
        End;
        If (Err = SUCCESS) And ((Arr[I] > MAX_NUMB) Or (Arr[I] < MIN_NUMB)) Then
            Err := OUT_OF_BORDER_NUMB;
        Inc(I);
    End;

    InpValidArr := Err;
End;

Function InputFromConsole(): TArray;
Var
    Err: ERRORS_CODE;
    DefaultArr: TArray;
    Size: Integer;
Begin
    Writeln('Enter the size[2, 100] and then the', #13#10,
      'elements[-2000000000, 2000000000] through the Enter');
    Repeat
        Err := InpValidSize(Size);
        If (Err <> SUCCESS) Then
            Writeln(ERRORS[Err], #10#13, 'Please, enter again size');
    Until (Err = SUCCESS);
    SetLength(DefaultArr, Size);
    Writeln('Enter the ', Size, ' elements');
    Repeat
        Err := InpValidArr(DefaultArr);
        If (Err <> SUCCESS) Then
            Writeln(ERRORS[Err], #10#13, 'Please, enter again');
    Until (Err = SUCCESS);
    InputFromConsole := DefaultArr;
End;

Function FileAvailable(Name: String; ForReset: Boolean): ERRORS_CODE;
Var
    Err: ERRORS_CODE;
    MyFile: TextFile;
Begin
    Err := SUCCESS;
    AssignFile(MyFile, Name);
    If ForReset Then
        Try
            Try
                Reset(MyFile);
            Finally
                CloseFile(MyFile);
            End;
        Except
            Err := FILE_NOT_AVAILABLE;
        End
    Else
        Try
            Try
                Rewrite(MyFile);
            Finally
                CloseFile(MyFile);
            End;
        Except
            Err := FILE_NOT_AVAILABLE;
        End;
    FileAvailable := Err;
End;

Function GetLastFourChar(Line: String): String;
Var
    Start, I, Size: Integer;
    LastFourChar: String;
Begin
    Size := Length(Line);
    Start := Size - 3;
    For I := Start To Size Do
        LastFourChar := LastFourChar + Line[I];
    GetLastFourChar := LastFourChar;
End;

Function FileTxt(Name: String): ERRORS_CODE;
Var
    Err: ERRORS_CODE;
    LastFourChar: String;
Begin
    Err := SUCCESS;
    If Length(Name) > 4 Then
    Begin
        LastFourChar := GetLastFourChar(Name);
        If LastFourChar <> '.txt' Then
            Err := NOT_TXT;
    End
    Else
        Err := NOT_TXT;
    FileTxt := Err;
End;

Function FileExist(Name: String): ERRORS_CODE;
Var
    Err: ERRORS_CODE;
Begin
    Err := SUCCESS;
    If Not FileExists(Name) Then
        Err := FILE_NOT_EXIST;
    FileExist := Err;
End;

Function GetFileName(ForReset: Boolean): String;
Var
    IsCorrect: Boolean;
    ErrExist, ErrTxt, ErrAvailable: ERRORS_CODE;
    FileName: String;
Begin
    Repeat
        IsCorrect := True;
        Readln(FileName);
        ErrExist := FileExist(FileName);
        ErrTxt := FileTxt(FileName);
        If (ErrExist <> SUCCESS) Then
        Begin
            Writeln(ERRORS[ErrExist]);
            IsCorrect := False;
            Writeln('Please, enter full path again');
        End
        Else If (ErrTxt <> SUCCESS) Then
        Begin
            Writeln(ERRORS[ErrTxt]);
            IsCorrect := False;
            Writeln('Please, enter full path again');
        End
        Else
        Begin
            ErrAvailable := FileAvailable(FileName, ForReset);
            If (ErrAvailable <> SUCCESS) Then
            Begin
                Writeln(ERRORS[ErrAvailable]);
                IsCorrect := False;
                Writeln('Please, enter full path again');
            End;
        End;
    Until IsCorrect;
    GetFileName := FileName;
End;

Function ReadSizeFromFile(Var Size: Integer; Var MyFile: TextFile): ERRORS_CODE;
Var
    Line: String;
    Err: ERRORS_CODE;
Begin
    Err := SUCCESS;
    Try
        Read(MyFile, Size);
    Except
        Err := INCORRECT_DATA_FILE;
    End;
    If (Err = SUCCESS) And ((Size > MAX_SIZE) Or (Size < MIN_SIZE)) Then
        Err := OUT_OF_BORDER_SIZE;
    ReadSizeFromFile := Err;
End;

Function ReadArrFromFile(Var Arr: TArray; Var MyFile: TextFile): ERRORS_CODE;
Var
    Line: String;
    I: Integer;
    Err: ERRORS_CODE;
Begin
    Err := SUCCESS;
    I := 0;
    While (I < Length(Arr)) And (Err = SUCCESS) Do
    Begin
        Try
            Read(MyFile, Arr[I]);
        Except
            Err := INCORRECT_DATA_FILE;
        End;
        If (Err = SUCCESS) And ((Arr[I] > MAX_NUMB) Or (Arr[I] < MIN_NUMB)) Then
            Err := OUT_OF_BORDER_NUMB;
        Inc(I);
        If (I = Length(Arr)) And (Not Eof(MyFile)) Then
            Err := A_LOT_OF_DATA_FILE;
    End;
    ReadArrFromFile := Err;
End;

Function InputFromFile(): TArray;
Var
    Err: ERRORS_CODE;
    FileName: String;
    InfFile: TextFile;
    DefaultArr: TArray;
    Size: Integer;
Begin
    Writeln('Enter full path to file');
    Repeat
        FileName := GetFileName(True);
        AssignFile(InfFile, FileName);
        Reset(InfFile);

        Err := ReadSizeFromFile(Size, InfFile);
        If (Err = SUCCESS) Then
        Begin
            SetLength(DefaultArr, Size);
            Err := ReadArrFromFile(DefaultArr, InfFile);
        End;
        If Err <> SUCCESS Then
            Writeln(ERRORS[Err], #13#10, 'Enter full path to file');

        CloseFile(InfFile);
    Until (Err = SUCCESS);
    Writeln('Reading is successfull');
    InputFromFile := DefaultArr;
End;

Function InputInf(): TArray;
Var
    DefaultArr: TArray;
    Choice: Integer;
Begin
    Choice := UserChoice();
    If (Choice = 1) Then
        DefaultArr := InputFromConsole()
    Else
        DefaultArr := InputFromFile();
    InputInf := DefaultArr;
End;

Procedure OutputInConsole(Var DefaultArr, SortedArr: TArray);
Var
    I: Integer;
Begin
    Writeln('Default array');
    For I := 0 To High(DefaultArr) Do
        Write(DefaultArr[I], ' ');
    Writeln(#13#10, 'Sorted array');
    For I := 0 To High(SortedArr) Do
        Write(SortedArr[I], ' ');
End;

Procedure OutputInFile(Var DefaultArr, SortedArr: TArray);
Var
    FileName: String;
    I: Integer;
    MyFile: TextFile;
Begin
    Writeln('Enter full path to file');
    FileName := GetFileName(False);
    AssignFile(MyFile, FileName);
    Rewrite(MyFile);

    Writeln(MyFile, 'Default array');
    For I := 0 To High(DefaultArr) Do
        Write(MyFile, DefaultArr[I], ' ');
    Writeln(MyFile, #13#10, 'Sorted array');
    For I := 0 To High(SortedArr) Do
        Write(MyFile, SortedArr[I], ' ');

    CloseFile(MyFile);
    Writeln('Writing is successfull');
End;

Procedure OutputInf(Var DefaultArr, SortedArr: TArray);
Var
    Choice: Integer;
Begin
    Choice := UserChoice();
    If (Choice = 1) Then
        OutputInConsole(DefaultArr, SortedArr)
    Else
        OutputInFile(DefaultArr, SortedArr);
End;

Function CopyArr(Var Arr: TArray): TArray;
Var
    CopyedArr: TArray;
    I: Integer;
Begin
    SetLength(CopyedArr, Length(Arr));
    For I := 0 To High(Arr) Do
        CopyedArr[I] := Arr[I];
    CopyArr := CopyedArr;
End;

Var
    DefaultArr, SortedArr: TArray;

Begin
    PrintInf();
    DefaultArr := InputInf();
    SortedArr := CopyArr(DefaultArr);
    SortedArr := MergeSort(SortedArr);
    OutputInf(DefaultArr, SortedArr);

    Readln;

End.
