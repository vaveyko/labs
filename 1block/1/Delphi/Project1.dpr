Program Task1Block1;

Uses
    System.SysUtils;

Const
    MIN = 0;
    MAX = 200;

Var
    FirstSide, SecondSide, ThirdSide: Integer;
    IsTriangleExist, IsCorrect: Boolean;

Begin
    IsTriangleExist := True;
    Writeln('��������� ����������: �������� �� ����������� � ������� ��������� ��������������.');
    Writeln('������ ������� - �����, ������������� �����.');
    Repeat
    Begin
        IsTriangleExist := True;
        Try
            Writeln('������� 3 ������� ������������ ����� ������');
            Readln(FirstSide, SecondSide, ThirdSide);
        Except
            Writeln('������������ ������� ������');
            IsTriangleExist := False;
        End;
        IsCorrect := (SecondSide > MIN) And (SecondSide < MAX) And
          (ThirdSide > MIN) And (ThirdSide < MAX) And (FirstSide > MIN) And
          (FirstSide < MAX);
        If IsTriangleExist And IsCorrect Then
        Begin
            If ((FirstSide + SecondSide) <= ThirdSide) Or
              ((SecondSide + ThirdSide) <= FirstSide) Or
              ((ThirdSide + FirstSide) <= SecondSide) Then
            Begin
                Writeln('������������ � ������ ��������� �� ����������(');
                IsTriangleExist := False;
            End;
        End
        Else
        Begin
            If IsTriangleExist Then
                Writeln('������� ������������ ������ ���� ������ ', MIN,
                  ' � ������ ', MAX, '.');
            IsTriangleExist := False;
        End;
    End;
    Until IsTriangleExist;
    If (FirstSide = SecondSide) Or (FirstSide = ThirdSide) Or
      (SecondSide = ThirdSide) Then
        Writeln('����������� ��������������')
    Else
        Writeln('����������� �� ��������������');

    Readln;
End.
