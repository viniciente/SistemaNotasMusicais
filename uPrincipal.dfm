object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  Caption = 'TELA PRINCIPAL'
  ClientHeight = 299
  ClientWidth = 656
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  WindowState = wsMaximized
  PixelsPerInch = 96
  TextHeight = 13
  object MainMenu1: TMainMenu
    Left = 464
    Top = 72
    object CADASTRO1: TMenuItem
      Caption = 'CADASTRO'
      object ESCALAMUSICAL1: TMenuItem
        Caption = 'ESCALA MUSICAL'
        OnClick = ESCALAMUSICAL1Click
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object IPOESCALA1: TMenuItem
        Caption = 'TIPO ESCALA'
        OnClick = TIPOESCALA1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object ONALIDADES1: TMenuItem
        Caption = 'TONALIDADES'
        OnClick = ONALIDADES1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object NOTAS1: TMenuItem
        Caption = 'NOTAS'
        OnClick = NOTAS1Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object FECHAR1: TMenuItem
        Caption = 'FECHAR'
        OnClick = FECHAR1Click
      end
    end
    object ARQUIVOS1: TMenuItem
      Caption = 'ARQUIVOS'
      object IMPORTAOEXPORTAO1: TMenuItem
        Caption = 'IMPORTA'#199#195'O / EXPORTA'#199#195'O'
        OnClick = IMPORTAOEXPORTAO1Click
      end
    end
  end
end
