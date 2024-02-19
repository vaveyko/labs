Unit BackEndUnit;

Interface

Uses
    System.SysUtils, Vcl.Grids;

Type
    TFileMode = (FmReset, FmRewrite);
    TAge = 1 .. 120;

    RToy = Record
        Name: String[20];
        Cost: Integer;
        Count: Integer;
        MinAge, MaxAge: TAge;
    End;

    TToyFile = File Of Rtoy;

Procedure TotalKeyPress(Var Key: Char; SelStart, SelLength: Integer;
  Const MIN, MAX: Integer; Text: String);
Procedure AddRecord(Toy: RToy);
Procedure CloneFileToAnother(Var FromFile, ToFile: TToyFile);
Procedure OpenFile(Path: String; Var ThisFile: TToyFile; Mode: TFileMode);
Function GetRecFromFile(Index: Integer): RToy;
Procedure ChangeToy(Index: Integer; NewToy: RToy);
Procedure DeleteRec(Index: Integer);

Procedure DrawRecordOnGrid(Grid: TStringGrid; Path: String);

Const
    STORAGE_FILE_PATH = 'StorageFile.txt';
    ÑORRECTION_FILE_PATH = 'CorrectionFile.txt';
    BUFFER_FILE_PATH = 'BufferFile.txt';
    VOID = #0;
    BACKSPACE = #8;
    MIN_COUNT = 0;
    MAX_COUNT = 2000000000;
    MIN_COST = 0;
    MAX_COST = 2000000000;
    MIN_AGE = 1;
    MAX_AGE = 120;

Implementation

Function IsToyCorrect(Toy: RToy): Boolean;
Begin
    With Toy do
    IsToyCorrect := (Length(Name) <= 21) And
                    (Cost >= MIN_COST) And (Cost <= MAX_COST)
                    And (Count >= MIN_COUNT) And (Count <= MAX_COUNT)
                    And (MinAge < MaxAge) And (MinAge >= MIN_AGE)
                    And (MaxAge <= MAX_AGE);
End;

Procedure DrawRecordOnGrid(Grid: TStringGrid; Path: String);
Var
    CorrectionFile: TToyFile;
    RecCount, I: Integer;
    Toy: RToy;
    IsFileIncorrect: Boolean;
Begin
    OpenFile(Path, CorrectionFile, FmReset);
    RecCount := FileSize(CorrectionFile);
    IsFileIncorrect := False;
    Grid.RowCount := RecCount + 1;
    For I := 1 To RecCount Do
    Begin
        Read(CorrectionFile, Toy);
        if IsToyCorrect(Toy) then
        Begin
            Grid.Cells[0, I] := IntToStr(I) + '.';
            With Toy Do
            Begin
                Grid.Cells[1, I] := '"' + Name + '"';
                Grid.Cells[2, I] := IntToStr(Cost);
                Grid.Cells[3, I] := IntToStr(Count);
                Grid.Cells[4, I] := IntToStr(MinAge) + '-' + IntToStr(MaxAge);
            End;
        End
        Else
        Begin
            Grid.Cells[1, I] := 'ôàéë ñ äàííûìè áûë ïîâ';
            Grid.Cells[2, I] := 'ðåæäåí,ïåðå';
            Grid.Cells[3, I] := 'çàïóñòèòå';
            Grid.Cells[4, I] := 'ïðîãó';
            IsFileIncorrect := True;
        End;
    End;
    CloseFile(CorrectionFile);
    if IsFileIncorrect then
        DeleteFile(Path);
End;

Procedure DeleteRec(Index: Integer);
Var
    CorrectionFile, BufferFile: TToyFile;
    I: Integer;
    Toy: RToy;
Begin
    OpenFile(ÑORRECTION_FILE_PATH, CorrectionFile, FmReset);
    OpenFile(BUFFER_FILE_PATH, BufferFile, FmRewrite);

    For I := 0 To FileSize(CorrectionFile) - 1 Do
        If I <> Index Then
        Begin
            Read(CorrectionFile, Toy);
            Write(BufferFile, Toy);
        End
        Else
            Seek(CorrectionFile, FilePos(CorrectionFile) + 1);
    CloseFile(CorrectionFile);
    CloseFile(BufferFile);
    DeleteFile(ÑORRECTION_FILE_PATH);
    RenameFile(BUFFER_FILE_PATH, ÑORRECTION_FILE_PATH);
End;

Procedure ChangeToy(Index: Integer; NewToy: RToy);
Var
    CorrectionFile: TToyFile;
Begin
    OpenFile(ÑORRECTION_FILE_PATH, CorrectionFile, FmReset);
    Seek(CorrectionFile, Index);
    Write(CorrectionFile, NewToy);
    CloseFile(CorrectionFile);
End;

Function GetRecFromFile(Index: Integer): RToy;
Var
    CorrectionFile: TToyFile;
    Toy: RToy;
Begin
    OpenFile(ÑORRECTION_FILE_PATH, CorrectionFile, FmReset);
    Seek(CorrectionFile, Index);
    Read(CorrectionFile, Toy);
    CloseFile(CorrectionFile);
    GetRecFromFile := Toy;
End;

Procedure OpenFile(Path: String; Var ThisFile: TToyFile; Mode: TFileMode);
Begin
    AssignFile(ThisFile, Path);
    If Mode = FmReset Then
    Begin
        If Not(FileExists(Path)) Then
            Rewrite(ThisFile)
        Else
            Reset(ThisFile);
    End
    Else
        Rewrite(ThisFile);
End;

Procedure CloneFileToAnother(Var FromFile, ToFile: TToyFile);
Var
    Toy: RToy;
Begin
    While Not EoF(FromFile) Do
    Begin
        Read(FromFile, Toy);
        if IsToyCorrect(Toy) then
            Write(ToFile, Toy);
    End;
End;

Procedure AddRecord(Toy: RToy);
Var
    CorrectionFile: TToyFile;
Begin
    OpenFile(ÑORRECTION_FILE_PATH, CorrectionFile, FmReset);
    Seek(CorrectionFile, FileSize(CorrectionFile));
    Write(CorrectionFile, Toy);
    CloseFile(CorrectionFile);
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
