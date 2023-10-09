Program Project1;

Uses
    System.SysUtils;

Const
    MINVALUE = 1;
    MAXVALUE = 1000000;

Var
    LenOfNum, Num: Integer;
    IsCorrect: Boolean;

Begin
    Num := 0;
    LenOfNum := 0;
    Writeln('��������� ������� ���������� ���� � ����������� ����� n');
    Repeat
        IsCorrect := True;
        Writeln('������� ����������� �����');
        Try
            Readln(Num);
        Except
            Writeln('������������ ������� ������');
            IsCorrect := False;
        End;
        If IsCorrect And ((Num < MINVALUE) Or (Num > MAXVALUE)) Then
        Begin
            Writeln('����� ������ ���� � ���������� �� ', MINVALUE, ' �� ', MAXVALUE);
            IsCorrect := False;
        End;
    Until IsCorrect;
    While (Num > 0) Do
    Begin
        Inc(LenOfNum);
        Num := Num Div 10;
    End;
    Writeln('������ ����� -- ', LenOfNum);
    Readln;
End.
