unit TelaHeranca;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Data.DB, Vcl.StdCtrls, Vcl.Buttons, Vcl.Grids, Vcl.DBGrids,
  Vcl.ExtCtrls;

type
  TfrmTelaHeranca = class(TForm)
    pgcPrincipal: TPageControl;
    tsConsulta: TTabSheet;
    tsDados: TTabSheet;
    pnlTop: TPanel;
    pnlNome: TPanel;
    DBGrid1: TDBGrid;
    pnlBottom: TPanel;
    btnFechar: TBitBtn;
    btnAdicionar: TBitBtn;
    btnEditar: TBitBtn;
    btnRemover: TBitBtn;
    pnlDadosBottom: TPanel;
    btnSalvar: TBitBtn;
    btnCancelar: TBitBtn;
    pnlCadastro: TPanel;
    procedure btnAdicionarClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmTelaHeranca: TfrmTelaHeranca;

implementation

{$R *.dfm}

procedure TfrmTelaHeranca.btnAdicionarClick(Sender: TObject);
begin
  pgcPrincipal.ActivePage := tsDados;
end;

procedure TfrmTelaHeranca.btnCancelarClick(Sender: TObject);
begin
  pgcPrincipal.ActivePage := tsConsulta;
end;

procedure TfrmTelaHeranca.btnSalvarClick(Sender: TObject);
begin
  pgcPrincipal.ActivePage := tsConsulta;
end;

end.
