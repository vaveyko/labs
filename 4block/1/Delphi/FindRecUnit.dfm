object FindRecForm: TFindRecForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1055#1086#1080#1089#1082
  ClientHeight = 331
  ClientWidth = 525
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object AgeCharacterLabel: TLabel
    Left = 32
    Top = 24
    Width = 59
    Height = 21
    Caption = #1042#1086#1079#1088#1072#1089#1090':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object DashLabel: TLabel
    Left = 160
    Top = 24
    Width = 19
    Height = 21
    Caption = '-'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object CostCharacterLabel: TLabel
    Left = 32
    Top = 59
    Width = 72
    Height = 21
    Caption = #1062#1077#1085#1072' ('#1076#1086'):'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object RecordsGrid: TStringGrid
    Left = 8
    Top = 104
    Width = 510
    Height = 209
    DefaultColWidth = 80
    FixedCols = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goEditing, goRowSelect, goThumbTracking, goFixedRowDefAlign]
    ParentFont = False
    TabOrder = 0
    ColWidths = (
      41
      180
      97
      99
      66)
  end
  object MinAgeEdit: TEdit
    Left = 115
    Top = 21
    Width = 39
    Height = 29
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    Text = '1'
    OnChange = AnyEditChange
    OnKeyDown = MinAgeEditKeyDown
    OnKeyPress = AgeEditKeyPress
  end
  object MaxAgeEdit: TEdit
    Left = 177
    Top = 21
    Width = 39
    Height = 29
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    Text = '120'
    OnChange = AnyEditChange
    OnKeyDown = MaxAgeEditKeyDown
    OnKeyPress = AgeEditKeyPress
  end
  object RecCostEdit: TEdit
    Left = 115
    Top = 56
    Width = 101
    Height = 29
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    Text = '3'
    OnChange = AnyEditChange
    OnKeyDown = RecCostEditKeyDown
    OnKeyPress = RecCostEditKeyPress
  end
end
