Program Project2;

Uses
    System.SysUtils;

Const
    MAX_VALUE = 3000000000;
    MIN_VALUE = 1;

Procedure PrintInf();
Begin
    Writeln('Программа вычисляет все числа Марсена меньше n, где n [',
      MIN_VALUE, ', ', MAX_VALUE, ']');
    Writeln('Число Мерсена -- простое число, которое можно представить в виде 2^р – 1, где р – тоже простое число.');
End;

Function InputNum(): FixedUInt;
Var
    Number: FixedUInt;
    IsCorrect: Boolean;
Begin
    Repeat
        IsCorrect := True;
        Writeln('Введите n');
        Try
            Readln(Number);
        Except
            Writeln('Ошибка, не верный тип данных!');
            IsCorrect := False;
        End;
        If (IsCorrect And (Number < MIN_VALUE) Or (Number > MAX_VALUE)) Then
        Begin
            IsCorrect := False;
            Writeln('Ошибка, число должно быть больше ', MIN_VALUE,
              ' и меньше ', MAX_VALUE);
        End;
    Until IsCorrect;
    InputNum := Number;
End;

Function IsNumSimpl(Numb: FixedUInt): Boolean;
Var
    IsSimpl: Boolean;
    NumbSqrt, I: Integer;
Begin
    NumbSqrt := Trunc(Sqrt(Numb));
    IsSimpl := True;
    If (Numb > 3) Then
        For I := 2 To NumbSqrt Do
            If (Numb Mod I = 0) Then
                IsSimpl := False;

    IsNumSimpl := IsSimpl;
End;

Procedure PrintMersNum(HighBord: FixedUInt);
Var
    IsBordIncross: Boolean;
    MersenNum: FixedUInt;
    I: Integer;
Begin
    MersenNum := 1;
    I := 2;
    IsBordIncross := True;
    While IsBordIncross Do
    Begin
        MersenNum := MersenNum * 2 + 1;
        IsBordIncross := MersenNum < HighBord;
        If (IsBordIncross And IsNumSimpl(I) And IsNumSimpl(MersenNum)) Then
            Writeln('Mersen(', I, ') -- ', MersenNum);
        Inc(I);
    End;
End;

Var
    HighBorder: FixedUInt;

Begin
    PrintInf;
    HighBorder := InputNum();
    PrintMersNum(HighBorder);
    Readln;
End.
