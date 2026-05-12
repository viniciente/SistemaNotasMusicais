# Sistema de Notas Musicais

## 🎵 Objetivo

Sistema de gestão de escalas musicais com suporte completo para entrada e saída de dados em arquivos TXT. Este projeto implementa um desafio de processamento de dados musicais, permitindo catalogação, importação e exportação de escalas musicais com validação completa.

**Desafio:** Sistema de Notas Musicais | **Entrada:** TXT | **Saída:** TXT

### Funcionalidades Principais

- 📊 **Cadastro de Escalas Musicais** - Registre novas escalas com notas e tonalidades
- 🎼 **Gestão de Tonalidades** - Catalogação de tonalidades musicais
- 🎹 **Gestão de Notas** - Controle de notas musicais disponíveis
- 📁 **Importação de Dados** - Leia escalas de arquivos TXT
- 💾 **Exportação de Dados** - Salve escalas em formato TXT
- 🔍 **Consulta de Escalas** - Visualize todas as escalas cadastradas
- ⚙️ **Persistência de Configuração** - Memorize preferências de layout das grids

---

## 🛠️ Tecnologias Utilizadas

| Tecnologia | Versão | Função |
|-----------|--------|--------|
| **Delphi/Pascal** | - | Linguagem de programação |
| **FireDAC** | - | Acesso a banco de dados com suporte multi-plataforma |
| **SQL Server** | - | Persistência de dados de escalas e referências |
| **VCL (Visual Component Library)** | - | Framework de componentes visuais |
| **Git** | - | Controle de versão |

### Bibliotecas Utilizadas

- `Winapi.*` - APIs do Windows
- `System.*` - Classes do sistema Pascal
- `Vcl.*` - Componentes visuais (Grids, Forms, Dialogs)
- `Data.DB` - Acesso a dados
- `FireDAC.*` - Camada de acesso a banco de dados
- `System.IniFiles` - Persistência de configurações

---

## 🚀 Como Executar

### Pré-requisitos

- **Delphi** instalado (versão 10.0 ou superior recomendada)
- **SQL Server** configurado e acessível
- Arquivo `Project2.dproj` (projeto Delphi)
- Arquivo de configuração `config.ini` (gerado automaticamente na primeira execução)

### Passos para Execução

#### 1️⃣ **Abra o projeto no Delphi**

```bash
delphi Project2.dproj
```

#### 2️⃣ **Inicialização da Conexão com o Banco de Dados**

Quando o aplicativo é iniciado, o **DataModule** (`uDmDados.pas`) executa automaticamente dois procedimentos essenciais:

**A. `ConfigurarConexaoDinamicamente` (executado primeiro)**

Este procedimento configura dinamicamente os parâmetros de conexão:

```pascal
procedure TdmDados.ConfigurarConexaoDinamicamente;
var
  LIni: TIniFile;
  CaminhoArquivo: string;
begin
  // 1. Define o caminho do arquivo config.ini (mesma pasta do executável)
  CaminhoArquivo := ExtractFilePath(ParamStr(0)) + 'config.ini';
  
  LIni := TIniFile.Create(CaminhoArquivo);
  try
    // 2. Se o arquivo NÃO existe, cria com valores padrão
    if not FileExists(CaminhoArquivo) then
    begin
      LIni.WriteString('BANCO', 'Servidor', 'DC-TR-06-VM\SERVERCURSO');
      LIni.WriteString('BANCO', 'NomeBanco', 'NotasMusicais');
      LIni.WriteString('BANCO', 'AutenticacaoWindows', 'Yes');
    end;
    
    // 3. Lê os parâmetros do arquivo config.ini
    FDConexao.Params.Values['Server']   := LIni.ReadString('BANCO', 'Servidor', 'localhost');
    FDConexao.Params.Values['Database'] := LIni.ReadString('BANCO', 'NomeBanco', 'NotasMusicais');
    FDConexao.Params.Values['OSAuthent'] := LIni.ReadString('BANCO', 'AutenticacaoWindows', 'Yes');
    
    FDConexao.LoginPrompt := False;
  finally
    LIni.Free;
  end;
end;
```

**O que este procedimento faz:**
- ✅ Busca o arquivo `config.ini` na pasta do executável
- ✅ Se não existir, cria um com valores padrão
- ✅ Lê servidor, banco de dados e tipo de autenticação do `config.ini`
- ✅ Configura a conexão FireDAC dinamicamente

**Arquivo `config.ini` (gerado automaticamente):**
```ini
[BANCO]
Servidor=DC-TR-06-VM\SERVERCURSO
NomeBanco=NotasMusicais
AutenticacaoWindows=Yes
```

**Para alterar servidor ou banco, edite este arquivo.**

---

**B. `ConfigurarBancoInicial` (executado logo após)**

Este procedimento prepara o banco de dados:

```pascal
procedure TdmDados.ConfigurarBancoInicial;
var
  BancoOriginal: string;
begin
  try
    BancoOriginal := FDConexao.Params.Database;
    
    // 1. Conecta ao banco 'master' temporariamente
    FDConexao.Params.Database := 'master';
    FDConexao.Connected := True;
    
    // 2. Cria o banco NotasMusicais se não existir
    FDConexao.ExecSQL('IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = ' + 
                      QuotedStr(BancoOriginal) + ') CREATE DATABASE ' + BancoOriginal);
    
    // 3. Desconecta e reconecta no banco correto
    FDConexao.Connected := False;
    FDConexao.Params.Database := BancoOriginal;
    FDConexao.Connected := True;
    
    // 4. Cria as tabelas se não existirem:
    
    // Tabela: NOTAS (12 notas musicais)
    FDConexao.ExecSQL('IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = ''notas'') 
      CREATE TABLE notas (
        notasId int identity (1,1) primary key,
        nome varchar(50) not null unique
      );');
    
    // Tabela: TIPOESCALA (tipos de escalas disponíveis)
    FDConexao.ExecSQL('IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = ''tipoEscala'')
      CREATE TABLE tipoEscala (
        tipoEscalaId int identity (1,1) primary key,
        nome Varchar(30) not null unique
      );');
    
    // Tabela: TONALIDADES (tonalidades de cada nota)
    FDConexao.ExecSQL('IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = ''tonalidades'')
      CREATE TABLE tonalidades (
        tonalidadeId int identity (1,1) primary key,
        notaId int not null,
        nome varchar(50) not null unique,
        constraint FK_Tonalidade_Nota foreign key (notaId) references notas(notasId)
      );');
    
    // Tabela: ESCALAS (escalas musicais cadastradas)
    FDConexao.ExecSQL('IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = ''escalas'')
      CREATE TABLE escalas (
        escalaId int identity (1,1) primary key,
        nome varchar(100) not null,
        tonalidadeId int not null,
        tipoId int not null,
        listaNota varchar(255) not null,
        descricao varchar(500),
        constraint FK_Escalas_Tonalidade foreign key (tonalidadeId) references tonalidades(tonalidadeId),
        constraint FK_Escalas_TipoEscala foreign key (tipoId) references tipoEscala(tipoEscalaId)
      );');
    
    // 5. Insere dados iniciais (notas, tipos, tonalidades)
    
    // 12 notas chromáticas
    FDConexao.ExecSQL('IF NOT EXISTS (SELECT TOP 1 1 FROM notas)
      INSERT INTO notas (nome) VALUES 
        (''Dó''), (''Dó#''), (''Ré''), (''Ré#''), (''Mi''), (''Fá''), 
        (''Fá#''), (''Sol''), (''Sol#''), (''Lá''), (''Lá#''), (''Si'');');
    
    // 8 tipos de escalas
    FDConexao.ExecSQL('IF NOT EXISTS (SELECT TOP 1 1 FROM tipoEscala)
      INSERT INTO tipoEscala (nome) VALUES 
        (''Maior''), (''Menor Natural''), (''Menor Harmônica''), (''Menor Melódica''),
        (''Pentatônica Maior''), (''Pentatônica Menor''), (''Blues''), (''Cromática'');');
    
    // Tonalidades de cada nota
    FDConexao.ExecSQL('IF NOT EXISTS (SELECT TOP 1 1 FROM tonalidades)
      INSERT INTO tonalidades (notaId, nome) SELECT notasId, nome + '' Maior'' FROM notas;');
    
  except
    on E: Exception do
      ShowMessage('Erro ao configurar banco de dados: ' + E.Message);
  end;
end;
```

**O que este procedimento faz:**
- ✅ Cria o banco de dados `NotasMusicais` se não existir
- ✅ Cria 4 tabelas essenciais: `notas`, `tipoEscala`, `tonalidades`, `escalas`
- ✅ Insere dados iniciais (12 notas musicais, 8 tipos de escalas)
- ✅ Configura chaves estrangeiras para integridade referencial

**Estrutura de tabelas criadas:**

| Tabela | Colunas | Função |
|--------|---------|--------|
| `notas` | notasId, nome | Armazena as 12 notas cromáticas (Dó, Ré, Mi...) |
| `tipoEscala` | tipoEscalaId, nome | Tipos de escalas (Maior, Menor, Pentatônica, Blues, etc.) |
| `tonalidades` | tonalidadeId, notaId, nome | Tonalidades musicais (associadas a cada nota) |
| `escalas` | escalaId, nome, tonalidadeId, tipoId, listaNota, descricao | Escalas cadastradas pelo usuário |

---

#### 3️⃣ **Compile o projeto**

No Delphi:

```bash
Ctrl + Shift + F9  # Build All
```

Ou via menu:
```
Menu → Project → Build Project
```

#### 4️⃣ **Execute o aplicativo**

```bash
F9  # Run
```

Ou clique no botão **Run** (▶) na toolbar do Delphi.

**Na primeira execução:**
- ✅ O arquivo `config.ini` será criado na pasta do executável
- ✅ O banco de dados `NotasMusicais` será criado no SQL Server
- ✅ As 4 tabelas serão criadas automaticamente
- ✅ Dados iniciais serão inseridos

#### 5️⃣ **Popule o banco com mais dados (Opcional)**

Se desejado, crie tonalidades e tipos adicionais:

- Acesse **Cadastro → Notas** para visualizar/criar notas musicais
- Acesse **Cadastro → Tonalidades** para adicionar tonalidades
- Acesse **Cadastro → Tipo Escala** para definir novos tipos
- Acesse **Arquivos → Importar/Exportar** para carregar escalas de arquivo TXT

---

## 📥 📤 Como Importar/Exportar Dados

### Padrão de Arquivo TXT para Importação

O sistema utiliza um formato **simples e estruturado** baseado em delimitadores (`|`).

#### Formato da Linha

```
Nome | Tipo | Tonalidade | Notas | Descricao
```

#### Especificação de Campos

| Campo | Tipo | Tamanho | Obrigatório | Descrição |
|-------|------|---------|-------------|-----------|
| **Nome** | String | 100 | ✅ Sim | Nome da escala musical (ex: "Escala Diatônica") |
| **Tipo** | String | 50 | ✅ Sim | Tipo de escala (ex: "Maior", "Menor", "Pentatônica") |
| **Tonalidade** | String | 50 | ✅ Sim | Tonalidade base (ex: "Dó", "Ré", "Mi") |
| **Notas** | String | 255 | ✅ Sim | Notas separadas por vírgula (ex: "Dó, Ré, Mi, Fá, Sol") |
| **Descricao** | String | 500 | ❌ Não | Descrição opcional da escala |

#### Exemplos de Arquivo Válido

```txt
Escala Maior em Dó | Maior | Dó | Dó, Ré, Mi, Fá, Sol, Lá, Si | Escala diatônica maior
Escala Menor em Lá | Menor Natural | Lá | Lá, Si, Dó, Ré, Mi, Fá, Sol | Escala relativa menor
Pentatônica Maior | Pentatônica Maior | Sol | Sol, Lá, Si, Ré, Mi | Escala pentatônica sem 4ª e 7ª
```

### ✅ Validações Realizadas

O sistema valida cada linha durante a importação:

1. **Formato**: Exatamente 5 campos separados por `|`
2. **Campos Obrigatórios**: Nome, Tipo, Tonalidade e Notas não podem ser vazios
3. **Existência no Banco**: 
   - Tipo deve existir na tabela `tipoEscala`
   - Tonalidade deve existir na tabela `tonalidades`
   - Cada nota deve existir na tabela `notas`
4. **Duplicidade**: Não permite duas escalas com mesmo nome e tonalidade
5. **Encoding**: Arquivo deve estar em **UTF-8**

### Processo de Importação Passo a Passo

1. **Acesse a Importação:**
   - Menu: **Arquivos → Importar/Exportar**
   - Ou clique no botão **"Importar"** na tela principal

2. **Selecione o arquivo TXT:**
   - O sistema abre um diálogo de seleção de arquivos
   - Escolha um arquivo com extensão `.txt` no padrão especificado

3. **Visualize o preview:**
   - As linhas aparecem na grid com status: **OK** ou **ERRO**
   - Coluna "Erro" mostra o motivo da falha (se houver)

4. **Revise os dados:**
   - Analise a coluna de status antes de salvar
   - Se houver linhas com ERRO, corrija no arquivo TXT original
   - Reimporte o arquivo corrigido

5. **Salve as escalas:**
   - Clique em **"Salvar"** para inserir no banco de dados
   - Apenas linhas com status OK serão salvas
   - Um relatório final mostrará: Salvos ✅ e Erros ❌

### Processo de Exportação Passo a Passo

1. **Acesse a Exportação:**
   - Menu: **Arquivos → Importar/Exportar**
   - Clique na aba **"Consulta"**
   - Clique em **"Exportar"**

2. **Escolha o local e nome:**
   - Um diálogo de salvar arquivo aparece
   - Nome sugerido: `EscalasMusicais_YYYYMMDD_HHmmss.txt`
   - Selecione pasta de destino

3. **Confirmação:**
   - Arquivo é salvo em **UTF-8**
   - Mensagem mostra quantidade de escalas exportadas
   - Caminho completo do arquivo é exibido

4. **Arquivo Gerado:**
   - Contém todas as escalas cadastradas no banco
   - Segue o mesmo padrão de importação
   - Pode ser reimportado em outro banco sem problemas

### 📋 Exemplo de Fluxo Completo

**Arquivo de entrada:** `escalas_entrada.txt`
```txt
Escala Maior em Dó | Maior | Dó Maior | Dó, Ré, Mi, Fá, Sol, Lá, Si | Fundamental
Escala Menor Harmônica | Menor Harmônica | Lá Maior | Lá, Si, Dó, Ré, Mi, Fá, Sol# | Com 7ª aumentada
Modo Dórico | Menor Natural | Ré Maior | Ré, Mi, Fá, Sol, Lá, Si, Dó | Segundo modo
```

**Arquivo de saída após exportação:** `EscalasMusicais_20260512_173000.txt`
```txt
Escala Maior em Dó | Maior | Dó Maior | Dó, Ré, Mi, Fá, Sol, Lá, Si | Fundamental
Escala Menor Harmônica | Menor Harmônica | Lá Maior | Lá, Si, Dó, Ré, Mi, Fá, Sol# | Com 7ª aumentada
Modo Dórico | Menor Natural | Ré Maior | Ré, Mi, Fá, Sol, Lá, Si, Dó | Segundo modo
```

---

## 🏗️ Decisões Técnicas

### 1. **Arquitetura e Padrão de Projeto**

#### MVC Parcial com Separação de Responsabilidades
- **Model**: Classes em `Classes/` (ex: `cCadEscalaMusical.pas` - TEscalas)
- **View**: Componentes Delphi `.dfm` (interfaces visuais)
- **Controller**: Units `uArquivos.pas`, `uPrincipal.pas` (lógica de negócio)

**Justificativa:** Facilita manutenção, testes e reutilização de código. A classe `TEscalas` encapsula toda a lógica de persistência.

### 2. **Separação de Camadas**

```
┌─────────────────────────────────────────┐
│   Apresentação (VCL Forms)              │
│   uPrincipal, uArquivos, etc            │
├─────────────────────────────────────────┤
│   Lógica de Negócio (Classes)           │
│   TEscalas, TNota, TTonalidade          │
├─────────────────────────────────────────┤
│   Acesso a Dados (FireDAC)              │
│   uDmDados (DataModule)                 │
├─────────────────────────────────────────┤
│   Banco de Dados                        │
│   SQL Server                            │
└─────────────────────────────────────────┘
```

### 3. **Tratamento de Importação/Exportação**

#### Formato de Arquivo: Delimitador Simples (`|`)

**Vantagens:**
- ✅ Legível por humanos
- ✅ Compatível com Excel/LibreOffice
- ✅ Sem dependência de bibliotecas externas
- ✅ Encoding UTF-8 universal

**Alternativas Consideradas (mas rejeitadas):**
- ❌ **JSON**: Mais complexo, maior overhead para dados simples
- ❌ **XML**: Verboso, difícil leitura manual
- ❌ **CSV**: Problemático com dados contendo vírgulas nas notas

#### Validação em Duas Fases

1. **Fase 1 - Formatação:**
   - Verifica 5 campos separados por `|`
   - Detecta campos vazios obrigatórios
   - Status: OK ou ERRO (formatação)

2. **Fase 2 - Negócio:**
   - Busca IDs no banco (Tipo, Tonalidade, Notas)
   - Valida duplicidade de escalas
   - Insere com transaction implícita
   - Status: ERRO (validação) ou SALVO (sucesso)

**Justificativa:** Permite feedback claro ao usuário, possibilita correção de erros antes da persistência.

### 4. **Armazenamento de Escalas**

#### Estrutura de Dados - Tabela `escalas`

```sql
CREATE TABLE escalas (
  escalaId        INTEGER PRIMARY KEY AUTOINCREMENT,
  nome            VARCHAR(100) NOT NULL,
  tonalidadeId    INTEGER NOT NULL FOREIGN KEY,
  tipoId          INTEGER NOT NULL FOREIGN KEY,
  listaNota       VARCHAR(255) NOT NULL,  -- IDs separadas por vírgula (ex: "1,3,5,7")
  descricao       VARCHAR(500),
  FOREIGN KEY (tonalidadeId) REFERENCES tonalidades(tonalidadeId),
  FOREIGN KEY (tipoId) REFERENCES tipoEscala(tipoEscalaId)
);
```

**Decisão: Armazenar notas como IDs delimitados por vírgula**

**Justificativa:**
- ✅ Rápido: Evita JOINs complexos na consulta
- ✅ Flexível: Permite notas em qualquer ordem
- ✅ Simples: Fácil de parsear na importação
- ❌ Menos normalizado, mas aceitável para este contexto

### 5. **Persistência de Configuração da Interface**

#### Arquivo INI para Grid Layout

```pascal
NomeArquivo: config.ini (pasta do executável)

Formato:
[BANCO]
Servidor=DC-TR-06-VM\SERVERCURSO
NomeBanco=NotasMusicais
AutenticacaoWindows=Yes
```

**Decisão:** Usar arquivo INI para configurações de conexão

**Justificativa:**
- ✅ Leve e rápido
- ✅ Não requer tabela adicional no banco
- ✅ Fácil debug (legível)
- ✅ Permite alterar sem compilar

### 6. **Gerenciamento de Conexão**

#### Uso de DataModule Centralizado

```pascal
// uDmDados.pas - Singleton pattern
dmDados.FDConexao  // Conexão única reutilizada
```

**Vantagens:**
- ✅ Evita múltiplas conexões ao banco
- ✅ Compartilhamento seguro de recursos
- ✅ Fácil manutenção da string de conexão

### 7. **Inicialização Automática do Banco**

#### Procedimentos executados no DataModuleCreate

```pascal
procedure TdmDados.DataModuleCreate(Sender: TObject);
begin
  ConfigurarConexaoDinamicamente;  // 1º: Lê config.ini
  ConfigurarBancoInicial;          // 2º: Cria banco e tabelas
end;
```

**Decisão:** Automatizar criação de banco e tabelas

**Justificativa:**
- ✅ Primeira execução não requer setup manual
- ✅ Escalável para múltiplos ambientes
- ✅ Sem dependência de scripts SQL externo
- ✅ Melhor experiência do usuário

### 8. **Codificação de Caracteres**

#### UTF-8 em Todos os Arquivos

```pascal
linhas.LoadFromFile(caminho, TEncoding.UTF8);  // Importação
linhas.SaveToFile(arquivo, TEncoding.UTF8);    // Exportação
```

**Justificativa:** 
- Suporta acentuação portuguesa/espanhola (Dó, Ré, Mi, Fá, Sol, Lá, Si)
- Universal para sistemas operacionais
- Evita problemas com caracteres especiais

### 9. **Tratamento de Erros**

#### Validação Granular com Feedback Detalhado

```pascal
// Cada validação retorna mensagem específica
msgErro := 'Nota "Dó#" não encontrada no banco';

// Grid mostra status individual
cdsImport.FieldByName('Status').AsString := 'ERRO';
cdsImport.FieldByName('Erro').AsString := msgErro;

// Relatório final consolidado
ShowMessage('Salvos: 8 | Erros: 2');
```

**Vantagem:** Usuário sabe exatamente o que falhou.

---

## 📁 Estrutura de Diretórios

```
SistemaNotasMusicais/
├── Project2.dpr                    # Arquivo principal do projeto
├── Project2.dproj                  # Projeto Delphi
├── uPrincipal.pas / .dfm          # Tela principal
├── uArquivos.pas / .dfm           # Gestão de import/export
├── TelaHeranca.pas / .dfm         # Base para formulários
│
├── Classes/                        # Camada de negócio
│   ├── cCadEscalaMusical.pas      # Classe TEscalas (CRUD escalas)
│   ├── cCadNotas.pas              # Classe TNota
│   ├── cCadTonalidades.pas        # Classe TTonalidade
│   ├── cCadTipoEscala.pas         # Classe TTipoEscala
│   ├── cFuncao.pas                # Funções utilitárias
│   └── uEnum.pas                  # Enumerações
│
├── DataModule/                     # Camada de acesso a dados
│   ├── uDmDados.pas               # Conexão FireDAC + inicialização
│   └── uDmDados.dfm               # Definições do DataModule
│
├── Cadastro/                       # Formulários de cadastro
│   ├── uCadNotas.pas / .dfm
│   ├── uCadTonalidades.pas / .dfm
│   ├── uCadEscalaMusical.pas / .dfm
│   └── uCadTipoEscala.pas / .dfm
│
├── Win32/                          # Arquivos compilados
├── Img/                            # Imagens e recursos
├── README.md                       # Este arquivo
└── config.ini                      # Configurações (gerado em runtime)
```

---

## 🔄 Fluxo de Dados

### Inicialização da Aplicação

```
Aplicação Inicia
     ↓
DataModule é Criado (DataModuleCreate)
     ↓
ConfigurarConexaoDinamicamente()
├─ Lê arquivo config.ini
└─ Configura parâmetros FireDAC
     ↓
ConfigurarBancoInicial()
├─ Cria banco NotasMusicais (se não existir)
├─ Cria tabelas: notas, tipoEscala, tonalidades, escalas
└─ Insere dados iniciais
     ↓
Aplicação Pronta para Usar
```

### Importação

```
Usuário seleciona arquivo .txt
     ↓
LerArquivoTXT()
├─ Parse: 5 campos, validação básica
└─ Carrega grid com Status OK/ERRO
     ↓
Usuário revisa e clica "Salvar"
     ↓
Para cada linha com Status OK:
├─ ValidarESalvarLinha()
├─ Busca IDs (Tipo, Tonalidade, Notas)
├─ Verifica duplicidade
└─ TEscalas.Inserir() → Banco
     ↓
Relatório final: Salvos ✅ | Erros ❌
```

### Exportação

```
Usuário clica "Exportar"
     ↓
qryArquivos.Open() → Lê todas as escalas
     ↓
Para cada escala:
├─ ObterNomesNotas() → Converte IDs em nomes
└─ Formata: Nome | Tipo | Tonalidade | Notas | Descrição
     ↓
Salva em UTF-8
     ↓
Mensagem: Confirmação + caminho do arquivo
```

---

## 🐛 Tratamento de Exceções Conhecidas

| Situação | Tratamento | Resultado |
|----------|-----------|-----------|
| Arquivo vazio | Validação na importação | Mensagem "Arquivo vazio!" |
| Tipo não existente | Validação de negócio | Status ERRO + motivo |
| Nota inválida | Query sem retorno | Status ERRO + nome da nota |
| Duplicidade de escala | COUNT(*) no banco | Status ERRO + mensagem clara |
| Encoding diferente | Carregamento UTF-8 | Caracteres corrompidos (avisar usuário) |
| Campo obrigatório vazio | Trim() + validação | Status ERRO no grid |
| Servidor SQL indisponível | Exception no DataModuleCreate | Mensagem de erro ao iniciar |

---

## 📝 Modelo de Dados Conceitual

```
┌──────────────┐
│   NOTAS      │
├──────────────┤
│ notasId (PK) │
│ nome         │ (ex: "Dó", "Ré", "Mi")
└──────────────┘
        ↑
        │ (listaNota: "1,3,5")
        │
┌──────────────────────┐
│     ESCALAS          │
├──────────────────────┤
│ escalaId (PK)        │
│ nome                 │
│ listaNota (FK)       │ ← IDs de notas separadas
│ tonalidadeId (FK)    │
│ tipoId (FK)          │
│ descricao            │
└──────────────────────┘
        ↑       ↑
        │       └────────────────┐
        │                        │
┌──────────────────┐  ┌──────────────────┐
│  TONALIDADES     │  │ TIPOESCALA       │
├──────────────────┤  ├──────────────────┤
│ tonalidadeId (PK)│  │ tipoEscalaId (PK)│
│ notaId (FK)      │  │ nome             │
│ nome             │  └──────────────────┘
└──────────────────┘
```

---

## 🚀 Melhorias Futuras Sugeridas

- [ ] **Validação avançada**: Detectar progressões não-diatônicas
- [ ] **Modo escuro**: Opção visual na interface
- [ ] **Export em CSV**: Formato adicional
- [ ] **Banco de dados em nuvem**: Sync automático
- [ ] **Busca/Filtro de escalas**: Grid dinâmico com filtros
- [ ] **Histórico de versões**: Tracking de mudanças
- [ ] **API REST**: Integração com mobile
- [ ] **Testes unitários**: QA automatizado
- [ ] **Relatórios em PDF**: Exportar com formatação

---

## 📞 Suporte e Dúvidas

Para dúvidas sobre o formato de importação ou problemas técnicos, consulte:

- **DataModule**: `DataModule/uDmDados.pas` 
  - `ConfigurarConexaoDinamicamente()` - Configuração de conexão
  - `ConfigurarBancoInicial()` - Inicialização do banco
  
- **Importação/Exportação**: `uArquivos.pas`
  - Funções `LerArquivoTXT()`, `ValidarESalvarLinha()`
  
- **Classe de Escalas**: `Classes/cCadEscalaMusical.pas`
  - Persistência e CRUD de escalas
  
- **Configuração**: Edite `config.ini` na pasta do executável

---

**Última atualização:** 12/05/2026  
**Versão:** 1.1  
**Autor:** viniciente  
**Licença:** MIT (Recomendado)
