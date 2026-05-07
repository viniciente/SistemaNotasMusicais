unit cCadTipoEscala;

interface

uses FireDAC.Comp.Client, System.SysUtils, Data.DB;

type
  TTipoEscala = class

  private
    F_tipoEscalaId: Integer;
    F_nome: string;
    FDConexao: TFDConnection;
  public
    constructor Create(aConexao: TFDConnection);
    function Inserir: Boolean;
    function Atualizar: Boolean;
    function Apagar: Boolean;
    function Selecionar(id: Integer): Boolean;

    property codigo: Integer read F_tipoEscalaId write F_tipoEscalaId;
    property nome: string read F_nome write F_nome;
  end;

implementation

constructor TTipoEscala.Create(aConexao: TFDConnection);
begin
  FDConexao := aConexao;
end;

function TTipoEscala.Inserir: Boolean;
var vQuery: TFDQuery;
begin
  vQuery := TFDQuery.Create(nil);
  try
    vQuery.Connection := FDConexao;
    vQuery.SQL.Text := 'INSERT INTO tipoEscala (nome) VALUES (:nome)';
    vQuery.ParamByName('nome').AsString := F_nome;
    vQuery.ExecSQL;
    Result := True;
  finally
    vQuery.Free;
  end;
end;

function TTipoEscala.Atualizar: Boolean;
var vQuery: TFDQuery;
begin
  vQuery := TFDQuery.Create(nil);
  try
    vQuery.Connection := FDConexao;
    vQuery.SQL.Text := 'UPDATE tipoEscala SET nome = :nome WHERE tipoEscalaId = :id';
    vQuery.ParamByName('nome').AsString := F_nome;
    vQuery.ParamByName('id').AsInteger  := F_tipoEscalaId;
    vQuery.ExecSQL;
    Result := True;
  finally
    vQuery.Free;
  end;
end;

function TTipoEscala.Apagar: Boolean;
var vQuery: TFDQuery;
begin
  vQuery := TFDQuery.Create(nil);
  try
    vQuery.Connection := FDConexao;
    vQuery.SQL.Text := 'DELETE FROM tipoEscala WHERE tipoEscalaId = :id';
    vQuery.ParamByName('id').AsInteger := F_tipoEscalaId;
    vQuery.ExecSQL;
    Result := True;
  finally
    vQuery.Free;
  end;
end;

function TTipoEscala.Selecionar(id: Integer): Boolean;
var vQuery: TFDQuery;
begin
  Result := False;
  vQuery := TFDQuery.Create(nil);
  try
    vQuery.Connection := FDConexao;
    vQuery.SQL.Text := 'SELECT * FROM tipoEscala WHERE tipoEscalaId = :id';
    vQuery.ParamByName('id').AsInteger := id;
    vQuery.Open;
    if not vQuery.IsEmpty then
    begin
      F_tipoEscalaId := vQuery.FieldByName('tipoEscalaId').AsInteger;
      F_nome         := vQuery.FieldByName('nome').AsString;
      Result := True;
    end;
  finally
    vQuery.Free;
  end;
end;

end.
