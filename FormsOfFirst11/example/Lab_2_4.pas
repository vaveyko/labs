unit Lab_2_4;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, Vcl.Menus,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    StringGrid1: TStringGrid;
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    Label2: TLabel;
    Button3: TButton;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    PopupMenu1: TPopupMenu;
    StringGrid2: TStringGrid;
    Label1: TLabel;
    Label4: TLabel;
    Image1: TImage;
    Image2: TImage;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure StringGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure FormClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure N5Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure StringGrid1SetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  N: Integer;

implementation

{$R *.dfm}

Type
    TMatrix = Array of Array of Integer;

Function GetResult(Matrix: TMatrix; N: Integer): TMatrix;
Var
    I, J, LastNum, LastNum1: Integer;
    NewMatrix: TMatrix;
Begin
    SetLength(NewMatrix, N, N);
    LastNum := N div 2;
    LastNum1 := LastNum - 1;
    Dec(N);
    For I := 0 to LastNum1 Do
    Begin
        For J := 0 to LastNum1 Do
            NewMatrix[I][J] := Matrix[I + LastNum][j + LastNum];
        For J := LastNum to N Do
            NewMatrix[I][J] := Matrix[I + LastNum][J - LastNum];
    End;
    For I := LastNum to N Do
    Begin
        For J := 0 to LastNum1 Do
            NewMatrix[I][J] := matrix[I - LastNum][J];
        For J := LastNum to N Do
            NewMatrix[I][J] := Matrix[I - LastNum][J];
    End;
    GetResult := NewMatrix;
End;

procedure TForm1.Button1Click(Sender: TObject);
var
    I: Integer;
begin
    N := StrToInt(Edit1.Text);
    if (N < 2) or (N > 16) then
    Begin
        Application.MessageBox('Значение порядка матрицы должно находиться в диапазоне от 2 до 16', 'Ошибка!', MB_ICONERROR);
        Edit1.Clear;
    End
    Else
        if N mod 2 <> 0 then
        begin
            Application.MessageBox('Порядок матрицы должен быть четным!', 'Ошибка!', MB_ICONERROR);
            Edit1.Clear;
        end
        Else
        Begin
            StringGrid1.Enabled := True;
            StringGrid1.ColCount := N + 1;
            StringGrid1.RowCount := N + 1;
            StringGrid2.ColCount := N + 1;
            StringGrid2.RowCount := N + 1;
            StringGrid1.Cells[0, 0] := 'i\j';
            StringGrid2.Cells[0, 0] := 'i\j';
            for I := 1 to N do
            begin
                StringGrid1.Cells[I, 0] := IntToStr(I);
                StringGrid1.Cells[0, I] := IntToStr(I);
                StringGrid2.Cells[I, 0] := IntToStr(I);
                StringGrid2.Cells[0, I] := IntToStr(I);
            end;
        End;

end;

procedure TForm1.Button2Click(Sender: TObject);

var
    I, J, K, O: Integer;
    IsCorrect, IsCorrect2: Boolean;
    Err, Err2, text: String;
    arr, arr2: array of Integer;
    Mtx, NewMtx: TMatrix;
begin
    Err := 'Данные введенные в строке';
    Err2 := ' не входят в допустимый диапазон';
    text := 'Были введены некорректные данные в строке ';
    IsCorrect := True;
    isCorrect2 := True;
    SetLength(arr, N + 1);
    SetLength(arr2, N + 1);
    for I := 1 to N do
    begin
        arr2[I] := 0;
        arr[I] := 0;
    end;
        for I := 1 to N do
        begin
            K:= I;
            for J := 1 to N do
            Begin
                O:= J;
                Try
                if (StrToInt(StringGrid1.Cells[J, I]) < -25000) or (StrToInt(StringGrid1.Cells[J, I]) > 25000) Then
                Begin
                    arr[J] := J;
                    StringGrid1.Cells[J, I] := '';
                    IsCorrect := False;
                    button2.Enabled := False;
                End;
                Except
                    IsCorrect2 := False;
                    arr2[I] := I;
                    StringGrid1.Cells[O, K] := '';
                    button2.Enabled := False;
                End;
            End;
        end;
        if not IsCorrect2 then
        begin
            for I := 1 to N do
                if arr2[I] <> 0 then
                    text := text + IntToStr(arr2[I]) + ' ';
            Application.MessageBox(PWideChar(WideString(text)), 'Ошибка!', MB_ICONERROR);
        end;
        if IsCorrect and isCorrect2 then
        Begin
            SetLength(Mtx, N, N);
            For I := 1 to N Do
                for J := 1 to N do
                    Mtx[J - 1, I - 1] := StrToInt(StringGrid1.Cells[I, J]);
            NewMtx := GetResult(Mtx, N);
            for I := 1 to N do
                for J := 1 to N do
                    StringGrid2.Cells[I, J] := IntToStr(NewMtx[J - 1, I - 1]);
            N6.Enabled := True;
        End
        Else
        if not isCorrect then
        Begin
            for I := 1 to N do
                if arr[I] <> 0 then
                    Err := Err + ' ' + IntToStr(arr[I]);
            Err := Err + Err2;
            Application.MessageBox(PWideChar(WideString(Err)), 'Ошибка!', MB_ICONERROR);
        End;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
    I, J: Integer;
begin
    for I := 1 to N do
    begin
        for J := 1 to N do
        begin
            StringGrid1.Cells[I, J] := '';
            StringGrid2.Cells[I, J] := '';
        end;
    end;
    Button2.Enabled := False;
    N6.Enabled := False;
end;

procedure TForm1.Edit1Change(Sender: TObject);
begin
    StringGrid1.Enabled := False;
    if Edit1.Text = '' then
        Button1.Enabled := False
    else
        Button1.Enabled := True;
    Button3.Click;
end;

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
    if (Key = ^M) and (Edit1.Text <> '') then
    begin
        Button1.Click;
        Key := #0;
    end;
end;

procedure TForm1.FormClick(Sender: TObject);
var
    IsEmpty: Boolean;
    I, J: Integer;
begin
    form1.FocusControl(nil);
    IsEmpty := True;
    for I := 1 to N do
        for J := 1 to N do
            if (StringGrid1.Cells[I, J] = '') or (edit1.Text = '') then
                IsEmpty := True
            ELse
                IsEmpty := False;
    if not IsEmpty then
        Button2.Enabled := True
    else
        Button2.Enabled := False;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
    case Application.MessageBox('Вы точно хотите выйти из программы?', 'Выход', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2) of
        IDYES: CanClose := True;
        IDNO: CanClose := False;
    end;
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
begin
    if (Key = ^M) and (Edit1.Text <> '') then
    begin
        Button1.Click;
        Key := #0;
    end;
end;

procedure TForm1.N2Click(Sender: TObject);
Const
    TEXT1 = 'Данная программа из квадратной матрицы порядка 2n       1 2';
    TEXT1_1 = '3 4';
    TEXT1_2 = 'Получает новую матрицу                                          4 3';
    TEXT1_3 = 'Цифрами обозначены подматрицы порядка n   1 2';
    TEXT1_4 = 'Все данные - целые числа';
    TEXT2 = 'Диапазон значений порядка матрицы - [2..16]';
    TEXT3 = 'Диапазон значений элементов матрицы - [-25000..25000]';
    TEXT4 = 'В файле для открытия порядок матрицы должен быть записан на первом месте, далее матрица в виде:';
    TEXT5 = 'A11 A12 ... A1k';
    TEXT6 = 'A21 A22 ... A2k';
    TEXT7 = '...';
    TEXT8 = 'Ai1 A2 ... Aik';
    TEXT9 = 'Где A - элемент матрицы, i - номер строки, k - номер столбца';
    TEXT10 = 'Невведенным элементам будет присвоен 0';
begin
    Application.MessageBox(TEXT1 + #10#13 + TEXT1_1 + #10#13 + TEXT1_2 + #10#13 + TEXT1_3 + #10#13 + TEXT1_4 + #10#13 + TEXT2 + #10#13 + TEXT3 + #10#13 + TEXT4 + #10#13 + TEXT5 + #10#13 + TEXT6 + #10#13 + TEXT7 + #10#13 + TEXT8 + #10#13 + TEXT9 + #10#13 + TEXT10, 'Инструкция', MB_ICONINFORMATION);
end;

procedure TForm1.N3Click(Sender: TObject);
begin
    Application.MessageBox('Студент группы 251004 Елькин Матвей', 'О разработчике', MB_ICONINFORMATION);
end;

procedure TForm1.N5Click(Sender: TObject);
Var
    I, J: Integer;
    InputFile: TextFile;
    IsCorrect: Boolean;
    M: Tmatrix;
begin
    If OpenDialog1.Execute() then
    Begin
        Button3.Click;
        IsCorrect := True;
        AssignFile(InputFile, OpenDialog1.FileName);
        Reset(InputFile);
        Try
            Read(InputFile, N);
            If (N < 2) or (N > 16) or (N mod 2 <> 0) Then
                Application.MessageBox('Значение порядка матрицы должно находиться в диапазоне от 2 до 16 и должно быть четным', 'Ошибка!', MB_ICONERROR)
            else
            Begin
                SetLength(M, N + 1, N + 1);
                for I := 1 to N do
                    for J := 1 to N do
                    Begin
                        Read(InputFile, M[I, J]);
                        If (M[I, J] < -25000) or (M[I, J] > 25000) Then
                            IsCorrect := false;
                    End;
                    if IsCorrect then
                    Begin
                        Edit1.Text := IntToStr(N);
                        for I := 1 to N do
                            for J := 1 to N + 1 do
                                StringGrid1.Cells[J, I] := IntToStr(M[I, J]);
                        Button1.Click;
                        Button2.Enabled := True;
                    End
                    Else
                        Application.MessageBox('Значение элементов матрицы должно находиться в диапазоне от -25000 до 25000', 'Ошибка!', MB_ICONERROR);
            End;
        Except
            Application.MessageBox('Файл содержит неверные данные! ', 'Ошибка!', MB_ICONERROR);
            Edit1.Clear;
            for I := 1 to N do
                for J := 1 to N do
                    StringGrid1.Cells[I, J] := '';
        End;
        CloseFile(InputFile);
    End;
end;

procedure TForm1.N6Click(Sender: TObject);
Var
    OutputFile: TextFile;
    I, J: Integer;
begin
    If SaveDialog1.Execute() then
    Begin
        AssignFile(OutputFile, SaveDialog1.FileName);
        Rewrite(OutputFile);
        Writeln(OutputFile, 'Исходная матрица:');
        For I := 1 to N do
        begin
            for J := 1 to N do
                Write(OutputFile, StringGrid1.Cells[J, I] + ' ');
            Writeln(OutputFile);
        end;
        Writeln(OutputFile, 'Новая матрица:');
        For I := 1 to N do
        begin
            for J := 1 to N do
                Write(OutputFile, StringGrid2.Cells[J, I] + ' ');
            Writeln(OutputFile);
        end;
        CloseFile(OutputFile);
        Application.MessageBox('Данные успешно записаны в файл!', 'Сохранение', MB_ICONINFORMATION);
    End
    Else
        Application.MessageBox('Ошибка сохранения в файл!', 'Ошибка!', MB_ICONERROR);
end;

procedure TForm1.StringGrid1KeyPress(Sender: TObject; var Key: Char);
var
    I, J: Integer;
    IsEmpty: Boolean;
begin
    if Key = #8 then
    Begin
        N6.Enabled := False;
    End;
    IsEmpty := False;
    for I := 1 to N do
        for J := 1 to N do
            if StringGrid1.Cells[I, J] = '' then
                IsEmpty := True;
    if not IsEmpty then
        Button2.Enabled := True
    else
        Button2.Enabled := False;
end;

procedure TForm1.StringGrid1SetEditText(Sender: TObject; ACol, ARow: Integer;
  const Value: string);
Var
    I, J: Integer;
    IsCorrect: Boolean;
begin
    IsCorrect := True;
    For I := 1 to StringGrid1.RowCount - 1 do
        For J := 0 to StringGrid1.ColCount - 1 do
            If Length(StringGrid1.Cells[J, I]) = 0 Then
                IsCorrect := False;
    Button2.Enabled := IsCorrect;
end;

end.

{
procedure TForm1.Button2Click(Sender: TObject);

var
    I, J, K, O: Integer;
    IsCorrect: Boolean;
    Err, Err2, text: String;
    arr: array of Integer;
    Mtx, NewMtx: TMatrix;
begin
    Err := 'Данные введенные в строке';
    Err2 := ' не входят в допустимый диапазон';
    text := 'Были введены некорректные данные в строке ';
    IsCorrect := True;
    SetLength(arr, N + 1);
    for I := 1 to N do
        arr[I] := 0;
    Try
        for I := 1 to N do
        begin
            O := I;
            for J := 1 to N do
            Begin
                K := J;
                if (StrToInt(StringGrid1.Cells[I, J]) < -25000) or (StrToInt(StringGrid1.Cells[I, J]) > 25000) Then
                Begin
                    arr[J] := J;
                    StringGrid1.Cells[I, J] := '';
                    IsCorrect := False;
                    button2.Enabled := False;
                End;
            End;
        end;
        if IsCorrect then
        Begin
            SetLength(Mtx, N, N);
            For I := 1 to N Do
                for J := 1 to N do
                    Mtx[J - 1, I - 1] := StrToInt(StringGrid1.Cells[I, J]);
            NewMtx := GetResult(Mtx, N);
            for I := 1 to N do
                for J := 1 to N do
                    StringGrid2.Cells[I, J] := IntToStr(NewMtx[J - 1, I - 1]);
            N6.Enabled := True;
        End
        Else
        Begin
            for I := 1 to N do
                if arr[I] <> 0 then
                    Err := Err + ' ' + IntToStr(arr[I]);
            Err := Err + Err2;
            Application.MessageBox(PWideChar(WideString(Err)), 'Ошибка!', MB_ICONERROR);
        End;
    Except
        text := text + IntToStr(K);
        Application.MessageBox(PWideChar(WideString(text)), 'Ошибка!', MB_ICONERROR);
        StringGrid1.Cells[O, K] := '';
        button2.Enabled := False;
    End;
end;

}
