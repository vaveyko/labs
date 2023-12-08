object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1047#1072#1093#1074#1077#1081' 1_2'
  ClientHeight = 412
  ClientWidth = 628
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = MainMenu1
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  TextHeight = 15
  object InfLabel: TLabel
    Left = 8
    Top = 8
    Width = 321
    Height = 49
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    PopupMenu = PopupMenu1
    Transparent = True
    WordWrap = True
  end
  object Label1: TLabel
    Left = 8
    Top = 73
    Width = 17
    Height = 25
    Caption = 'N:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object CheckButton: TButton
    Left = 8
    Top = 143
    Width = 97
    Height = 34
    Caption = #1055#1088#1086#1074#1077#1088#1080#1090#1100
    Enabled = False
    TabOrder = 0
    OnClick = CheckButtonClick
  end
  object Edit1: TEdit
    Left = 8
    Top = 104
    Width = 121
    Height = 33
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Segoe UI'
    Font.Style = []
    MaxLength = 2
    ParentFont = False
    PopupMenu = PopupMenu1
    TabOrder = 1
    TextHint = 'N'
    OnChange = Edit1Change
    OnKeyDown = Edit1KeyDown
    OnKeyPress = Edit1KeyPress
  end
  object Edit2: TEdit
    Left = 144
    Top = 143
    Width = 129
    Height = 34
    AutoSize = False
    PopupMenu = PopupMenu1
    ReadOnly = True
    TabOrder = 2
  end
  object MainMenu1: TMainMenu
    Left = 357
    Top = 16
    object N1: TMenuItem
      Caption = #1060#1072#1081#1083
      object N2: TMenuItem
        Caption = #1054#1090#1082#1088#1099#1090#1100
        ShortCut = 16463
      end
      object N4: TMenuItem
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
        Enabled = False
        ShortCut = 16467
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object N7: TMenuItem
        Caption = #1042#1099#1093#1086#1076
        Default = True
        ShortCut = 16465
        OnClick = N7Click
      end
    end
    object N5: TMenuItem
      Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103
      OnClick = N5Click
    end
    object N6: TMenuItem
      Caption = #1054' '#1088#1072#1079#1088#1072#1073#1086#1090#1095#1080#1082#1077
      OnClick = N6Click
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 381
    Top = 16
  end
  object OpenTextFileDialog1: TOpenTextFileDialog
    Filter = #1058#1077#1082#1089#1090#1086#1074#1099#1077' '#1092#1072#1081#1083#1099' (*.txt)|*.txt'
    Left = 405
    Top = 16
  end
  object SaveTextFileDialog1: TSaveTextFileDialog
    Filter = #1058#1077#1082#1089#1090#1086#1074#1099#1077' '#1092#1072#1081#1083#1099' (*.txt)|*.txt'
    Left = 429
    Top = 16
  end
end
