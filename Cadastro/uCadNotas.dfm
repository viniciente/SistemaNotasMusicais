inherited frmCadNotas: TfrmCadNotas
  Caption = 'CADASTRO DE NOTAS'
  ClientWidth = 681
  OnClose = FormClose
  ExplicitWidth = 697
  PixelsPerInch = 96
  TextHeight = 13
  inherited pgcPrincipal: TPageControl
    Width = 681
    ActivePage = tsConsulta
    ExplicitWidth = 681
    inherited tsConsulta: TTabSheet
      ExplicitWidth = 673
      inherited pnlTop: TPanel
        Width = 673
        ExplicitWidth = 673
        inherited pnlNome: TPanel
          Width = 671
          ExplicitWidth = 671
        end
        inherited btnAdicionar: TPngBitBtn
          Left = 361
          ExplicitLeft = 361
        end
        inherited btnRemover: TPngBitBtn
          Left = 474
          ExplicitLeft = 474
        end
        inherited btnEditar: TPngBitBtn
          Left = 568
          ExplicitLeft = 568
        end
      end
      inherited dbGridConsulta: TDBGrid
        Width = 673
        Columns = <
          item
            Expanded = False
            FieldName = 'notasId'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'nome'
            Visible = True
          end>
      end
      inherited pnlBottom: TPanel
        Width = 673
        ExplicitWidth = 673
        inherited btnFechar: TPngBitBtn
          Left = 570
          ExplicitLeft = 570
        end
      end
    end
    inherited tsDados: TTabSheet
      ExplicitWidth = 673
      object lblCodigo: TLabel [0]
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
      object lblNome: TLabel [1]
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
      inherited pnlDadosBottom: TPanel
        Width = 673
        ExplicitWidth = 673
      end
      inherited pnlCadastro: TPanel
        Width = 673
        TabOrder = 3
        ExplicitWidth = 673
      end
      object edtCodigo: TEdit
        Left = 16
        Top = 61
        Width = 121
        Height = 21
        Enabled = False
        TabOrder = 1
      end
      object edtNome: TEdit
        Left = 16
        Top = 110
        Width = 217
        Height = 21
        TabOrder = 2
      end
    end
  end
  inherited qryPrincipal: TFDQuery
    SQL.Strings = (
      'SELECT notasId,'
      '             nome'
      'FROM notas')
    Left = 429
    object qryPrincipalnotasId: TFDAutoIncField
      DisplayLabel = 'Id'
      FieldName = 'notasId'
      Origin = 'notasId'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object qryPrincipalnome: TStringField
      DisplayLabel = 'Nome'
      FieldName = 'nome'
      Origin = 'nome'
      Required = True
      Size = 50
    end
  end
  inherited dsPrincipal: TDataSource
    Left = 536
  end
end
