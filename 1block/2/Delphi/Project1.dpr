Program Task2Block1;

Uses
    System.SysUtils;

Const
    MINVALUE = 2;
    MAXVALUE = 15;

Var
    CountNum, I: Integer;
    MultipliedNum: Int64;
    IsCorrect: Boolean;

Begin
    CountNum := 0;
    MultipliedNum := 2;
    Writeln('��� ��������� ������� ������������ 2*4*6*...*2n ��� ��������� n');
    Writeln('����� n ������ ���� �� ', MINVALUE, ' � �� ', MAXVALUE);
    Repeat
        IsCorrect := True;
        Writeln('������� �����');
        Try
            Readln(CountNum);
        Except
            Writeln('������������ ������� ������');
            IsCorrect := False;
        End;
        If IsCorrect And ((CountNum < MINVALUE) Or (CountNum > MAXVALUE)) Then
        Begin
            Writeln('����� n ������ ���������� � ���������� [', MINVALUE, ', ', MAXVALUE, ']');
            IsCorrect := False;
        End
    Until IsCorrect;
    Write(MultipliedNum);
    For I := MINVALUE To CountNum Do
    Begin
        Write(' * ', 2 * I);
        MultipliedNum := MultipliedNum * 2 * I;
    End;
    Writeln(' = ', MultipliedNum);
    Readln;
End.
