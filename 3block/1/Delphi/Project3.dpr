Program Project3;

Uses
    System.SysUtils;

Type
    ERRORS_CODE = (SUCCESS, INCORRECT_DATA, EMPTY_LINE, NOT_TXT, FILE_NOT_EXIST,
      INCORRECT_DATA_FILE, A_LOT_OF_DATA_FILE, FILE_NOT_AVAILABLE);

Const
    DIGITS = ['0' .. '9'];
    ERRORS: Array [0 .. 7] Of String = ('Successfull', 'Data is not correct',
                                        'Line is empty, please be careful',
                                        'This is not a .txt file',
                                        'This file is not exist',
                                        'Data in file is not correct',
                                        'There is only one line in file should be',
                                        'File is can not be opened');

Procedure PrintInf();
Begin
    Writeln('Program selects a substring consisting of digits corresponding ',
            'to an integer', #10#13, '(starts with a "+" or "-" ',
            'and there are no letters and dots inside the substring)');
End;

Function GetNumFromLine(Line: String): String;
Var
    IsNumbNotExist: Boolean;
    I, Size: Integer;
    Numb: String;
Begin
    Numb := 'not exist';
    IsNumbNotExist := True;
    Size := Length(Line) + 1;
    I := 1;
    While I < Size Do
    Begin
        If (IsNumbNotExist And ((Line[I] = '+') Or (Line[I] = '-'))) Then
        Begin
            Numb := Line[I];
            Inc(I);
            While ((I < Size) And (Line[I] In DIGITS)) Do
            Begin
                Numb := Numb + Line[I];
                Inc(I);
            End;
            IsNumbNotExist := Length(Numb) = 1;
            If IsNumbNotExist Then
                Numb := 'not exist';
        End
        Else
            Inc(I);
    End;
    GetNumFromLine := Numb;
End;

Function InpChoice(Var Choice: Integer): Integer;
Var
    Err: Integer;
    ChoiceStr: String;
Begin
    Err := Ord(SUCCESS);
    Readln(ChoiceStr);
    If (ChoiceStr = '1') Or (ChoiceStr = '2') Then
        Choice := StrToInt(ChoiceStr)
    Else If (Length(ChoiceStr) > 0) Then
        Err := Ord(INCORRECT_DATA)
    Else
        Err := Ord(EMPTY_LINE);
    InpChoice := Err;
End;

Function InpValidLine(Var Line: String): Integer;
Var
    Err: Integer;
Begin
    Err := Ord(SUCCESS);
    Readln(Line);
    If Length(Line) = 0 Then
        Err := Ord(EMPTY_LINE);
    InpValidLine := Err;
End;

Function UserChoice(): Integer;
Var
    Choice: Integer;
    Err: Integer;
Begin
    Writeln('Choose a way of input/output of data', #13#10, '1 -- Console',
             #13#10, '2 -- File');
    Repeat
        Err := InpChoice(Choice);
        If (Err > 0) then
            Writeln(ERRORS[Err], #10#13, 'Please, enter again');
    Until (Err = 0);
    UserChoice := Choice;
End;

Procedure InputFromConsole(Var Line: String);
Var
    Err: Integer;
Begin
    Writeln('Enter the line');
    Repeat
        Err := InpValidLine(Line);
        If (Err > 0) then
            Writeln(ERRORS[Err], #10#13, 'Please, enter again');
    Until (Err = 0);
End;

Function FileAvailable(Name: String; ForReset: Boolean): Integer;
Var
    Err: Integer;
    MyFile: TextFile;
Begin
    Err := Ord(SUCCESS);
    AssignFile(MyFile, Name);
    If ForReset Then
        Try
            Try
                Reset(MyFile);
            Finally
                CloseFile(MyFile);
            End;
        Except
            Err := Ord(FILE_NOT_AVAILABLE);
        End
    Else
        Try
            Try
                Rewrite(MyFile);
            Finally
                CloseFile(MyFile);
            End;
        Except
            Err := Ord(FILE_NOT_AVAILABLE);
        End;
    FileAvailable := Err;
End;

Function GetLastFourChar(Line: String): String;
Var
    Start, I, Size: Integer;
    LastFourChar: String;
Begin
    Size := Length(Line);
    Start := Size - 4;
    For I := Start To Size Do
        LastFourChar := LastFourChar + Line[I];
    GetLastFourChar := LastFourChar;
End;

Function FileTxt(Name: String): Integer;
Var
    Err: Integer;
    LastFourChar: String;
Begin
    Err := Ord(SUCCESS);
    If Length(Name) > 4 Then
    Begin
        LastFourChar := GetLastFourChar(Name);
        If LastFourChar <> '.txt' Then
            Err := Ord(NOT_TXT);
    End
    Else
        Err := Ord(NOT_TXT);
    FileTxt := Err;
End;

Function FileExist(Name: String): Integer;
Var
    Err: Integer;
Begin
    Err := Ord(SUCCESS);
    If Not FileExists(Name) Then
        Err := Ord(FILE_NOT_EXIST);
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
            Writeln(ERRORS[ErrExist]);
            IsCorrect := False;
        End
        Else If (ErrTxt > 0) Then
        Begin
            Writeln(ERRORS[ErrTxt]);
            IsCorrect := False;
        End;
        If ((ErrExist = 0) And (ErrTxt = 0)) Then
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

Function ReadFile(Var Line: String; Name: String): Integer;
Var
    Err: Integer;
    IsCorrect: Boolean;
    InfFile: TextFile;
Begin
    AssignFile(InfFile, Name);
    Reset(InfFile);

    IsCorrect := True;
    Err := Ord(SUCCESS);
    Read(InfFile, Line);
    If Not EoF(InfFile) Then
        Err := Ord(A_LOT_OF_DATA_FILE);
    If Length(Line) = 0 Then
        Err := Ord(EMPTY_LINE);

    CloseFile(InfFile);
    ReadFile := Err;
End;

Procedure InputFromFile(Var Line: String);
Var
    Err: Integer;
    FileName: String;
Begin
    Writeln('Enter full path to file');
    Repeat
        FileName := GetFileName(True);
        Err := ReadFile(Line, FileName);
        If (Err > 0) then
            Writeln(ERRORS[Err], #10#13, 'Please, enter full path again');
    Until (Err = 0);
    Writeln('Reading is successfull');

End;

Function InputInf(): String;
Var
    Choice, Num: Integer;
    Line: String;
Begin
    Choice := UserChoice();
    If (Choice = 1) Then
        InputFromConsole(Line)
    Else
        InputFromFile(Line);
    InputInf := Line;
End;

Procedure OutputInConsole(Line, Num: String);
Begin
    Writeln('Default line', #13#10, Line);
    Writeln('Substring', #13#10, Num);
End;

Procedure OutputInFile(Line, Num: String);
Var
    FileName: String;
    MyFile: TextFile;
Begin
    Writeln('Enter full path to file');
    FileName := GetFileName(False);
    AssignFile(MyFile, FileName);
    Rewrite(MyFile);

    Writeln(MyFile, 'Default line', #13#10, Line);
    Writeln(MyFile, 'Substring', #13#10, Num);

    CloseFile(MyFile);
    Writeln('Writing is successfull');
End;

Procedure OutputInf(Line, Num: String);
Var
    Choice: Integer;
Begin
    Choice := UserChoice();
    If (Choice = 1) Then
        OutputInConsole(Line, Num)
    Else
        OutputInFile(Line, Num);
End;

Var
    Num, Line: String;

Begin
    PrintInf();
    Line := InputInf();
    Num := GetNumFromLine(Line);
    OutputInf(Line, Num);

    Readln;

End.
