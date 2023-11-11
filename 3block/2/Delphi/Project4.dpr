Program Project4;

Uses
    System.SysUtils;

Type
    TSet = Set of Byte;
    TBorderArr = Array [0 .. 1] of Byte;
    ERRORS_CODE = (SUCCESS, INCORRECT_DATA, EMPTY_LINE, NOT_TXT, FILE_NOT_EXIST,
                   INCORRECT_DATA_FILE, A_LOT_OF_DATA_FILE, FILE_NOT_AVAILABLE,
                   OUT_OF_BORDER, INCORRECT_BORDERS);

Const
    ERRORS: Array [ERRORS_CODE] Of String = ('Successfull',
                                        'Data is not correct',
                                        'Line is empty, please be careful',
                                        'This is not a .txt file',
                                        'This file is not exist',
                                        'Data in file is not correct',
                                        'There are two numbers in file should be',
                                        'File is can not be opened',
                                        'Out of border [0, 255]',
                                        'Incorrect borders');

Procedure PrintInf();
Begin
    Writeln('Program forms two sets, the first of which contains all simple ',
            #13#10,'numbers from this set, and the second contains others');
    Writeln('Borders and numbers should be in the interval [0, 255]');
End;

Function IsNumbSimple(Numb: Integer): Boolean;
Var
    IsSimple: Boolean;
    RigthBord, I: Integer;
Begin
    RigthBord := Trunc(Sqrt(Numb));
    IsSimple := True;
    if Numb > 3 then
        For I := 2 To RigthBord Do
            If Numb Mod I = 0 Then
                IsSimple := False;
    IsNumbSimple := IsSimple;
End;

Function GetSetOfSimple(DefaultSet: TSet): TSet;
Var
    SimpleSet: TSet;
    Numb: Byte;
Begin
    SimpleSet := [];
    for Numb in DefaultSet do
        If IsNumbSimple(Numb) then
            Include(SimpleSet, Numb);
    GetSetOfSimple := SimpleSet;
End;

Function GetSetOfComposit(DefaultSet, SimpleSet: TSet): TSet;
Var
    CompositSet: TSet;
Begin
    CompositSet := [];
    CompositSet := DefaultSet - SimpleSet;
    GetSetOfComposit := CompositSet;
End;

Function CreateSetWhithBorders(Var Borders: TBorderArr): TSet;
Var
    NumSet: TSet;
    I: Byte;
Begin
    NumSet := [];
    for I := Borders[0] to Borders[1] do
        Include(NumSet, I);
    CreateSetWhithBorders := NumSet;
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

Function InpValidBorder(Var Numb: Byte): ERRORS_CODE;
Var
    Err: ERRORS_CODE;
    Line: String;
    IsCorrect: Boolean;
    NumbInt: Integer;
Begin
    Err := SUCCESS;
    IsCorrect := True;
    Readln(Line);
    Try
        NumbInt := StrToInt(Line);
    Except
        Err := INCORRECT_DATA;
        IsCorrect := False;
    End;
    if IsCorrect then
        If (NumbInt > 255) Or (NumbInt < 0) Then
            Err := OUT_OF_BORDER
        Else
            Numb := NumbInt;
    InpValidBorder := Err;
End;

Function InpValidBorders(Var Borders: TBorderArr): ERRORS_CODE;
Var
    Err: ERRORS_CODE;
    Line: String;
    IsCorrect: Boolean;
Begin
    Err := InpValidBorder(Borders[0]);
    if Err = SUCCESS then
    Begin
        Err := InpValidBorder(Borders[1]);
        if (Err = SUCCESS) And (Borders[0] > Borders[1]) then
            Err := INCORRECT_BORDERS;
    End;
    InpValidBorders := Err;
End;


Function InputFromConsole(): TBorderArr;
Var
    Err: ERRORS_CODE;
    Borders: TBorderArr;
Begin
    Writeln('Enter the borders through the Enter');
    Repeat
        Err := InpValidBorders(Borders);
        If (Err <> SUCCESS) then
            Writeln(ERRORS[Err], #10#13, 'Please, enter again');
    Until (Err = SUCCESS);
    InputFromConsole := Borders;
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
        If (Err <> SUCCESS) then
            Writeln(ERRORS[Err], #13#10, 'Please, enter again');
    Until (Err = SUCCESS);
    UserChoice := Choice;
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

Function ReadOneFromFile(Var Numb: Byte; Var MyFile: TextFile): ERRORS_CODE;
Var
    Line: String;
    Err: ERRORS_CODE;
    IsCorrect: Boolean;
    NumbInt: Integer;
Begin
    Err := SUCCESS;
    IsCorrect := True;
    Try
        Read(MyFile, NumbInt);
    Except
        Err := INCORRECT_DATA_FILE;
        IsCorrect := False;
    End;
    if IsCorrect then
        If (NumbInt > 255) Or (NumbInt < 0) Then
            Err := OUT_OF_BORDER
        Else
            Numb := NumbInt;
    ReadOneFromFile := Err;
End;

Function ReadFile(Var Borders: TBorderArr; Name: String): ERRORS_CODE;
Var
    Err: ERRORS_CODE;
    InfFile: TextFile;
Begin
    AssignFile(InfFile, Name);
    Reset(InfFile);

    Err := ReadOneFromFile(Borders[0], InfFile);
    if Err = SUCCESS then
    Begin
        Err := ReadOneFromFile(Borders[1], InfFile);
        if Err = SUCCESS then
            If Not EoF(InfFile) Then
                Err := A_LOT_OF_DATA_FILE;
    End;

    CloseFile(InfFile);
    ReadFile := Err;
End;

Function InputFromFile(): TBorderArr;
Var
    Err: ERRORS_CODE;
    FileName: String;
    Borders: TBorderArr;
Begin
    Writeln('Enter full path to file');
    Repeat
        FileName := GetFileName(True);
        Err := ReadFile(Borders, FileName);
        If (Err <> SUCCESS) then
            Writeln(ERRORS[Err]);
    Until (Err = SUCCESS);
    Writeln('Reading is successfull');
    InputFromFile := Borders;
End;

Function InputInf(): TBorderArr;
Var
    Borders: TBorderArr;
    Choice: Integer;
Begin
    Choice := UserChoice();
    If (Choice = 1) Then
        Borders := InputFromConsole()
    Else
        Borders := InputFromFile();
    InputInf := Borders;
End;

Procedure OutputInConsole(Default, SimpleSet, CompositSet: TSet);
Var
    Numb: Byte;
Begin
    Write('Default set', #13#10, '{ ');
    for Numb in Default do
        Write(Numb, ' ');
    Write('}', #13#10, 'Set with simple numbers', #13#10, '{ ');
    for Numb in SimpleSet do
        Write(Numb, ' ');
    Write('}', #13#10, 'Set with composit numbers', #13#10, '{ ');
    for Numb in CompositSet do
        Write(Numb, ' ');
    Writeln('}');
End;

Procedure OutputInFile(Default, SimpleSet, CompositSet: TSet);
Var
    FileName: String;
    Numb: Byte;
    MyFile: TextFile;
Begin
    Writeln('Enter full path to file');
    FileName := GetFileName(False);
    AssignFile(MyFile, FileName);
    Rewrite(MyFile);

    Write(MyFile, 'Default set', #13#10, '{ ');
    for Numb in Default do
        Write(MyFile, Numb, ' ');
    Write(MyFile, '}', #13#10, 'Set with simple numbers', #13#10, '{ ');
    for Numb in SimpleSet do
        Write(MyFile, Numb, ' ');
    Write(MyFile, '}', #13#10, 'Set with composit numbers', #13#10, '{ ');
    for Numb in CompositSet do
        Write(MyFile, Numb, ' ');
    Writeln(MyFile, '}');

    CloseFile(MyFile);
    Writeln('Writing is successfull');
End;

Procedure OutputInf(Default, SimpleSet, CompositSet: TSet);
Var
    Choice: Integer;
Begin
    Choice := UserChoice();
    If (Choice = 1) Then
        OutputInConsole(Default, SimpleSet, CompositSet)
    Else
        OutputInFile(Default, SimpleSet, CompositSet);
End;


Var
    Borders: TBorderArr;
    Default, SetWithSimple, SetWithComposit: TSet;

Begin
    PrintInf();
    Borders := InputInf();
    Default := CreateSetWhithBorders(Borders);
    SetWithSimple := GetSetOfSimple(Default);
    SetWithComposit := GetSetOfComposit(Default, SetWithSimple);
    OutputInf(Default, SetWithSimple, SetWithComposit);

    Readln;
End.
