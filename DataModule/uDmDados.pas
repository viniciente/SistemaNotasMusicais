unit uDmDados;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef,
  Vcl.Dialogs, System.IniFiles, System.UITypes;

type
  TdmDados = class(TDataModule)
    FDConexao: TFDConnection;
    procedure DataModuleCreate(Sender: TObject);
  private
    procedure LerConfigIni;
    procedure CriarBancoETabelas;
  public
    { Public declarations }
  end;

var
  dmDados: TdmDados;

implementation

{$R *.dfm}

procedure TdmDados.LerConfigIni;
const
  TEMPLATE_INI =
    '[BANCO]'                                                                      + sLineBreak +
    '; Endereco do servidor SQL Server.'                                            + sLineBreak +
    '; Exemplos: localhost  |  localhost\SQLEXPRESS  |  192.168.1.10\SQLEXPRESS'   + sLineBreak +
    'Servidor=localhost\SQLEXPRESS'                                                 + sLineBreak +
    ''                                                                             + sLineBreak +
    '; Nome do banco de dados (sera criado automaticamente se nao existir).'       + sLineBreak +
    'NomeBanco=NotasMusicais'                                                      + sLineBreak +
    ''                                                                             + sLineBreak +
    '; Autenticacao do Windows? Yes = sim  |  No = usar usuario e senha abaixo'   + sLineBreak +
    'AutenticacaoWindows=Yes'                                                      + sLineBreak +
    ''                                                                             + sLineBreak +
    '; Preencha apenas se AutenticacaoWindows=No'                                  + sLineBreak +
    'Usuario='                                                                     + sLineBreak +
    'Senha=';

var
  LCaminhoIni : string;
  LIni        : TIniFile;
  LAuthWindows: string;
  LTemplate   : TStringList;
begin
  LCaminhoIni := ExtractFilePath(ParamStr(0)) + 'config.ini';

  // Se o arquivo nao existe: cria o template e avisa o usuario
  if not FileExists(LCaminhoIni) then
  begin
    LTemplate := TStringList.Create;
    try
      LTemplate.Text := TEMPLATE_INI;
      LTemplate.SaveToFile(LCaminhoIni, TEncoding.UTF8);
    finally
      LTemplate.Free;
    end;

    ShowMessage(
      'Arquivo config.ini nao encontrado!' + sLineBreak + sLineBreak +
      'Um arquivo padrao foi criado em:' + sLineBreak +
      LCaminhoIni + sLineBreak + sLineBreak +
      'Por favor:' + sLineBreak +
      '  1. Abra o config.ini com o Bloco de Notas' + sLineBreak +
      '  2. Informe o endereco do seu servidor SQL Server' + sLineBreak +
      '  3. Salve o arquivo' + sLineBreak +
      '  4. Abra o sistema novamente'
    );

    Halt(0); // Encerra para o usuario configurar
  end;

  // Arquivo existe: le as configuracoes
  LIni := TIniFile.Create(LCaminhoIni);
  try
    FDConexao.Params.DriverID            := 'MSSQL';
    FDConexao.LoginPrompt                := False;
    FDConexao.Params.Values['Server']    := LIni.ReadString('BANCO', 'Servidor', 'localhost\SQLEXPRESS');
    FDConexao.Params.Values['Database']  := LIni.ReadString('BANCO', 'NomeBanco', 'NotasMusicais');
    FDConexao.Params.Values['ConnectionTimeout'] := '15';

    LAuthWindows := LIni.ReadString('BANCO', 'AutenticacaoWindows', 'Yes');
    FDConexao.Params.Values['OSAuthent'] := LAuthWindows;

    // Se nao for autenticacao Windows, le usuario e senha
    if not SameText(LAuthWindows, 'Yes') then
    begin
      FDConexao.Params.Values['User_Name'] := LIni.ReadString('BANCO', 'Usuario', '');
      FDConexao.Params.Values['Password']  := LIni.ReadString('BANCO', 'Senha',   '');
    end;
  finally
    LIni.Free;
  end;
end;

procedure TdmDados.CriarBancoETabelas;
var
  LNomeBanco: string;
begin
  LNomeBanco := FDConexao.Params.Values['Database'];

  FDConexao.Params.Values['Database'] := 'master';

  try
    FDConexao.Connected := True;
  except
    on E: Exception do
      raise Exception.CreateFmt(
        'Nao foi possivel conectar ao servidor "%s".' + sLineBreak + sLineBreak +
        'Verifique no config.ini:' + sLineBreak +
        '  - Endereco do servidor (campo Servidor)' + sLineBreak +
        '  - Tipo de autenticacao (AutenticacaoWindows)' + sLineBreak +
        '  - Usuario e Senha (se AutenticacaoWindows=No)' + sLineBreak + sLineBreak +
        'Verifique tambem:' + sLineBreak +
        '  - Se o SQL Server esta rodando' + sLineBreak +
        '  - Se o firewall libera a porta 1433' + sLineBreak +
        '  - Se o SQL Server aceita conexoes remotas' + sLineBreak + sLineBreak +
        'Detalhe tecnico: %s',
        [FDConexao.Params.Values['Server'], E.Message]
      );
  end;

  FDConexao.ExecSQL(
    'IF NOT EXISTS (' +
    '  SELECT * FROM sys.databases WHERE name = ' + QuotedStr(LNomeBanco) +
    ') CREATE DATABASE [' + LNomeBanco + ']'
  );

  FDConexao.Connected := False;
  FDConexao.Params.Values['Database'] := LNomeBanco;
  FDConexao.Connected := True;

  FDConexao.ExecSQL(
    'IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = ''notas'') ' +
    'CREATE TABLE notas ( ' +
    '  notasId int identity(1,1) primary key, ' +
    '  nome varchar(50) not null unique ' +
    ')'
  );

  FDConexao.ExecSQL(
    'IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = ''tipoEscala'') ' +
    'CREATE TABLE tipoEscala ( ' +
    '  tipoEscalaId int identity(1,1) primary key, ' +
    '  nome varchar(30) not null unique ' +
    ')'
  );

  FDConexao.ExecSQL(
    'IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = ''tonalidades'') ' +
    'CREATE TABLE tonalidades ( ' +
    '  tonalidadeId int identity(1,1) primary key, ' +
    '  notaId int not null, ' +
    '  nome varchar(50) not null unique, ' +
    '  constraint FK_Tonalidade_Nota foreign key (notaId) references notas(notasId) ' +
    ')'
  );

  FDConexao.ExecSQL(
    'IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = ''escalas'') ' +
    'CREATE TABLE escalas ( ' +
    '  escalaId int identity(1,1) primary key, ' +
    '  nome varchar(100) not null, ' +
    '  tonalidadeId int not null, ' +
    '  tipoId int not null, ' +
    '  listaNota varchar(255) not null, ' +
    '  descricao varchar(500), ' +
    '  caminhoArquivo varchar(500) null, ' +
    '  nomeArquivo varchar(255) null, ' +
    '  conteudoArquivo varchar(500) null, ' +
    '  constraint FK_Escalas_Tonalidade foreign key (tonalidadeId) references tonalidades(tonalidadeId), ' +
    '  constraint FK_Escalas_TipoEscala foreign key (tipoId) references tipoEscala(tipoEscalaId) ' +
    ')'
  );

  FDConexao.ExecSQL(
    'IF NOT EXISTS (' +
    '  SELECT * FROM sys.columns ' +
    '  WHERE object_id = OBJECT_ID(''escalas'') AND name = ''caminhoArquivo''' +
    ') ' +
    'BEGIN ' +
    '  ALTER TABLE escalas ADD ' +
    '    caminhoArquivo varchar(500) null, ' +
    '    nomeArquivo varchar(255) null, ' +
    '    conteudoArquivo varchar(500) null ' +
    'END'
  );

  FDConexao.ExecSQL(
    'IF NOT EXISTS (SELECT TOP 1 1 FROM notas) ' +
    'INSERT INTO notas (nome) VALUES ' +
    '(''Do''), (''Do#''), (''Re''), (''Re#''), ' +
    '(''Mi''), (''Fa''), (''Fa#''), (''Sol''), ' +
    '(''Sol#''), (''La''), (''La#''), (''Si'')'
  );

  FDConexao.ExecSQL(
    'IF NOT EXISTS (SELECT TOP 1 1 FROM tipoEscala) ' +
    'INSERT INTO tipoEscala (nome) VALUES ' +
    '(''Maior''), (''Menor Natural''), (''Menor Harmonica''), ' +
    '(''Menor Melodica''), (''Pentatonica Maior''), ' +
    '(''Pentatonica Menor''), (''Blues''), (''Cromatica'')'
  );

  FDConexao.ExecSQL(
    'IF NOT EXISTS (SELECT TOP 1 1 FROM tonalidades) ' +
    'INSERT INTO tonalidades (notaId, nome) ' +
    'SELECT notasId, nome + '' Maior'' FROM notas'
  );
end;

procedure TdmDados.DataModuleCreate(Sender: TObject);
begin
  LerConfigIni;

  try
    CriarBancoETabelas;
  except
    on E: Exception do
    begin
      ShowMessage(
        'Erro ao inicializar o banco de dados:' + sLineBreak + sLineBreak +
        E.Message
      );
      Halt(1);
    end;
  end;
end;

end.

