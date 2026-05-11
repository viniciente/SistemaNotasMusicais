unit uDmDados;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef,
  Vcl.Dialogs, System.IniFiles;

type
  TdmDados = class(TDataModule)
    FDConexao: TFDConnection;
    procedure DataModuleCreate(Sender: TObject);
  private
    procedure ConfigurarBancoInicial;
    procedure ConfigurarConexaoDinamicamente;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmDados: TdmDados;

implementation

{$R *.dfm}

procedure TdmDados.ConfigurarConexaoDinamicamente;
var
  LIni: TIniFile;
  CaminhoArquivo: string;
begin
  // Define o caminho: mesma pasta do executável + nome config.ini
  CaminhoArquivo := ExtractFilePath(ParamStr(0)) + 'config.ini';

  LIni := TIniFile.Create(CaminhoArquivo);
  try
    // Se o arquivo NÃO existir, vamos escrever os valores padrão nele
    // Isso forçará o Windows a criar o arquivo .ini fisicamente
    if not FileExists(CaminhoArquivo) then
    begin
      LIni.WriteString('BANCO', 'Servidor', 'DC-TR-06-VM\SERVERCURSO');
      LIni.WriteString('BANCO', 'NomeBanco', 'NotasMusicais');
      LIni.WriteString('BANCO', 'AutenticacaoWindows', 'Yes');
    end;

    // Agora lemos do arquivo (seja o que acabamos de criar ou o que já existia)
    FDConexao.Params.Values['Server']   := LIni.ReadString('BANCO', 'Servidor', 'localhost');
    FDConexao.Params.Values['Database'] := LIni.ReadString('BANCO', 'NomeBanco', 'NotasMusicais');
    FDConexao.Params.Values['OSAuthent'] := LIni.ReadString('BANCO', 'AutenticacaoWindows', 'Yes');

    FDConexao.LoginPrompt := False;
  finally
    LIni.Free;
  end;
end;

procedure TdmDados.ConfigurarBancoInicial;
var
  BancoOriginal: string;
begin
  // 1. Conecta ao servidor (geralmente ao banco 'master' primeiro para criar o seu)
  try
    BancoOriginal := FDConexao.Params.Database;
    FDConexao.Params.Database := 'master';

    FDConexao.LoginPrompt := False;
    FDConexao.Connected := True;

    FDConexao.ExecSQL('IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = ' + QuotedStr(BancoOriginal) + ') ' +
                      'CREATE DATABASE ' + BancoOriginal);

    FDConexao.Connected := False;
    FDConexao.Params.Database := BancoOriginal;
    FDConexao.Connected := True;

    FDConexao.ExecSQL('USE NotasMusicais');

    FDConexao.ExecSQL(
      'IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = ''notas'') ' +
      'CREATE TABLE notas ( ' +
      '  notasId int identity (1,1) primary key, ' +
      '  nome varchar(50) not null unique ' +
      ');'
    );

    FDConexao.ExecSQL(
      'IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = ''tipoEscala'') ' +
      'CREATE TABLE tipoEscala ( ' +
      '  tipoEscalaId int identity (1,1) primary key, ' +
      '  nome Varchar(30) not null unique ' +
      ');'
    );

    FDConexao.ExecSQL(
      'IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = ''tonalidades'') ' +
      'CREATE TABLE tonalidades ( ' +
      '    tonalidadeId int identity (1,1) primary key, ' +
      '    notaId int not null, ' +
      '    nome varchar(50) not null unique, ' +
      '    constraint FK_Tonalidade_Nota foreign key (notaId) references notas(notasId) ' +
      ');'
    );

    FDConexao.ExecSQL(
      'IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = ''escalas'') ' +
      'CREATE TABLE escalas ( ' +
      '    escalaId int identity (1,1) primary key, ' +
      '    nome varchar(100) not null, ' +
      '    tonalidadeId int not null, ' +
      '    tipoId int not null, ' +
      '    listaNota varchar(255) not null, ' +
      '    descricao varchar(500), ' +
      '    constraint FK_Escalas_Tonalidade foreign key (tonalidadeId) references tonalidades(tonalidadeId), ' +
      '    constraint FK_Escalas_TipoEscala foreign key (tipoId) references tipoEscala(tipoEscalaId) ' +
      ');'
    );

    FDConexao.ExecSQL(
      'IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(''escalas'') AND name = ''caminhoArquivo'') ' +
      'BEGIN ' +
      '    ALTER TABLE escalas ADD ' +
      '    caminhoArquivo VARCHAR(500) NULL, ' +
      '    nomeArquivo VARCHAR(255) NULL, ' +
      '    conteudoArquivo VARCHAR(500) NULL; ' +
      'END'
    );


    FDConexao.ExecSQL(
      'IF NOT EXISTS (SELECT TOP 1 1 FROM notas) ' +
      'INSERT INTO notas (nome) VALUES (''Dó''), (''Dó#''), (''Ré''), (''Ré#''), ' +
      '(''Mi''), (''Fá''), (''Fá#''), (''Sol''), (''Sol#''), (''Lá''), (''Lá#''), (''Si'');'
    );

    FDConexao.ExecSQL(
      'IF NOT EXISTS (SELECT TOP 1 1 FROM tipoEscala) ' +
      'INSERT INTO tipoEscala (nome) VALUES (''Maior''), (''Menor Natural''), ' +
      '(''Menor Harmônica''), (''Menor Melódica''), (''Pentatônica Maior''), ' +
      '(''Pentatônica Menor''), (''Blues''), (''Cromática'');'
    );

    FDConexao.ExecSQL(
      'IF NOT EXISTS (SELECT TOP 1 1 FROM tonalidades) ' +
      'INSERT INTO tonalidades (notaId, nome) ' +
      'SELECT notasId, nome + '' Maior'' FROM notas;'
    );

  except
    on E: Exception do
      ShowMessage('Erro ao configurar banco de dados: ' + E.Message);
  end;
end;

procedure TdmDados.DataModuleCreate(Sender: TObject);
begin
  ConfigurarConexaoDinamicamente;
  ConfigurarBancoInicial;
end;

end.
