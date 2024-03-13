Unit LinkedListUnit;

Interface

Type
    ListPointer = ^LinkedList;

    LinkedList = Record
        Data: Integer;
        Next: ListPointer;
    End;

Procedure Add(HeadPt: ListPointer; Elem: Integer);
Procedure Merge(Dest, First, Second: ListPointer);
Function Len(HeadPt: ListPointer): Integer;

Implementation

Procedure Merge(Dest, First, Second: ListPointer);
Begin
    First := First^.Next;
    Second := Second^.Next;
    Repeat
        New(Dest^.Next);
        Dest := Dest^.Next;
        if First^.Data > Second^.Data then
        Begin
            Dest^.Data := Second^.Data;
            Second := Second^.Next;
        End
        Else
        Begin
            Dest^.Data := First^.Data;
            First := First^.Next;
        End;
    Until (First = Nil) Or (Second = Nil);

    while First <> Nil do
    Begin
        New(Dest^.Next);
        Dest := Dest^.Next;
        Dest^.Data := First^.Data;
        First := First^.Next;
    End;

    while Second <> Nil do
    Begin
        New(Dest^.Next);
        Dest := Dest^.Next;
        Dest^.Data := Second^.Data;
        Second := Second^.Next;
    End;

End;

Function Len(HeadPt: ListPointer): Integer;
Var
    Length: Integer;
Begin
    Length := 0;
    While HeadPt^.Next <> Nil Do
    Begin
        Inc(Length);
        HeadPt := HeadPt^.Next;
    End;
    Len := Length;
End;

Procedure Add(HeadPt: ListPointer; Elem: Integer);
Var
    Temp: Integer;
    TempPt: ListPointer;
    IsAdded: Boolean;
Begin
    IsAdded := False;
    While (HeadPt^.Next <> Nil) And (Not IsAdded) Do
    Begin
        HeadPt := HeadPt^.Next;
        If HeadPt^.Data > Elem Then
        Begin
            Temp := HeadPt^.Data;
            TempPt := HeadPt^.Next;
            HeadPt^.Data := Elem;
            New(HeadPt^.Next);
            HeadPt := HeadPt^.Next;
            HeadPt^.Data := Temp;
            HeadPt^.Next := TempPt;

            IsAdded := True;
        End;
    End;
    If Not IsAdded Then
    Begin
        New(HeadPt^.Next);
        HeadPt := HeadPt^.Next;
        HeadPt^.Data := Elem;
    End;
End;

Function Delete(HeadPt: ListPointer; Index: Integer): Boolean;
Var
    IsDelete: Boolean;
    Count: Integer;
Begin
    IsDelete := False;
    Count := 0;
    While HeadPt^.Next <> Nil Do
    Begin
        Inc(Count);
        HeadPt := HeadPt^.Next;
        If Count = Index Then
        Begin
            HeadPt^.Data := HeadPt^.Next^.Data;
            HeadPt^.Next := HeadPT^.Next^.Next;
            IsDelete := True;
        End;
    End;
    Delete := IsDelete;
End;

End.
