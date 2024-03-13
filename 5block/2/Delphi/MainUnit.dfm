object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = #1047#1072#1093#1074#1077#1081'_5_2'
  ClientHeight = 433
  ClientWidth = 702
  Color = clBtnFace
  Constraints.MinHeight = 400
  Constraints.MinWidth = 714
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = MainMenu
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnResize = FormResize
  TextHeight = 15
  object TaskLabel: TLabel
    Left = 56
    Top = 0
    Width = 585
    Height = 28
    Caption = #1055#1088#1086#1075#1088#1072#1084#1084#1072' '#1089#1090#1088#1086#1080#1090' '#1076#1077#1088#1077#1074#1086' '#1080' '#1087#1086#1076#1089#1074#1077#1095#1080#1074#1072#1077#1090' '#1074#1099#1073#1088#1072#1085#1085#1099#1081' '#1101#1083#1077#1084#1077#1085#1090
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object AddButton: TButton
    Left = 256
    Top = 25
    Width = 185
    Height = 50
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100
    Enabled = False
    TabOrder = 0
    OnClick = AddButtonClick
  end
  object NewNodeEdit: TEdit
    Left = 24
    Top = 25
    Width = 185
    Height = 50
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -30
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    PopupMenu = PopupMenu
    TabOrder = 1
    OnChange = NewNodeEditChange
    OnKeyDown = NewNodeEditKeyDown
    OnKeyPress = NewNodeEditKeyPress
  end
  object ScrollBox: TScrollBox
    Left = 0
    Top = 168
    Width = 737
    Height = 201
    HorzScrollBar.Tracking = True
    VertScrollBar.Tracking = True
    TabOrder = 2
    object MainPaintBox: TPaintBox
      Left = 22
      Top = 3
      Width = 343
      Height = 91
      OnPaint = MainPaintBoxPaint
    end
  end
  object FreeButton: TButton
    Left = 480
    Top = 25
    Width = 185
    Height = 50
    Caption = #1054#1095#1080#1089#1090#1080#1090#1100
    Enabled = False
    TabOrder = 3
    OnClick = FreeButtonClick
  end
  object StringGrid1: TStringGrid
    Left = 24
    Top = 81
    Width = 641
    Height = 81
    ColCount = 1
    DefaultRowHeight = 30
    FixedCols = 0
    RowCount = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Segoe UI'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goThumbTracking, goFixedRowDefAlign]
    ParentFont = False
    TabOrder = 4
    Visible = False
    OnClick = StringGrid1Click
  end
  object Timer: TTimer
    Interval = 100
    Left = 704
    Top = 16
  end
  object MainMenu: TMainMenu
    Left = 61
    Top = 384
    object ManualButtonMenu: TMenuItem
      Caption = #1048#1085#1089#1090#1088#1091#1082#1094#1080#1103
      OnClick = ManualButtonMenuClick
    end
    object DeveloperButtonMenu: TMenuItem
      Caption = #1054' '#1088#1072#1079#1088#1072#1073#1086#1090#1095#1080#1082#1077
      OnClick = DeveloperButtonMenuClick
    end
  end
  object PopupMenu: TPopupMenu
    Left = 184
    Top = 384
  end
end
