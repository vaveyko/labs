object AddForm: TAddForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100
  ClientHeight = 227
  ClientWidth = 475
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnShow = FormShow
  TextHeight = 15
  object NewElemLabel: TLabel
    Left = 152
    Top = 8
    Width = 163
    Height = 28
    Caption = #1053#1054#1042#1067#1049' '#1069#1051#1045#1052#1045#1053#1058
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object AddButton: TButton
    Left = 100
    Top = 160
    Width = 119
    Height = 40
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ModalResult = 1
    ParentFont = False
    TabOrder = 0
    OnClick = AddButtonClick
  end
  object CancelButton: TButton
    Left = 248
    Top = 160
    Width = 119
    Height = 40
    Caption = #1054#1090#1084#1077#1085#1080#1090#1100
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ModalResult = 2
    ParentFont = False
    TabOrder = 1
  end
  object NewElemEdit: TEdit
    Left = 136
    Top = 72
    Width = 193
    Height = 62
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -40
    Font.Name = 'Segoe UI'
    Font.Style = []
    MaxLength = 8
    ParentFont = False
    TabOrder = 2
    OnChange = NewElemEditChange
    OnKeyDown = NewElemEditKeyDown
    OnKeyPress = NewElemEditKeyPress
  end
end
