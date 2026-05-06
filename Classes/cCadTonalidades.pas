unit cCadTonalidades;

interface

uses FireDAC.Comp.Client, System.SysUtils, Data.DB;

type
  TTonalidades = class
  private
    F_tonalidadeId: Integer;
    F_notaId: Integer;
    F_nome: string;
    FDConexao: TFDConnection;
  public
    constructor Create(aConexao: TFDConnection);
    function Inserir: Boolean;
    function Atualizar: Boolean;
    function Apagar: Boolean;
    function Selecionar(id: Integer): Boolean;

    property codigo: Integer read F_tonalidadeId write F_tonalidadeId;
    property notaId: Integer read F_notaId write F_notaId;
    property nome: string read F_nome write F_nome;
  end;

implementation

constructor TTonalidades.Create(aConexao: TFDConnection);
begin
  FDConexao := aConexao;
end;

function TTonalidades.Inserir: Boolean;
var vQuery: TFDQuery;
begin
  vQuery := TFDQuery.Create(nil);
  try
    vQuery.Connection := FDConexao;
    vQuery.SQL.Text := 'INSERT INTO tonalidades (notaId, nome) VALUES (:nota, :nome)';
    vQuery.ParamByName('nota').AsInteger := F_notaId;
    vQuery.ParamByName('nome').AsString := F_nome;
    vQuery.ExecSQL;
    Result := True;
  finally
    vQuery.Free;
  end;
end;

function TTonalidades.Atualizar: Boolean;
var vQuery: TFDQuery;
begin
  vQuery := TFDQuery.Create(nil);
  try
    vQuery.Connection := FDConexao;
    vQuery.SQL.Text := 'UPDATE tonalidades SET notaId = :nota, nome = :nome WHERE tonalidadeId = :id';
    vQuery.ParamByName('nota').AsInteger := F_notaId;
    vQuery.ParamByName('nome').AsString := F_nome;
    vQuery.ParamByName('id').AsInteger := F_tonalidadeId;
    vQuery.ExecSQL;
    Result := True;
  finally
    vQuery.Free;
  end;
end;

function TTonalidades.Apagar: Boolean;
var vQuery: TFDQuery;
begin
  vQuery := TFDQuery.Create(nil);
  try
    vQuery.Connection := FDConexao;
    vQuery.SQL.Text := 'DELETE FROM tonalidades WHERE tonalidadeId = :id';
    vQuery.ParamByName('id').AsInteger := F_tonalidadeId;
    vQuery.ExecSQL;
    Result := True;
  finally
    vQuery.Free;
  end;
end;

function TTonalidades.Selecionar(id: Integer): Boolean;
var vQuery: TFDQuery;
begin
  Result := False;
  vQuery := TFDQuery.Create(nil);
  try
    vQuery.Connection := FDConexao;
    vQuery.SQL.Text := 'SELECT * FROM tonalidades WHERE tonalidadeId = :id';
    vQuery.ParamByName('id').AsInteger := id;
    vQuery.Open;
    if not vQuery.IsEmpty then
    begin
      F_tonalidadeId := vQuery.FieldByName('tonalidadeId').AsInteger;
      F_notaId       := vQuery.FieldByName('notaId').AsInteger;
      F_nome         := vQuery.FieldByName('nome').AsString;
      Result := True;
    end;
  finally
    vQuery.Free;
  end;
end;

end.
