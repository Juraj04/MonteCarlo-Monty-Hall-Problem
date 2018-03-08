object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Form2'
  ClientHeight = 518
  ClientWidth = 729
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = OnCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 729
    Height = 161
    Align = alTop
    TabOrder = 0
    object Label5: TLabel
      Left = 666
      Top = 16
      Width = 3
      Height = 13
    end
    object Label6: TLabel
      Left = 666
      Top = 35
      Width = 3
      Height = 13
    end
    object Label3: TLabel
      Left = 447
      Top = 16
      Width = 185
      Height = 13
      Caption = 'Probability of winning with change (%)'
    end
    object Label7: TLabel
      Left = 447
      Top = 35
      Width = 201
      Height = 13
      Caption = 'Probability of winning without change (%)'
    end
    object Panel1: TPanel
      Left = 352
      Top = 0
      Width = 89
      Height = 161
      TabOrder = 0
      object ButtonStart: TButton
        Left = 7
        Top = 11
        Width = 75
        Height = 25
        Caption = 'Start'
        TabOrder = 0
        OnClick = ButtonStartClick
      end
      object ButtonStop: TButton
        Left = 7
        Top = 42
        Width = 75
        Height = 25
        Caption = 'Stop'
        TabOrder = 1
        OnClick = ButtonStopClick
      end
    end
    object PanelSettings: TPanel
      Left = 0
      Top = 0
      Width = 353
      Height = 161
      Align = alCustom
      TabOrder = 1
      object Label1: TLabel
        Left = 16
        Top = 16
        Width = 111
        Height = 13
        Caption = 'Number of replications:'
      end
      object Label2: TLabel
        Left = 16
        Top = 43
        Width = 102
        Height = 13
        Caption = 'Warm up period (%):'
      end
      object Label4: TLabel
        Left = 16
        Top = 94
        Width = 84
        Height = 13
        Caption = 'Number of doors:'
      end
      object LabelDoorNumber: TLabel
        Left = 106
        Top = 94
        Width = 85
        Height = 13
        Caption = 'LabelDoorNumber'
      end
      object EditReplications: TEdit
        Left = 133
        Top = 13
        Width = 60
        Height = 21
        NumbersOnly = True
        TabOrder = 0
      end
      object EditWarm: TEdit
        Left = 133
        Top = 40
        Width = 60
        Height = 21
        NumbersOnly = True
        TabOrder = 1
      end
      object TrackBarDoors: TTrackBar
        Left = 16
        Top = 113
        Width = 177
        Height = 45
        Min = 3
        Position = 3
        TabOrder = 2
        OnChange = TrackBarDoorsChange
      end
      object CheckBoxWithChange: TCheckBox
        Left = 208
        Top = 15
        Width = 113
        Height = 17
        Caption = '"With change" line'
        Checked = True
        State = cbChecked
        TabOrder = 3
      end
      object CheckBoxWithoutChange: TCheckBox
        Left = 208
        Top = 38
        Width = 138
        Height = 17
        Caption = '"Without change" line'
        Checked = True
        State = cbChecked
        TabOrder = 4
      end
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 161
    Width = 729
    Height = 360
    Align = alTop
    TabOrder = 1
    object ChartMontyHall: TChart
      Left = 133
      Top = -21
      Width = 729
      Height = 358
      Title.Text.Strings = (
        'TChart')
      BottomAxis.MaximumOffset = 10
      BottomAxis.MinimumOffset = 10
      DepthTopAxis.MinimumOffset = 1
      LeftAxis.MaximumOffset = 50
      LeftAxis.MinimumOffset = 50
      TopAxis.MaximumOffset = 10
      TopAxis.MinimumOffset = 10
      View3D = False
      TabOrder = 0
      DefaultCanvas = 'TGDIPlusCanvas'
      ColorPaletteIndex = 17
      object Series1: TLineSeries
        Title = 'With Change'
        Brush.BackColor = clDefault
        Pointer.InflateMargins = True
        Pointer.Style = psRectangle
        XValues.Name = 'X'
        XValues.Order = loAscending
        YValues.Name = 'Y'
        YValues.Order = loNone
      end
      object Series2: TLineSeries
        Title = 'Without Change'
        Brush.BackColor = clDefault
        Pointer.InflateMargins = True
        Pointer.Style = psRectangle
        XValues.Name = 'X'
        XValues.Order = loAscending
        YValues.Name = 'Y'
        YValues.Order = loNone
      end
    end
  end
end
