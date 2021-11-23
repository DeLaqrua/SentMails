object FormMain: TFormMain
  Left = 0
  Top = 0
  Caption = 'FormMain'
  ClientHeight = 650
  ClientWidth = 864
  Color = clBackground
  Constraints.MinHeight = 390
  Constraints.MinWidth = 880
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWhite
  Font.Height = -19
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  DesignSize = (
    864
    650)
  PixelsPerInch = 96
  TextHeight = 23
  object LabelMonth: TLabel
    Left = 168
    Top = 269
    Width = 513
    Height = 23
    Alignment = taCenter
    Anchors = [akTop]
    AutoSize = False
  end
  object buttonCheck: TButton
    Left = 256
    Top = 208
    Width = 329
    Height = 33
    Anchors = [akTop]
    Caption = #1055#1088#1086#1074#1077#1088#1080#1090#1100' '#1086#1090#1087#1088#1072#1074#1083#1077#1085#1085#1099#1077' '#1087#1080#1089#1100#1084#1072
    TabOrder = 1
    OnClick = buttonCheckClick
  end
  object groupboxSelectMO: TGroupBox
    Left = 16
    Top = 80
    Width = 833
    Height = 113
    Anchors = [akTop]
    TabOrder = 2
    object labelSelectMo: TLabel
      Left = 56
      Top = 23
      Width = 113
      Height = 23
      AutoSize = False
      Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1052#1054':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsItalic]
      ParentFont = False
    end
    object LabelSelectMonth: TLabel
      Left = 40
      Top = 68
      Width = 129
      Height = 23
      AutoSize = False
      Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1052#1077#1089#1103#1094':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsItalic]
      ParentFont = False
    end
    object comboboxSelectMO: TComboBox
      Left = 175
      Top = 15
      Width = 610
      Height = 31
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ItemIndex = 0
      ParentFont = False
      TabOrder = 0
      Text = '<'#1074#1089#1077'>'
      Items.Strings = (
        '<'#1074#1089#1077'>')
    end
    object comboboxSelectMonth: TComboBox
      Left = 175
      Top = 60
      Width = 483
      Height = 31
      Style = csDropDownList
      DropDownCount = 14
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ItemIndex = 0
      ParentFont = False
      TabOrder = 1
      Text = '<'#1074#1089#1077'>'
      OnSelect = comboboxSelectMonthSelect
      Items.Strings = (
        '<'#1074#1089#1077'>'
        #1071#1085#1074#1072#1088#1100
        #1060#1077#1074#1088#1072#1083#1100
        #1052#1072#1088#1090
        #1040#1087#1088#1077#1083#1100
        #1052#1072#1081
        #1048#1102#1085#1100
        #1048#1102#1083#1100
        #1040#1074#1075#1091#1089#1090
        #1057#1077#1085#1090#1103#1073#1088#1100
        #1054#1082#1090#1103#1073#1088#1100
        #1053#1086#1103#1073#1088#1100
        #1044#1077#1082#1072#1073#1088#1100)
    end
    object SpinEditYear: TSpinEdit
      Left = 664
      Top = 59
      Width = 121
      Height = 33
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      MaxValue = 3000
      MinValue = 2021
      ParentFont = False
      TabOrder = 2
      Value = 2021
      OnChange = SpinEditYearChange
    end
  end
  object groupboxSelectDirectory: TGroupBox
    Left = 16
    Top = 8
    Width = 833
    Height = 57
    Anchors = [akTop]
    TabOrder = 3
    object labelSelectDirectory: TLabel
      Left = 29
      Top = 16
      Width = 321
      Height = 23
      AutoSize = False
      Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1072#1087#1082#1091' '#1076#1083#1103' '#1086#1090#1089#1083#1077#1078#1080#1074#1072#1085#1080#1103' '#1087#1080#1089#1077#1084':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsItalic]
      ParentFont = False
    end
    object editSelectDirectory: TEdit
      Left = 356
      Top = 11
      Width = 397
      Height = 31
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = 'E:\Proba\'#1054#1090#1087#1088#1072#1074#1083#1077#1085#1085#1099#1077' '#1087#1080#1089#1100#1084#1072
    end
    object buttonSelectDirectory: TButton
      Left = 759
      Top = 14
      Width = 26
      Height = 25
      Caption = '...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = buttonSelectDirectoryClick
    end
  end
  object stringgridMails: TStringGrid
    Left = 8
    Top = 304
    Width = 848
    Height = 338
    Anchors = [akTop, akBottom]
    ColCount = 4
    DefaultRowHeight = 32
    DrawingStyle = gdsGradient
    FixedCols = 0
    RowCount = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    Options = [goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goTabs]
    ParentFont = False
    TabOrder = 0
    OnMouseEnter = stringgridMailsMouseEnter
    ColWidths = (
      352
      39
      155
      347)
  end
end
