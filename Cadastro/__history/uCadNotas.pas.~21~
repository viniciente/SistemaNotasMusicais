unit uCadNotas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, TelaHeranca, Data.DB, Vcl.Grids,
  Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons,Vcl.ExtCtrls, Vcl.ComCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  cCadNotas, uEnum, uDmDados, PngBitBtn;

type
  TfrmCadNotas = class(TfrmTelaHeranca)
    lblCodigo: TLabel;
    lblNome: TLabel;
    edtCodigo: TEdit;
    edtNome: TEdit;
    qryPrincipalnotasId: TFDAutoIncField;
    qryPrincipalnome: TStringField;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnEditarClick(Sender: TObject);
    procedure btnAdicionarClick(Sender: TObject);
  private
    { Private declarations }
    oNotas:TNotas;
    function Apagar: Boolean; override;
    function Gravar(EstadoDoCadastro:TEstadoDoCadastro):Boolean; override;
  public
    { Public declarations }
  end;

var
  frmCadNotas: TfrmCadNotas;

implementation

{$R *.dfm}

{$REGION'OVERRIDE'}
function TfrmCadNotas.Apagar: Boolean;
begin
  if oNotas.Selecionar(qryPrincipal.FieldByName('notasId').AsInteger)then begin
     Result:=oNotas.Apagar;
  end;
end;

function TfrmCadNotas.Gravar(EstadoDoCadastro: TEstadoDoCadastro): Boolean;
begin
  if Trim(edtNome.Text) = '' then
  begin
    ShowMessage('O nome é obrigatório!');
    Result := False;
    Exit;
  end;

  oNotas.nome := edtNome.Text;

  if EstadoDoCadastro = ecInserir then
    Result := oNotas.Inserir
  else if EstadoDoCadastro = ecAlterar then
  begin
    oNotas.codigo := qryPrincipal.FieldByName('notasId').AsInteger;
    Result := oNotas.Atualizar;
  end
  else
    Result := False;
end;
{$ENDREGION}

procedure TfrmCadNotas.btnAdicionarClick(Sender: TObject);
begin
  inherited;
  edtNome.SetFocus;
end;

procedure TfrmCadNotas.btnEditarClick(Sender: TObject);
begin
  if not Assigned(oNotas) then Exit;

  if oNotas.Selecionar(qryPrincipal.FieldByName('notasId').AsInteger)then begin
    edtCodigo.Text := IntToStr(oNotas.codigo);
    edtNome.Text := oNotas.nome;
  end
  else begin
    btnCancelar.Click;
    Abort;
  end;

  inherited;
end;

procedure TfrmCadNotas.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  if Assigned(oNotas)then
    FreeAndNil(oNotas);
end;

procedure TfrmCadNotas.FormCreate(Sender: TObject);
begin
  inherited;

  oNotas := TNotas.Create(dmDados.FDConexao);
end;


end.
