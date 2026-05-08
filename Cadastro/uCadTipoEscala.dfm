inherited frmCadTipoEscala: TfrmCadTipoEscala
  Caption = 'CADASTRO DE TIPO ESCALAS'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pgcPrincipal: TPageControl
    inherited tsConsulta: TTabSheet
      inherited dbGridConsulta: TDBGrid
        Columns = <
          item
            Expanded = False
            FieldName = 'tipoEscalaId'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'nome'
            Visible = True
          end>
      end
    end
    inherited tsDados: TTabSheet
      object lblNome: TLabel [0]
        Left = 16
        Top = 93
        Width = 35
        Height = 16
        Caption = 'Nome'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblCodigo: TLabel [1]
        Left = 16
        Top = 44
        Width = 43
        Height = 16
        Caption = 'Codigo'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object edtNome: TEdit
        Left = 16
        Top = 110
        Width = 217
        Height = 21
        TabOrder = 2
      end
      object edtCodigo: TEdit
        Left = 16
        Top = 61
        Width = 121
        Height = 21
        Enabled = False
        TabOrder = 3
      end
    end
  end
  inherited qryPrincipal: TFDQuery
    SQL.Strings = (
      'SELECT tipoEscalaId,'
      '       nome'
      'FROM tipoEscala'
      'ORDER BY nome')
    object qryPrincipaltipoEscalaId: TFDAutoIncField
      DisplayLabel = 'Id'
      FieldName = 'tipoEscalaId'
      Origin = 'tipoEscalaId'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object qryPrincipalnome: TStringField
      DisplayLabel = 'Nome'
      FieldName = 'nome'
      Origin = 'nome'
      Required = True
      Size = 30
    end
  end
end
