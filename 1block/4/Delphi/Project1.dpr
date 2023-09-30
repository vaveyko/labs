Program Project1;

Uses
    System.SysUtils;

Const
    MINVALUE = 0;
    MAXVALUE = 100;

Var
    CountOfElement, I, Answer: Integer;
    IsCorrect: Boolean;
    ArrOfNum: Array Of Integer;

Begin
    Answer := 0;
    CountOfElement := 0;
    Writeln('��������� ������� ����� ��������� ������� ������� �� �������� ������');
    Repeat
        IsCorrect := True;
        Writeln('������� ���������� ��������� � �������');
        Try
            Readln(CountOfElement);
        Except
            Writeln('������������ ������� ������');
            IsCorrect := False;
        End;
        If IsCorrect Then
        Begin
            If (CountOfElement > MINVALUE) And (CountOfElement < MAXVALUE) Then
                SetLength(ArrOfNum, CountOfElement)
            Else
            Begin
                Writeln('���������� ��������� ������ ���� ������ ', MINVALUE,
                  ' � ������ ', MAXVALUE);
                IsCorrect := False;
            End;
        End;
    Until IsCorrect;
    Writeln;
    Writeln('������� �������� ������� (����� �����)');
    // filling the array
    For I := 0 To High(ArrOfNum) Do
    Begin
        IsCorrect := True;
        Repeat
            Writeln('������� ', I + 1, ' �������');
            Try
                Readln(ArrOfNum[I]);
            Except
                Writeln('������������ ������� ������');
                IsCorrect := False;
            End;
        Until IsCorrect;
    End;
    Write('�������� �� ������� ������');
    I := 0;
    While (I < CountOfElement) Do
    Begin
        Answer := Answer + ArrOfNum[I];
        Write(', ', ArrOfNum[I]);
        I := I + 2;
    End;
    Writeln;
    Writeln('����� ����� -- ', Answer);
    Readln;
End.
