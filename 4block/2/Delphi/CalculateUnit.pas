Unit CalculateUnit;

Interface

Type
    IntArr = Array Of Integer;
    Matrix = Array Of IntArr;

Implementation

Procedure DeleteColRow(Var NewMatrix: Matrix; OldMatrix: Matrix;
  ColInd: Integer; RowInd: Integer = 0);
Var
    Size, I, J, CurRow, CurCol: Integer;
Begin
    CurCol := 0;
    CurRow := 0;
    Size := Length(OldMatrix) - 1;
    SetLength(NewMatrix, Size, Size);

    For I := 0 To High(OldMatrix) Do
    Begin
        If I <> RowInd Then
        Begin
            For J := 0 To High(OldMatrix) Do
                If J <> ColInd Then
                Begin
                    NewMatrix[CurRow, CurCol] := OldMatrix[I, J];
                    Inc(CurCol);
                End;
            Inc(CurRow);
        End;
    End;
End;

Function CalcDet(CurMatrix: Matrix): Integer;
Var
    Det, I, Addition: Integer;
    NewMatrix: Matrix;
Begin
    If Length(CurMatrix) = 1 Then
        Det := CurMatrix[0, 0]
    Else
        For I := 0 To High(CurMatrix) Do
            If CurMatrix[0, I] <> 0 Then
            Begin
                DeleteColRow(NewMatrix, CurMatrix, I);
                Addition := CurMatrix[0, I] * CalcDet(NewMatrix);
                if I mod 2 = 1 then
                    Addition := - Addition;
                Inc(Det, Addition);
            End;
    CalcDet := Det;
End;

End.
