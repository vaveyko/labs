Unit MainUnit;

Interface

Uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
    System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtDlgs, Vcl.Menus, Vcl.StdCtrls,
    ManualUnit, DevInfUnit, Vcl.Grids, Vcl.Buttons, Vcl.Mask, Vcl.ExtCtrls,
    Vcl.DBCtrls, AddRecUnit, ChangeRecUnit, BackEndUnit, FindRecUnit;

Type
    TManeForm = Class(TForm)
        MainMenu: TMainMenu;
        FileButtonMenu: TMenuItem;
        SaveButtonMenu: TMenuItem;
        LineMenu: TMenuItem;
        ExitButtonMenu: TMenuItem;
        ManualButtonMenu: TMenuItem;
        DeveloperButtonMenu: TMenuItem;
        PopupMenu: TPopupMenu;
        OpenTextFileDialog: TOpenTextFileDialog;
        SaveTextFileDialog: TSaveTextFileDialog;
        RecordsGrid: TStringGrid;
        AddRecButton: TButton;
        ChangeRecButton: TButton;
        DelRecButton: TButton;
        SearchRecButton: TButton;
        Label1: TLabel;
        Procedure ManualButtonMenuClick(Sender: TObject);
        Procedure DeveloperButtonMenuClick(Sender: TObject);
        Procedure FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
        Procedure ExitButtonMenuClick(Sender: TObject);
        Procedure SaveButtonMenuClick(Sender: TObject);
        Procedure AddRecButtonClick(Sender: TObject);
        Procedure FormCreate(Sender: TObject);
        Procedure ChangeRecButtonClick(Sender: TObject);
        Procedure RecordsGridDblClick(Sender: TObject);
        Procedure DelRecButtonClick(Sender: TObject);
    procedure RecordsGridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure SearchRecButtonClick(Sender: TObject);
    procedure RecordsGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Type
    ERRORS_CODE = (SUCCESS, INCORRECT_DATA_FILE, A_LOT_OF_DATA_FILE,
      OUT_OF_BORDER, OUT_OF_BORDER_SIZE);
    TGridCracker = Class(TStringGrid);
    IntArr = Array Of Integer;
    Matrix = Array Of IntArr;

Const
    ERRORS: Array [ERRORS_CODE] Of String = ('Successfull',
      'Данные в файле не корректные',
      'В файле неверное количество элементов или стоит лишний пробел',
      'Числа должны быть в диапазоне [-70, 70]',
      'Размер должен быть в диапазоне [1, 5]');

Var
    ManeForm: TManeForm;
    IsSaved: Boolean = True;

Implementation

{$R *.dfm}

Procedure TManeForm.FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
Begin
    If Not IsSaved Then
        Case Application.MessageBox('Сохранить данные перед выходом?', 'Выход',
          MB_YESNOCANCEL + MB_ICONQUESTION + MB_DEFBUTTON3) Of
            IDYES:
                Begin
                    SaveButtonMenu.Click;
                    CanClose := True;
                End;
            IDNO:
                CanClose := True;
            IDCANCEL:
                CanClose := False;
        End
    Else
        Case Application.MessageBox('Вы точно хотите выйти?', 'Выход',
          MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2) Of
            IDYES:
                CanClose := True;
            IDNO:
                CanClose := False;
        End;
    If CanClose = True Then
        DeleteFile(СORRECTION_FILE_PATH);
End;

Procedure TManeForm.FormCreate(Sender: TObject);
Var
    StorageFile, CorrectionFile: TToyFile;
Begin
    OpenFile(STORAGE_FILE_PATH, StorageFile, FmReset);
    OpenFile(СORRECTION_FILE_PATH, CorrectionFile, FmRewrite);

    CloneFileToAnother(StorageFile, CorrectionFile);

    CloseFile(StorageFile);
    CloseFile(CorrectionFile);

    //Draw FixedRow information
    RecordsGrid.Cells[0, 0] := '№';
    RecordsGrid.Cells[1, 0] := 'Название';
    RecordsGrid.Cells[2, 0] := 'Цена(BYN)';
    RecordsGrid.Cells[3, 0] := 'Количество';
    RecordsGrid.Cells[4, 0] := 'Возраст';

    DrawRecordOnGrid(RecordsGrid, СORRECTION_FILE_PATH);
End;

Procedure TManeForm.SaveButtonMenuClick(Sender: TObject);
Var
    StorageFile, CorrectionFile: TToyFile;
Begin
    OpenFile(STORAGE_FILE_PATH, StorageFile, FmRewrite);
    OpenFile(СORRECTION_FILE_PATH, CorrectionFile, FmReset);

    CloneFileToAnother(CorrectionFile, StorageFile);
    IsSaved := True;

    CloseFile(StorageFile);
    CloseFile(CorrectionFile);
End;

procedure TManeForm.SearchRecButtonClick(Sender: TObject);
begin
    FindRecForm := TFindRecForm.Create(Self);
    FindRecForm.FormCreate(Self);
    FindRecForm.ShowModal();
    FindRecForm.Free();
end;

Procedure TManeForm.ManualButtonMenuClick(Sender: TObject);
Begin
    ManualForm := TManualForm.Create(Self);
    ManualForm.ShowModal;
    ManualForm.Free;
End;

Procedure TManeForm.RecordsGridDblClick(Sender: TObject);
Begin
    if ChangeRecButton.Enabled then
        ChangeRecButton.Click();
End;

procedure TManeForm.RecordsGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if (Key = VK_DELETE) And (DelRecButton.Enabled) then
        DelRecButton.Click
end;

procedure TManeForm.RecordsGridSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
    if ARow = 0 then
    Begin
        DelRecButton.Enabled := False;
        ChangeRecButton.Enabled := False;
    End
    Else
    Begin
        (Sender as TStringGrid).FixedRows := 1;
        ChangeRecButton.Enabled := True;
        DelRecButton.Enabled := True;
    End;
end;

Procedure TManeForm.AddRecButtonClick(Sender: TObject);
Var
    Res: TModalResult;
Begin
    AddRecForm := TAddRecForm.Create(Self);
    Res := AddRecForm.ShowModal();
    If Res = MrOk Then
        IsSaved := False;
    AddRecForm.Free();
    DrawRecordOnGrid(RecordsGrid, СORRECTION_FILE_PATH);
End;

Procedure TManeForm.ChangeRecButtonClick(Sender: TObject);
Var
    RecIndex: Integer;
    Res: TModalResult;
Begin
    RecIndex := RecordsGrid.Row - 1;

    ChangeRecForm := TChangeRecForm.Create(Self);
    ChangeRecForm.FormCreate(RecIndex, Self);
    Res := ChangeRecForm.ShowModal();
    If Res = MrOk Then
        IsSaved := False;
    ChangeRecForm.Free();
    DrawRecordOnGrid(RecordsGrid, СORRECTION_FILE_PATH);
End;

Procedure TManeForm.DelRecButtonClick(Sender: TObject);
Var
    CurRecIndex: Integer;
    Choice: Integer;
Begin
    CurRecIndex := RecordsGrid.Row - 1;
    Choice := Application.MessageBox('Вы точно хотите удалить запись?', 'Внимание!',
                                  MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2);
    If (Choice = IDYES) then
    Begin
        DeleteRec(CurRecIndex);
        DrawRecordOnGrid(RecordsGrid, СORRECTION_FILE_PATH);
        IsSaved := False;
    End;
End;

Procedure TManeForm.DeveloperButtonMenuClick(Sender: TObject);
Begin
    DeveloperForm := TDeveloperForm.Create(Self);
    DeveloperForm.ShowModal;
    DeveloperForm.Free;
End;

Procedure TManeForm.ExitButtonMenuClick(Sender: TObject);
Begin
    Close();
End;

End.
