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
    Writeln('Программа определяет: является ли треугольник с данными сторонами равнобедренным.');
    Writeln('Длинна стороны - целое, положительное число.');
    Repeat
    Begin
        IsTriangleExist := True;
        Try
            Writeln('Введите 3 стороны треугольника через пробел');
            Readln(FirstSide, SecondSide, ThirdSide);
        Except
            Writeln('Неправильные входные данные');
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
                Writeln('Треугольника с такими сторонами не существует(');
                IsTriangleExist := False;
            End;
        End
        Else
        Begin
            If IsTriangleExist Then
                Writeln('Сторона треугольника должна быть больше ', MIN,
                  ' и меньше ', MAX, '.');
            IsTriangleExist := False;
        End;
    End;
    Until IsTriangleExist;
    If (FirstSide = SecondSide) Or (FirstSide = ThirdSide) Or
      (SecondSide = ThirdSide) Then
        Writeln('Треугольник равнобедренный')
    Else
        Writeln('Треугольник не равнобедренный');

    Readln;
End.
