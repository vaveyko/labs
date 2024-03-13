Unit TreeUnit;

Interface

Type
    TNodePointer = ^TNode;
    TNode = Record
        Data: Integer;
        Left, Right: TNodePointer;
    End;
    TTree = ^TTreeHead;
    TTreeHead = Record
        Next: TNodePointer;
    End;

Function CreateTree(): TTree;
Function Add(Var Node: TNodePointer; Elem: Integer): Boolean;
Function GetHigh(Node: TNodePointer): Integer;
Procedure DeleteTree(Var Node: TNodePointer);

Implementation

Procedure DeleteTree(Var Node: TNodePointer);
Begin
    if Node^.Left <> Nil then
        DeleteTree(Node^.Left);
    if Node^.Right <> Nil then
        DeleteTree(Node^.Right);

    Node^.Data := 0;
    Node := Nil;
    Dispose(Node);
End;

Function GetHigh(Node: TNodePointer): Integer;
Var
    LCount, RCount, High: Integer;
Begin
    High := 0;
    if Node <> Nil then
    Begin
        Inc(High);
        LCount := High + GetHigh(Node^.Left);
        RCount := High + GetHigh(Node^.Right);

        if LCount > RCount then
            High := LCount
        Else
            High := RCount;
    End;
    GetHigh := High;
End;

Function Add(Var Node: TNodePointer; Elem: Integer): Boolean;
Var
    IsAdded: Boolean;
Begin
    IsAdded := False;
    if Node = Nil then
    Begin
        New(Node);
        Node^.Data := Elem;
        Node^.Left := Nil;
        Node^.Right := Nil;
        IsAdded := True;
    End
    Else if Elem > Node^.Data then
        IsAdded := Add(Node^.Right, Elem)
    Else if Elem < Node^.Data then
        IsAdded := Add(Node^.Left, Elem);
    Add := IsAdded;
End;

Function CreateTree(): TTree;
Var
    Tree: TTree;
Begin
    New(Tree);
    Tree^.Next := Nil;
    CreateTree := Tree;
End;

End.
