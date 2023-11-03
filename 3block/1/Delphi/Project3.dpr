Program Project3;

Uses
    System.SysUtils;

Const
    MIN_CHOICE = 1;
    MAX_CHOICE = 2;
    SUCCESS = 0;
    EMPTY_LINE = 2;
    INCORRECT_DATA = 1;
    NOT_TXT = 3;
    FILE_NOT_EXIST = 4;
    INCORRECT_DATA_FILE = 5;
    A_LOT_OF_DATA_FILE = 6;
    FILE_NOT_AVAILABLE = 7;
    DIGITS = ['0' .. '9'];
    ERRORS: Array [0 .. 7] Of String = ('Successfull',
                                        'Data is not correct',
                                        'Line is empty, please be careful',
                                        'This is not a .txt file',
                                        'This file is not exist',
                                        'Data in file is not correct',
                                        'There is only one line in file should be',
                                        'File is can not be opened');

Procedure PrintInf();
Begin
    Writeln('Program selects a substring consisting of digits corresponding ',
      'to an integer', #10#13, '(starts with a "+" or "-"',
      'and there are no letters and dots inside the substring)');
End;

Function GetNumFromLine(Line: String): String;
Var
    IsNumNotExist, IsNotEnd: Boolean;
    I: Integer;
    Num: String;
Begin
    Num := 'not exist';
    IsNumNotExist := True;
    IsNotEnd := True;
    For I := 1 To Length(Line) Do
    Begin
        If Not IsNumNotExist And IsNotEnd Then
        Begin
            If Line[I] In DIGITS Then
                Num := Num + Line[I]
            Else
                IsNotEnd := False;
        End;
        If IsNumNotExist And ((Line[I] = '-') Or (Line[I] = '+')) Then
        Begin
            Num := Line[I];
            IsNumNotExist := False;
        End;
    End;
    GetNumFromLine := Num;
End;

Function InpChoice(Var Choice: Integer): Integer;
Var
    Err: Integer;
    ChoiceStr: String;
Begin
    Err := SUCCESS;
    Readln(ChoiceStr);
    If (ChoiceStr = '1') Or (ChoiceStr = '2')Then
        Choice := StrToInt(ChoiceStr)
    Else
        Err := INCORRECT_DATA;
    InpChoice := Err;
End;

Function InpValidLine(Var Line: String): Integer;
Var
    Err: Integer;
Begin
    Err := SUCCESS;
    Readln(Line);
    If Length(Line) = 0 Then
        Err := EMPTY_LINE;
    InpValidLine := Err;
End;

Function UserChoice(): Integer;
Var
    Choice: Integer;
    Err: Integer;
Begin
    Writeln('Choose a way of input/output of data', #13#10, '1 -- Console',
      #13#10, '2 -- File');
    Err := InpChoice(Choice);
    While (Err > 0) Do
    Begin
        Writeln(ERRORS[Err]);
        Writeln('Please, enter again');
        Err := InpChoice(Choice);
    End;
    UserChoice := Choice;
End;

Procedure InputFromConsole(Var Line: String);
Var
    Err: Integer;
Begin
    Writeln('Enter the line');
    Err := InpValidLine(Line);
    While Err > 0 Do
    Begin
        Writeln(ERRORS[Err]);
        Writeln('Please, enter again');
        Err := InpValidLine(Line);
    End;
End;

Function FileAvailable(Name: String; ForReset: Boolean): Integer;
Var
    Err: Integer;
    MyFile: TextFile;
Begin
    Err := SUCCESS;
    AssignFile(MyFile, Name);
    If ForReset Then
        Try
            Try
                Reset(MyFile);
            Finally
                Close(MyFile);
            End;
        Except
            Err := FILE_NOT_AVAILABLE;
        End
    Else
        Try
            Try
                Rewrite(MyFile);
            Finally
                Close(MyFile);
            End;
        Except
            Err := FILE_NOT_AVAILABLE;
        End;
    FileAvailable := Err;
End;

Function FileTxt(Name: String): Integer;
Var
    Err: Integer;
Begin
    Err := SUCCESS;
    If ExtractFileExt(Name) <> '.txt' Then
        Err := NOT_TXT;
    FileTxt := Err;
End;

Function FileExist(Name: String): Integer;
Var
    Err: Integer;
Begin
    Err := SUCCESS;
    If Not FileExists(Name) Then
        Err := FILE_NOT_EXIST;
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
    Err := SUCCESS;
    Read(InfFile, Line);
    If Not EoF(InfFile) Then
        Err := A_LOT_OF_DATA_FILE;
    if Length(Line) = 0 then
        Err := EMPTY_LINE;
    CloseFile(InfFile);
    ReadFile := Err;
End;

Procedure InputFromFile(Var Line: String);
Var
    Err: Integer;
    FileName: String;
Begin
    Writeln('Enter full path to file');
    FileName := GetFileName(True);
    Err := ReadFile(Line, FileName);
    While (Err > 0) Do
    Begin
        Writeln(ERRORS[Err]);
        Writeln('Please, enter full path again');
        FileName := GetFileName(True);
        Err := ReadFile(Line, FileName);
    End;
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
