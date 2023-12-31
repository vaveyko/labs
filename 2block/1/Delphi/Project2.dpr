Program Project2;

Uses
    System.SysUtils;

Const
    MAXCOUNT = 1000;

Var
    ArrOfInf: Array Of Integer;
    I, CountElem, IndexOfNeededElem, MaxValue, MinValue: Integer;
    AbsDistanse, MinAbsDistanse, Average, Sum: Real;
    IsCorrect: Boolean;

Begin
    MaxValue := MaxInt;
    MinValue := -MaxInt;
    Sum := 0;
    CountElem := 0;
    IndexOfNeededElem := 0;
    Average := 0;
    AbsDistanse := 0;
    Writeln('��������� ��������� �������� ������������������ � ������� ',
            '������� �������� ', #10#13, '������� �� ������ �������� � �������� ',
            '��������������� ������������������');
    Repeat
        IsCorrect := True;
        Writeln('������� ���������� ���������');
        Try
            Readln(CountElem);
        Except
            Writeln('�������� ������� ������');
            IsCorrect := False;
        End;
        If IsCorrect And ((CountElem < 1) Or (CountElem > MAXCOUNT)) Then
        Begin
            IsCorrect := False;
            Writeln('���������� ��������� ������ ���� ������ 0 � ������ ',
              MAXCOUNT);
        End;
    Until (IsCorrect);
    MinValue := MinValue Div CountElem;
    MaxValue := MaxValue Div CountElem;

    // creating array for information
    SetLength(ArrOfInf, CountElem);

    // filling the array
    For I := 0 To High(ArrOfInf) Do
    Begin
        Repeat
            IsCorrect := True;
            Writeln('������� ', I + 1, ' ������� ������������������');
            Try
                Readln(ArrOfInf[I]);
            Except
                Writeln('�������� ������� ������');
                IsCorrect := False;
            End;
            If IsCorrect And ((ArrOfInf[I] < MinValue) Or(ArrOfInf[I] > MaxValue)) Then
            Begin
                IsCorrect := False;
                Writeln('��-�� ���������� ��������� ��� ������ ���������� ',
                        '� ���������� �� ', MinValue, ' �� ', MaxValue);
            End;
        Until IsCorrect;
    End;

    // algorithm
    For I := 0 To High(ArrOFInf) Do
        Sum := Sum + ArrOfInf[I];
    Average := Sum / CountElem;
    MinAbsDistanse := Abs(Average - ArrOfInf[0]);
    For I := 0 To High(ArrOFInf) Do
    Begin
        AbsDistanse := Abs(Average - ArrOfInf[I]);
        If AbsDistanse < MinAbsDistanse Then
        Begin
            MinAbsDistanse := AbsDistanse;
            IndexOfNeededElem := I;
        End;
    End;

    // output
    Writeln('������� �������������� -- ', Average:7:4);
    Writeln('��������� ������� -- ', ArrOfInf[IndexOfNeededElem]);
    Readln;

End.
