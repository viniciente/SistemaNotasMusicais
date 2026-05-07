unit cCadEscalaMusical;

interface

uses FireDAC.Comp.Client, System.SysUtils, Data.DB;

type
  TEscalas = class
  private
    F_escalaId: Integer;
    F_nome: string;
    F_tonalidadeId: Integer;
    F_tipoId: Integer;
    F_listaNota: string;
    F_descricao: string;
    F_caminhoArquivo: string;
    F_nomeArquivo: string;
    F_conteudoArquivo: string;
    FDConexao: TFDConnection;
  public
    constructor Create(aConexao: TFDConnection);
    function Inserir: Boolean;
    function Atualizar: Boolean;
    function Apagar: Boolean;
    function Selecionar(id: Integer): Boolean;

    property codigo: Integer read F_escalaId write F_escalaId;
    property nome: string read F_nome write F_nome;
    property tonalidadeId: Integer read F_tonalidadeId write F_tonalidadeId;
    property tipoId: Integer read F_tipoId write F_tipoId;
    property listaNota: string read F_listaNota write F_listaNota;
    property descricao: string read F_descricao write F_descricao;
    property caminhoArquivo: string read F_caminhoArquivo write F_caminhoArquivo;
    property nomeArquivo: string read F_nomeArquivo write F_nomeArquivo;
    property conteudoArquivo: string read F_conteudoArquivo write F_conteudoArquivo;
  end;

implementation

constructor TEscalas.Create(aConexao: TFDConnection);
begin
  FDConexao := aConexao;
end;

function TEscalas.Inserir: Boolean;
var vQuery: TFDQuery;
begin
  vQuery := TFDQuery.Create(nil);
  try
    vQuery.Connection := FDConexao;
    vQuery.SQL.Text :=
      'INSERT INTO escalas (nome, tonalidadeId, tipoId, listaNota, descricao, ' +
      '                     caminhoArquivo, nomeArquivo, conteudoArquivo) ' +
      'VALUES (:nome, :tonalidade, :tipo, :lista, :desc, :caminho, :nomeArq, :conteudo)';
    vQuery.ParamByName('nome').AsString      := F_nome;
    vQuery.ParamByName('tonalidade').AsInteger := F_tonalidadeId;
    vQuery.ParamByName('tipo').AsInteger     := F_tipoId;
    vQuery.ParamByName('lista').AsString     := F_listaNota;
    vQuery.ParamByName('desc').AsString      := F_descricao;
    vQuery.ParamByName('caminho').AsString   := F_caminhoArquivo;
    vQuery.ParamByName('nomeArq').AsString   := F_nomeArquivo;
    vQuery.ParamByName('conteudo').AsString  := F_conteudoArquivo;
    vQuery.ExecSQL;
    Result := True;
  finally
    vQuery.Free;
  end;
end;

function TEscalas.Atualizar: Boolean;
var vQuery: TFDQuery;
begin
  vQuery := TFDQuery.Create(nil);
  try
    vQuery.Connection := FDConexao;
    vQuery.SQL.Text := 'UPDATE escalas SET nome = :nome, tonalidadeId = :tonalidade, ' +
                       'tipoId = :tipo, listaNota = :lista, descricao = :desc ' +
                       'WHERE escalaId = :id';
    vQuery.ParamByName('nome').AsString := F_nome;
    vQuery.ParamByName('tonalidade').AsInteger := F_tonalidadeId;
    vQuery.ParamByName('tipo').AsInteger := F_tipoId;
    vQuery.ParamByName('lista').AsString := F_listaNota;
    vQuery.ParamByName('desc').AsString := F_descricao;
    vQuery.ParamByName('id').AsInteger := F_escalaId;
    vQuery.ExecSQL;
    Result := True;
  finally
    vQuery.Free;
  end;
end;

function TEscalas.Apagar: Boolean;
var vQuery: TFDQuery;
begin
  vQuery := TFDQuery.Create(nil);
  try
    vQuery.Connection := FDConexao;
    vQuery.SQL.Text := 'DELETE FROM escalas WHERE escalaId = :id';
    vQuery.ParamByName('id').AsInteger := F_escalaId;
    vQuery.ExecSQL;
    Result := True;
  finally
    vQuery.Free;
  end;
end;

function TEscalas.Selecionar(id: Integer): Boolean;
var vQuery: TFDQuery;
begin
  Result := False;
  vQuery := TFDQuery.Create(nil);
  try
    vQuery.Connection := FDConexao;
    vQuery.SQL.Text := 'SELECT * FROM escalas WHERE escalaId = :id';
    vQuery.ParamByName('id').AsInteger := id;
    vQuery.Open;
    if not vQuery.IsEmpty then
    begin
      F_escalaId        := vQuery.FieldByName('escalaId').AsInteger;
      F_nome            := vQuery.FieldByName('nome').AsString;
      F_tonalidadeId    := vQuery.FieldByName('tonalidadeId').AsInteger;
      F_tipoId          := vQuery.FieldByName('tipoId').AsInteger;
      F_listaNota       := vQuery.FieldByName('listaNota').AsString;
      F_descricao       := vQuery.FieldByName('descricao').AsString;
      F_caminhoArquivo  := vQuery.FieldByName('caminhoArquivo').AsString;
      F_nomeArquivo     := vQuery.FieldByName('nomeArquivo').AsString;
      Result := True;
    end;
  finally
    vQuery.Free;
  end;
end;

end.
