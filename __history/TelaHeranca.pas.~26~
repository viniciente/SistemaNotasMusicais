unit TelaHeranca;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.DBCtrls,
  Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Mask, Vcl.ComCtrls,
  Vcl.ExtCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  uEnum, uDmDados, RxToolEdit, RxCurrEdit, Vcl.Buttons,
  FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.VCLUI.Wait, System.IniFiles,
  System.IOUtils, Vcl.CheckLst, PngBitBtn;

type
  TfrmTelaHeranca = class(TForm)
    pgcPrincipal: TPageControl;
    tsConsulta: TTabSheet;
    tsDados: TTabSheet;
    pnlTop: TPanel;
    pnlNome: TPanel;
    dbGridConsulta: TDBGrid;
    pnlBottom: TPanel;
    btnFechar: TPngBitBtn;
    btnAdicionar: TPngBitBtn;
    btnEditar: TPngBitBtn;
    btnRemover: TPngBitBtn;
    pnlDadosBottom: TPanel;
    btnSalvar: TPngBitBtn;
    btnCancelar: TPngBitBtn;
    pnlCadastro: TPanel;
    qryPrincipal: TFDQuery;
    dsPrincipal: TDataSource;
    procedure btnAdicionarClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnRemoverClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
  private
    FEstado : TEstadoDoCadastro;
    procedure CentralizarColunas;
    procedure ControlarIndiceTab(pgcPrincipal: TPageControl; Indice: Integer);
    procedure LimparEdits;
  public
    { Public declarations }
    function Apagar: Boolean; virtual;
    function Gravar(EstadoDoCadastro: TEstadoDoCadastro): Boolean; virtual;
  end;

var
  frmTelaHeranca: TfrmTelaHeranca;

implementation

{$R *.dfm}

function TfrmTelaHeranca.Apagar: Boolean;
begin
  Result := False;
end;

function TfrmTelaHeranca.Gravar(EstadoDoCadastro: TEstadoDoCadastro): Boolean;
begin
  Result := False;
end;

procedure TfrmTelaHeranca.btnAdicionarClick(Sender: TObject);
begin
  FEstado := ecInserir;
  pgcPrincipal.ActivePage := tsDados;
end;

procedure TfrmTelaHeranca.btnCancelarClick(Sender: TObject);
begin
  LimparEdits;
  pgcPrincipal.ActivePage := tsConsulta;
end;

procedure TfrmTelaHeranca.btnEditarClick(Sender: TObject);
begin
  if dbGridConsulta.DataSource.DataSet.IsEmpty then Exit;

  if qryPrincipal.Active and (not qryPrincipal.IsEmpty) then
  begin
    qryPrincipal.Edit;

    pgcPrincipal.ActivePage := tsDados;
  end;

  FEstado := ecAlterar;
end;

procedure TfrmTelaHeranca.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmTelaHeranca.btnRemoverClick(Sender: TObject);
begin
  if dbGridConsulta.DataSource.DataSet.IsEmpty then Exit;
  if MessageDlg('Confirma exclusão?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    if Apagar then
    begin
      qryPrincipal.Close;
      qryPrincipal.Open;
      ShowMessage('Registro excluído com sucesso!');
    end;
  end;
end;

procedure TfrmTelaHeranca.btnSalvarClick(Sender: TObject);
begin
    if Gravar(FEstado) then
  begin
    qryPrincipal.Close;
    qryPrincipal.Open;
    ShowMessage('Salvo com sucesso!');
    LimparEdits;
    pgcPrincipal.ActivePage := tsConsulta;
  end;
end;

procedure TfrmTelaHeranca.FormCreate(Sender: TObject);
var i: Integer;
begin
  pgcPrincipal.ActivePage := tsConsulta;

  qryPrincipal.Connection := DmDados.FDConexao;
  dsPrincipal.DataSet  := qryPrincipal;
  dbGridConsulta.DataSource := dsPrincipal;

  dbGridConsulta.Options := [dgTitles, dgIndicator, dgColumnResize,
                             dgColLines, dgRowLines, dgTabs,
                             dgAlwaysShowSelection, dgCancelOnExit,
                             dgTitleClick, dgTitleHotTrack];

  pnlTop.Font.Color := $00FF5EB1;
  pnlBottom.Font.Color := $00FF5EB1;
  pnlCadastro.Font.Color := $00FF5EB1;
  pnlNome.Font.Color := $00FF5EB1;
  pnlDadosBottom.Font.Color := $00FF5EB1;

  for i := 0 to dbGridConsulta.Columns.Count - 1 do
  begin
    dbGridConsulta.Columns[i].Title.Font.Color := $00FF5EB1;
    dbGridConsulta.Columns[i].Title.Font.Style := [fsBold];
  end;
  CentralizarColunas;
end;

procedure TfrmTelaHeranca.CentralizarColunas;
var
  I: Integer;
begin
  for I := 0 to dbGridConsulta.Columns.Count - 1 do
  begin
    // Centraliza o texto das linhas
    dbGridConsulta.Columns[I].Alignment := taCenter;

    // Centraliza o texto do título
    dbGridConsulta.Columns[I].Title.Alignment := taCenter;
  end;
end;

procedure TfrmTelaHeranca.ControlarIndiceTab(pgcPrincipal: TPageControl; Indice: Integer);
begin
  if (pgcPrincipal.Pages[Indice].TabVisible) then
    pgcPrincipal.TabIndex := Indice;
end;

procedure TfrmTelaHeranca.LimparEdits;
var i, j: Integer;
begin
  for i := 0 to ComponentCount - 1 do begin
    if (Components[i] is TLabeledEdit) then
      TLabeledEdit(Components[i]).Text := EmptyStr
    else if (Components[i] is TEdit) then
      TEdit(Components[i]).Text := ''
    else if (Components[i] is TMemo) then
      TMemo(Components[i]).Text := ''
    else if (Components[i] is TDBLookupComboBox) then
      TDBLookupComboBox(Components[i]).KeyValue := null
    else if (Components[i] is TCurrencyEdit) then
      TCurrencyEdit(Components[i]).Value := 0
    else if (Components[i] is TDateEdit) then
      TDateEdit(Components[i]).Date := 0
    else if (Components[i] is TMaskEdit) then
      TMaskEdit(Components[i]).Text := ''
    else if (Components[i] is TCheckListBox) then
    begin
      for j := 0 to TCheckListBox(Components[i]).Items.Count - 1 do
        TCheckListBox(Components[i]).Checked[j] := False;
    end;
  end;
end;

end.
