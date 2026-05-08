object frmTelaHeranca: TfrmTelaHeranca
  Left = 0
  Top = 0
  Caption = 'frmTelaHeranca'
  ClientHeight = 376
  ClientWidth = 689
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pgcPrincipal: TPageControl
    Left = 0
    Top = 0
    Width = 689
    Height = 376
    ActivePage = tsDados
    Align = alClient
    TabOrder = 0
    object tsConsulta: TTabSheet
      Caption = 'CONSULTA'
      object pnlTop: TPanel
        Left = 0
        Top = 0
        Width = 681
        Height = 57
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alTop
        TabOrder = 0
        object pnlNome: TPanel
          Left = 1
          Top = 1
          Width = 679
          Height = 24
          Align = alTop
          BevelOuter = bvNone
          Caption = 'CONSULTA'
          Color = 5263440
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 0
        end
        object btnAdicionar: TBitBtn
          Left = 369
          Top = 28
          Width = 107
          Height = 25
          Caption = '&ADICIONAR'
          TabOrder = 1
          OnClick = btnAdicionarClick
        end
        object btnRemover: TBitBtn
          Left = 482
          Top = 28
          Width = 89
          Height = 25
          Caption = '&REMOVER'
          TabOrder = 2
          OnClick = btnRemoverClick
        end
        object btnEditar: TBitBtn
          Left = 577
          Top = 28
          Width = 98
          Height = 25
          Caption = '&EDITAR'
          TabOrder = 3
          OnClick = btnEditarClick
        end
      end
      object dbGridConsulta: TDBGrid
        Left = 0
        Top = 57
        Width = 681
        Height = 250
        Align = alClient
        DataSource = dsPrincipal
        DrawingStyle = gdsClassic
        FixedColor = 5263440
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
      end
      object pnlBottom: TPanel
        Left = 0
        Top = 307
        Width = 681
        Height = 41
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 2
        object btnFechar: TBitBtn
          Left = 577
          Top = 8
          Width = 98
          Height = 25
          Caption = '&FECHAR'
          TabOrder = 0
          OnClick = btnFecharClick
        end
      end
    end
    object tsDados: TTabSheet
      Caption = 'DADOS'
      ImageIndex = 1
      object pnlDadosBottom: TPanel
        Left = 0
        Top = 307
        Width = 681
        Height = 41
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 0
        object btnSalvar: TBitBtn
          Left = 511
          Top = 8
          Width = 75
          Height = 25
          Caption = '&SALVAR'
          TabOrder = 0
          OnClick = btnSalvarClick
        end
        object btnCancelar: TBitBtn
          Left = 592
          Top = 8
          Width = 75
          Height = 25
          Caption = '&CANCELAR'
          TabOrder = 1
          OnClick = btnCancelarClick
        end
      end
      object pnlCadastro: TPanel
        Left = 0
        Top = 0
        Width = 681
        Height = 25
        Align = alTop
        Caption = 'CADASTRO'
        Color = 5263440
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 1
      end
    end
  end
  object qryPrincipal: TFDQuery
    Connection = dmDados.FDConexao
    Left = 613
    Top = 1
  end
  object dsPrincipal: TDataSource
    DataSet = qryPrincipal
    Left = 648
  end
end
