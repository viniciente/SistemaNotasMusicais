unit uCadTonalidades;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, TelaHeranca, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.DBCtrls, cCadTonalidades, uEnum, uDmDados, PngBitBtn;

type
  TfrmCadTonalidades = class(TfrmTelaHeranca)
    edtCodigo: TEdit;
    edtNomeTonalidade: TEdit;
    lblNome: TLabel;
    lblCodigo: TLabel;
    lkpNota: TDBLookupComboBox;
    lblNota: TLabel;
    qryNota: TFDQuery;
    dsNota: TDataSource;
    qryNotanotasId: TFDAutoIncField;
    qryNotanome: TStringField;
    qryPrincipaltonalidadeId: TFDAutoIncField;
    qryPrincipalTonalidade: TStringField;
    qryPrincipalNotaMusical: TStringField;
    procedure FormCreate(Sender: TObject);
    procedure btnAdicionarClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
  private
    { Private declarations }
    oTonalidades:TTonalidades;
    function Apagar: Boolean; override;
    function Gravar(EstadoDoCadastro: TEstadoDoCadastro): Boolean; override;
  public
    { Public declarations }
  end;

var
  frmCadTonalidades: TfrmCadTonalidades;

implementation

{$R *.dfm}

{$REGION 'OVERRIDE'}

function TfrmCadTonalidades.Apagar:Boolean;
begin
  if oTonalidades.Selecionar(qryPrincipal.FieldByName('tonalidadeId').AsInteger)then begin
    Result := oTonalidades.Apagar;
  end;
end;

function TfrmCadTonalidades.Gravar(EstadoDoCadastro: TEstadoDoCadastro): Boolean;
begin
  if Trim(edtNomeTonalidade.Text) = '' then
  begin
    ShowMessage('O Nome é Obrigatorio!');
    Result := False;
    edtNomeTonalidade.SetFocus;
    Exit;
  end;

if VarIsNull(lkpNota.KeyValue) then
  begin
    ShowMessage('A Nota Musical é Obrigatoria!');
    Result := False;
    lkpNota.SetFocus;
    Exit;
  end;

  oTonalidades.nome := edtNomeTonalidade.Text;
  oTonalidades.notaId := lkpNota.KeyValue;

    if EstadoDoCadastro = ecInserir then
    Result := oTonalidades.Inserir
  else if EstadoDoCadastro = ecAlterar then
  begin
    oTonalidades.codigo := qryPrincipal.FieldByName('tonalidadeId').AsInteger;
    Result := oTonalidades.Atualizar;
  end
  else
    Result := False;
end;

{$ENDREGION}

procedure TfrmCadTonalidades.btnAdicionarClick(Sender: TObject);
begin
  inherited;
  edtNomeTonalidade.SetFocus;
end;

procedure TfrmCadTonalidades.btnEditarClick(Sender: TObject);
begin
   if oTonalidades.Selecionar(qryPrincipal.FieldByName('tonalidadeId').AsInteger)then begin
     edtCodigo.Text := IntToStr(oTonalidades.codigo);
     edtNomeTonalidade.Text := oTonalidades.nome;
     lkpNota.KeyValue := oTonalidades.notaId;
   end
   else begin
    btnCancelar.Click;
    Abort;
   end;

   inherited;
end;

procedure TfrmCadTonalidades.FormCreate(Sender: TObject);
begin
  inherited;
  oTonalidades := TTonalidades.Create(DmDados.FDConexao);

  qryPrincipal.Close;
  qryPrincipal.Open;

  qryNota.Close;
  qryNota.Open;
end;

end.
