object ChangeRecForm: TChangeRecForm
  Left = 0
  Top = 0
  Caption = #1048#1079#1084#1077#1085#1080#1090#1100
  ClientHeight = 260
  ClientWidth = 379
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  TextHeight = 15
  object NameLabel: TLabel
    Left = 24
    Top = 40
    Width = 31
    Height = 21
    Caption = #1048#1084#1103
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object CostLabel: TLabel
    Left = 24
    Top = 80
    Width = 35
    Height = 21
    Caption = #1094#1077#1085#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object CountLabel: TLabel
    Left = 24
    Top = 123
    Width = 48
    Height = 21
    Caption = #1082#1086#1083'-'#1074#1086
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object AgeLabel: TLabel
    Left = 24
    Top = 160
    Width = 55
    Height = 21
    Caption = #1074#1086#1079#1088#1072#1089#1090
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object FromLabel: TLabel
    Left = 132
    Top = 160
    Width = 16
    Height = 21
    Caption = #1086#1090
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object ToLabel: TLabel
    Left = 208
    Top = 160
    Width = 18
    Height = 21
    Caption = #1076#1086
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object RecNameEdit: TEdit
    Left = 132
    Top = 37
    Width = 189
    Height = 29
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    MaxLength = 20
    ParentFont = False
    TabOrder = 0
    OnChange = AnyEditChange
    OnKeyDown = RecNameEditKeyDown
  end
  object RecCostEdit: TEdit
    Left = 132
    Top = 72
    Width = 101
    Height = 29
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnChange = AnyEditChange
    OnKeyDown = RecCostEditKeyDown
    OnKeyPress = RecCostEditKeyPress
  end
  object RecCountEdit: TEdit
    Left = 132
    Top = 122
    Width = 101
    Height = 29
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnChange = AnyEditChange
    OnKeyDown = RecCountEditKeyDown
    OnKeyPress = RecCountEditKeyPress
  end
  object MinAgeEdit: TEdit
    Left = 154
    Top = 157
    Width = 39
    Height = 29
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnChange = AnyEditChange
    OnKeyDown = MinAgeEditKeyDown
    OnKeyPress = AgeEditKeyPress
  end
  object MaxAgeEdit: TEdit
    Left = 242
    Top = 157
    Width = 39
    Height = 29
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnChange = AnyEditChange
    OnKeyDown = MaxAgeEditKeyDown
    OnKeyPress = AgeEditKeyPress
  end
  object ChangeRecButton: TButton
    Left = 40
    Top = 208
    Width = 305
    Height = 25
    Caption = #1080#1079#1084#1077#1085#1080#1090#1100
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ModalResult = 1
    ParentFont = False
    TabOrder = 5
    OnClick = ChangeRecButtonClick
  end
end
