unit cCadNotas;

interface

uses System.Classes, Vcl.Controls, Vcl.ExtCtrls, Vcl.Dialogs,
     FireDAC.Stan.Intf, FireDAC.Stan.Option,
      FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
      FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
      FireDAC.Phys, FireDAC.VCLUI.Wait, Data.DB,
      FireDAC.Comp.Client, FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef,
      System.SysUtils;
      // lista de Units

type
  TNotas = class
    FDConexao: TFDConnection;
  private
    F_notasId : Integer;
    F_nome : string;
  public
    constructor Create(aConexao:TFDConnection);
    destructor Destroy; override;
    function Inserir:Boolean;
    function Atualizar:Boolean;
    function Apagar:Boolean;
    function Selecionar(id:Integer):Boolean;

  published
    property  codigo       :integer      read F_notasId write F_notasId;
    property  nome         :string       read F_nome   write F_nome;
  end;

implementation

{ TNotas }

constructor TNotas.Create(aConexao: TFDConnection);
begin
  FDConexao := aConexao;
end;

destructor TNotas.Destroy;
begin
  inherited;
end;

function TNotas.Inserir: Boolean;
var
  vQuery: TFDQuery;
begin
  Result := False;
  vQuery := TFDQuery.Create(nil);
  try
    vQuery.Connection := FDConexao;
    vQuery.SQL.Text := 'INSERT INTO notas (nome) VALUES (:nome)';
    vQuery.ParamByName('nome').AsString := F_nome;
    vQuery.ExecSQL;
    Result := True;
  finally
    vQuery.Free;
  end;
end;

function TNotas.Atualizar: Boolean;
var
  vQuery: TFDQuery;
begin
  Result := False;
  vQuery := TFDQuery.Create(nil);
  try
    vQuery.Connection := FDConexao;
    vQuery.SQL.Text := 'UPDATE notas SET nome = :nome WHERE notasId = :id';
    vQuery.ParamByName('nome').AsString := F_nome;
    vQuery.ParamByName('id').AsInteger := F_notasId;
    vQuery.ExecSQL;
    Result := True;
  finally
    vQuery.Free;
  end;
end;

function TNotas.Apagar: Boolean;
var
  vQuery: TFDQuery;
begin
  Result := False;
  vQuery := TFDQuery.Create(nil);
  try
    vQuery.Connection := FDConexao;
    vQuery.SQL.Text := 'DELETE FROM notas WHERE notasId = :id';
    vQuery.ParamByName('id').AsInteger := F_notasId;
    vQuery.ExecSQL;
    Result := True;
  finally
    vQuery.Free;
  end;
end;

function TNotas.Selecionar(id: Integer): Boolean;
var
  vQuery: TFDQuery;
begin
  Result := False;
  vQuery := TFDQuery.Create(nil);
  try
    vQuery.Connection := FDConexao;
    vQuery.SQL.Text := 'SELECT notasId, nome FROM notas WHERE notasId = :id';
    vQuery.ParamByName('id').AsInteger := id;
    vQuery.Open;

    if not vQuery.IsEmpty then
    begin
      F_notasId := vQuery.FieldByName('notasId').AsInteger;
      F_nome    := vQuery.FieldByName('nome').AsString;
      Result    := True;
    end;
  finally
    vQuery.Free;
  end;
end;

end.
