unit uArquivos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, Vcl.Buttons, Vcl.Grids, Vcl.DBGrids,
  Vcl.ExtCtrls, Vcl.ComCtrls, uDmDados, Vcl.Mask, uEnum, RxToolEdit, RxCurrEdit, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.VCLUI.Wait, System.IniFiles,
  System.IOUtils, Vcl.CheckLst, Vcl.DBCtrls;

type
  TfrmArquivos = class(TForm)
    pgcPrincipal: TPageControl;
    tsConsulta: TTabSheet;
    pnlTop: TPanel;
    pnlNome: TPanel;
    dbGridConsulta: TDBGrid;
    pnlBottom: TPanel;
    btnFechar: TBitBtn;
    tsDados: TTabSheet;
    pnlDadosBottom: TPanel;
    btnSalvar: TBitBtn;
    btnCancelar: TBitBtn;
    pnlCadastro: TPanel;
    qryArquivos: TFDQuery;
    dsArquivos: TDataSource;
    btnExportar: TBitBtn;
    btnImportar: TBitBtn;
    dlgSalvar: TSaveDialog;
    qryArquivosescalaId: TFDAutoIncField;
    qryArquivosnome: TStringField;
    qryArquivostonalidade: TStringField;
    qryArquivostipoEscala: TStringField;
    qryArquivoslistaNota: TStringField;
    qryArquivosdescricao: TStringField;
    qryArquivoscaminhoArquivo: TStringField;
    qryArquivosnomeArquivo: TStringField;
    qryArquivosconteudoArquivo: TStringField;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnExportarClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
  private
    procedure CarregarDados;
    function ObterNomesNotas(listaNota: string): string;
    procedure LimparEdits;
    procedure CentralizarColunas;
  public
    { Public declarations }
  end;

var
  frmArquivos: TfrmArquivos;

implementation

{$R *.dfm}


procedure TfrmArquivos.FormCreate(Sender: TObject);
  var i: Integer;
begin
  qryArquivos.Connection := dmDados.FDConexao;
  pgcPrincipal.ActivePage := tsConsulta;

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

procedure TfrmArquivos.CentralizarColunas;
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

procedure TfrmArquivos.FormShow(Sender: TObject);
begin
  CarregarDados;
end;

procedure TfrmArquivos.CarregarDados;
begin
  qryArquivos.Close;
  qryArquivos.Open;
end;

function TfrmArquivos.ObterNomesNotas(listaNota: string): string;
// Converte a string de IDs separados por v rgula em nomes das notas
// Ex: "1,3,5" -> "D , R , Mi"
var
  vQuery: TFDQuery;
  ids: TArray<string>;
  i: Integer;
  nomeNota: string;
begin
  Result := '';
  if Trim(listaNota) = '' then Exit;

  ids := listaNota.Split([',']);
  vQuery := TFDQuery.Create(nil);
  try
    vQuery.Connection := dmDados.FDConexao;
    for i := 0 to High(ids) do
    begin
      if Trim(ids[i]) = '' then Continue;
      vQuery.Close;
      vQuery.SQL.Text := 'SELECT nome FROM notas WHERE notasId = :id';
      vQuery.ParamByName('id').AsInteger := StrToIntDef(Trim(ids[i]), 0);
      vQuery.Open;
      if not vQuery.IsEmpty then
      begin
        nomeNota := vQuery.FieldByName('nome').AsString;
        if Result <> '' then Result := Result + ', ';
        Result := Result + nomeNota;
      end;
    end;
  finally
    vQuery.Free;
  end;
end;

procedure TfrmArquivos.btnCancelarClick(Sender: TObject);
begin
  LimparEdits;
end;

procedure TfrmArquivos.btnExportarClick(Sender: TObject);
var
  linhas: TStringList;
  nomeEscala, tipoEscala, tonalidade, notasIds, nomesNotas, descricao: string;
  linha: string;
  posicaoAtual: TBookmark;
begin
  if qryArquivos.IsEmpty then
  begin
    ShowMessage('Não a dados para exportar!');
    Exit;
  end;

  // Configura o di logo de salvar
  dlgSalvar.Title      := 'Exportar escalas para TXT';
  dlgSalvar.Filter     := 'Arquivo de Texto|*.txt';
  dlgSalvar.DefaultExt := 'txt';
  dlgSalvar.FileName   := 'EscalasMusicais_' + FormatDateTime('YYYYMMDD_HHmmss', Now);

  if not dlgSalvar.Execute then Exit;

  linhas := TStringList.Create;
  try
    // Salva a posi  o atual do cursor no grid
    posicaoAtual := qryArquivos.GetBookmark;
    try
      qryArquivos.DisableControls;
      qryArquivos.First;

      while not qryArquivos.Eof do
      begin
        nomeEscala  := qryArquivos.FieldByName('nome').AsString;
        tipoEscala  := qryArquivos.FieldByName('tipoEscala').AsString;
        tonalidade  := qryArquivos.FieldByName('tonalidade').AsString;
        notasIds    := qryArquivos.FieldByName('listaNota').AsString;
        descricao   := qryArquivos.FieldByName('descricao').AsString;

        // Converte IDs das notas para nomes
        nomesNotas := ObterNomesNotas(notasIds);

        // Monta a linha no formato: Nome | Tipo | Tonalidade | Notas | Descri  o
        linha := nomeEscala  + ' | ' +
                 tipoEscala  + ' | ' +
                 tonalidade  + ' | ' +
                 nomesNotas  + ' | ' +
                 descricao;

        linhas.Add(linha);
        qryArquivos.Next;
      end;

    finally
      // Restaura a posi  o e habilita controles
      qryArquivos.GotoBookmark(posicaoAtual);
      qryArquivos.FreeBookmark(posicaoAtual);
      qryArquivos.EnableControls;
    end;

    // Grava o arquivo em UTF-8
    linhas.SaveToFile(dlgSalvar.FileName, TEncoding.UTF8);

    ShowMessage(
      'Exportação concluida com sucesso!' + sLineBreak +
      IntToStr(linhas.Count) + ' escala(s) exportada(s).' + sLineBreak +
      'Arquivo: ' + dlgSalvar.FileName
    );

  finally
    linhas.Free;
  end;
end;

procedure TfrmArquivos.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmArquivos.btnSalvarClick(Sender: TObject);
begin
  LimparEdits;
end;

procedure TfrmArquivos.LimparEdits;
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

