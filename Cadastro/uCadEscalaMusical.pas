unit uCadEscalaMusical;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, TelaHeranca, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Grids,
  Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.CheckLst, Vcl.DBCtrls, System.StrUtils,
  cCadEscalaMusical, uEnum, uDmDados, System.IOUtils;

type
  TfrmCadEscalaMusical = class(TfrmTelaHeranca)
    edtCodigo: TEdit;
    edtNome: TEdit;
    lkpTonalidade: TDBLookupComboBox;
    lkpTipoEscala: TDBLookupComboBox;
    edtDescricao: TEdit;
    lblCodigo: TLabel;
    lblNome: TLabel;
    lblTonalidade: TLabel;
    lblTipoEscala: TLabel;
    lblNotas: TLabel;
    clbNotas: TCheckListBox;
    qryNotas: TFDQuery;
    qryTipoEscala: TFDQuery;
    qryTonalidades: TFDQuery;
    qryPrincipalescalaId: TFDAutoIncField;
    qryPrincipalnome: TStringField;
    qryPrincipaltonalidade: TStringField;
    qryPrincipaltipoEscala: TStringField;
    qryPrincipaldescricao: TMemoField;
    btnImportar: TButton;
    edtArquivo: TEdit;
    lblArquivo: TLabel;
    dlgAbrir: TOpenDialog;
    procedure btnEditarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnImportarClick(Sender: TObject);

  private
    oEscala: TEscalas;
    procedure CarregarNotas;
    procedure MarcarNotasSalvas(notasSalvas: string);
    function PegarNotasMarcadas: string;
    function Gravar(EstadoDoCadastro: TEstadoDoCadastro): Boolean; override;
    function Apagar: Boolean; override;
    procedure ImportarArquivoTXT(caminho: string);
  end;

var
  frmCadEscalaMusical: TfrmCadEscalaMusical;

implementation

{$R *.dfm}

procedure TfrmCadEscalaMusical.FormCreate(Sender: TObject);
var i : Integer;
begin
  inherited;
  oEscala := TEscalas.Create(dmDados.FDConexao);
end;

procedure TfrmCadEscalaMusical.FormShow(Sender: TObject);
begin
  qryPrincipal.Close;
  qryPrincipal.Open;
  CarregarNotas;
end;

procedure TfrmCadEscalaMusical.CarregarNotas;
begin
  clbNotas.Items.Clear;

  qryNotas.Close;
  qryNotas.SQL.Text := 'SELECT notasId, nome FROM notas ORDER BY nome';
  qryNotas.Open;

  while not qryNotas.Eof do
  begin
    clbNotas.Items.AddObject(
      qryNotas.FieldByName('nome').AsString,
      TObject(qryNotas.FieldByName('notasId').AsInteger)
    );
    qryNotas.Next;
  end;
end;

procedure TfrmCadEscalaMusical.MarcarNotasSalvas(notasSalvas: string);
var
  i, notaId: Integer;
  ids: TArray<string>;
begin
  ids := notasSalvas.Split([',']);

  for i := 0 to clbNotas.Count - 1 do
  begin
    notaId := Integer(clbNotas.Items.Objects[i]);
    clbNotas.Checked[i] := IndexStr(IntToStr(notaId), ids) >= 0;
  end;
end;

function TfrmCadEscalaMusical.PegarNotasMarcadas: string;
var
  i, notaId: Integer;
begin
  Result := '';
  for i := 0 to clbNotas.Count - 1 do
  begin
    if clbNotas.Checked[i] then
    begin
      notaId := Integer(clbNotas.Items.Objects[i]);
      if Result <> '' then Result := Result + ',';
      Result := Result + IntToStr(notaId);
    end;
  end;
end;

function TfrmCadEscalaMusical.Gravar(EstadoDoCadastro: TEstadoDoCadastro): Boolean;
begin
  Result := False;

  // Validações
  if Trim(edtNome.Text) = '' then
  begin
    ShowMessage('O nome da escala é obrigatório!');
    Exit;
  end;

  if lkpTonalidade.KeyValue = Null then
  begin
    ShowMessage('Selecione uma tonalidade!');
    Exit;
  end;

  if lkpTipoEscala.KeyValue = Null then
  begin
    ShowMessage('Selecione um tipo de escala!');
    Exit;
  end;

  if PegarNotasMarcadas = '' then
  begin
    ShowMessage('Selecione ao menos uma nota!');
    Exit;
  end;

  // Preenche o objeto
  oEscala.nome        := Trim(edtNome.Text);
  oEscala.tonalidadeId := Integer(lkpTonalidade.KeyValue);
  oEscala.tipoId      := Integer(lkpTipoEscala.KeyValue);
  oEscala.listaNota   := PegarNotasMarcadas;
  oEscala.descricao   := Trim(edtDescricao.Text);

  // Insere ou Atualiza
  if EstadoDoCadastro = ecInserir then
    Result := oEscala.Inserir
  else
  begin
    oEscala.codigo := qryPrincipal.FieldByName('escalaId').AsInteger;
    Result := oEscala.Atualizar;
  end;
end;

function TfrmCadEscalaMusical.Apagar: Boolean;
begin
  oEscala.codigo := qryPrincipal.FieldByName('escalaId').AsInteger;
  Result := oEscala.Apagar;
end;



procedure TfrmCadEscalaMusical.btnEditarClick(Sender: TObject);
begin
  if not Assigned(oEscala)then Exit;

  if oEscala.Selecionar(qryPrincipal.FieldByName('escalaId').AsInteger)then begin
    edtCodigo.Text := IntToStr(oEscala.Codigo);
    edtNome.Text          := oEscala.nome;
    edtDescricao.Text     := oEscala.descricao;
    lkpTonalidade.KeyValue := oEscala.tonalidadeId;
    lkpTipoEscala.KeyValue := oEscala.tipoId;
    MarcarNotasSalvas(oEscala.listaNota);
  end
  else begin
    btnCancelar.Click;
    Abort;
  end;

  inherited
end;

procedure TfrmCadEscalaMusical.btnImportarClick(Sender: TObject);
begin
  dlgAbrir.Filter := 'Arquivo de Texto|*.txt';
  dlgAbrir.FileName := '';

  if dlgAbrir.Execute then
  begin
    edtArquivo.Text := dlgAbrir.FileName;
    ImportarArquivoTXT(dlgAbrir.FileName);
  end;
end;

procedure TfrmCadEscalaMusical.ImportarArquivoTXT(caminho: string);
var
  linhas: TStringList;
  partes: TArray<string>;
  sNome, sTipo, sTonalidade, sNotas, sDescricao: string;
  tipoId, tonalidadeId: Integer;
  notasIds: string;
  vQuery: TFDQuery;
  i: Integer;
  notaNome: string;
  destino: string;
  nomeArquivo: string;
begin
  linhas := TStringList.Create;
  try
    linhas.LoadFromFile(caminho, TEncoding.UTF8);

    if linhas.Count = 0 then
    begin
      ShowMessage('Arquivo vazio!');
      Exit;
    end;

    // Lê a primeira linha com conteúdo
    partes := linhas[0].Split(['|']);

    // Valida se tem os 5 campos obrigatórios
    if Length(partes) <> 5 then
    begin
      ShowMessage(
        'Formato inválido! O arquivo deve conter exatamente 5 campos separados por "|".' + #13#10 +
        'Formato esperado: Nome | Tipo Escala | Tonalidade | Notas | Descrição'
      );
      Exit;
    end;

    // Limpa espaços extras de cada campo
    sNome       := Trim(partes[0]);
    sTipo       := Trim(partes[1]);
    sTonalidade := Trim(partes[2]);
    sNotas      := Trim(partes[3]);
    sDescricao  := Trim(partes[4]);

    // Valida campos obrigatórios
    if sNome = '' then begin ShowMessage('Nome da escala não pode ser vazio!'); Exit; end;
    if sTipo = '' then begin ShowMessage('Tipo da escala não pode ser vazio!'); Exit; end;
    if sTonalidade = '' then begin ShowMessage('Tonalidade não pode ser vazia!'); Exit; end;
    if sNotas = '' then begin ShowMessage('Lista de notas não pode ser vazia!'); Exit; end;

    vQuery := TFDQuery.Create(nil);
    try
      vQuery.Connection := dmDados.FDConexao;

      // Busca o ID do tipo de escala pelo nome
      vQuery.Close;
      vQuery.SQL.Text := 'SELECT tipoEscalaId FROM tipoEscala WHERE LOWER(nome) = LOWER(:nome)';
      vQuery.ParamByName('nome').AsString := sTipo;
      vQuery.Open;

      if vQuery.IsEmpty then
      begin
        ShowMessage('Tipo de escala "' + sTipo + '" não encontrado no banco de dados!');
        Exit;
      end;
      tipoId := vQuery.FieldByName('tipoEscalaId').AsInteger;

      // Busca o ID da tonalidade pelo nome
      vQuery.Close;
      vQuery.SQL.Text := 'SELECT tonalidadeId FROM tonalidades WHERE LOWER(nome) = LOWER(:nome)';
      vQuery.ParamByName('nome').AsString := sTonalidade;
      vQuery.Open;

      if vQuery.IsEmpty then
      begin
        ShowMessage('Tonalidade "' + sTonalidade + '" não encontrada no banco de dados!');
        Exit;
      end;
      tonalidadeId := vQuery.FieldByName('tonalidadeId').AsInteger;

      // Verifica duplicidade: mesma escala + mesma tonalidade
      vQuery.Close;
      vQuery.SQL.Text :=
        'SELECT COUNT(*) AS total FROM escalas ' +
        'WHERE LOWER(nome) = LOWER(:nome) AND tonalidadeId = :tonalidade';
      vQuery.ParamByName('nome').AsString := sNome;
      vQuery.ParamByName('tonalidade').AsInteger := tonalidadeId;
      vQuery.Open;

      if vQuery.FieldByName('total').AsInteger > 0 then
      begin
        ShowMessage('Já existe a escala "' + sNome + '" com essa tonalidade cadastrada!');
        Exit;
      end;

      // Busca os IDs de cada nota pelo nome
      notasIds := '';
      for i := 0 to High(sNotas.Split([','])) do
      begin
        notaNome := Trim(sNotas.Split([','])[i]);
        vQuery.Close;
        vQuery.SQL.Text := 'SELECT notasId FROM notas WHERE LOWER(nome) = LOWER(:nome)';
        vQuery.ParamByName('nome').AsString := notaNome;
        vQuery.Open;

        if vQuery.IsEmpty then
        begin
          ShowMessage('Nota "' + notaNome + '" não encontrada no banco de dados!');
          Exit;
        end;

        if notasIds <> '' then notasIds := notasIds + ',';
        notasIds := notasIds + vQuery.FieldByName('notasId').AsString;
      end;

      // Tudo validado — salva no banco
      oEscala.nome         := sNome;
      oEscala.tipoId       := tipoId;
      oEscala.tonalidadeId := tonalidadeId;
      oEscala.listaNota    := notasIds;
      oEscala.descricao    := sDescricao;

      if oEscala.Inserir then
      begin
        // Copia o arquivo para a pasta do sistema
        destino := ExtractFilePath(Application.ExeName) + 'Importacoes\';
        if not DirectoryExists(destino) then
          CreateDir(destino);

        nomeArquivo := destino + FormatDateTime('yyyymmdd_hhmmss', Now) + '_' + ExtractFileName(caminho);
        TFile.Copy(caminho, nomeArquivo, True);

        // Atualiza o grid
        qryPrincipal.Close;
        qryPrincipal.Open;

        ShowMessage('Escala importada e salva com sucesso!' + #13#10 + 'Arquivo salvo em: ' + nomeArquivo);
      end;

    finally
      vQuery.Free;
    end;

  finally
    linhas.Free;
  end;
end;

end.
