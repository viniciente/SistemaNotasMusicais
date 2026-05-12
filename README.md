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
| **Delphi/Pascal** | 1.2 | Linguagem de programação |
| **FireDAC** | 1.2 | Acesso a banco de dados com suporte multi-plataforma |
| **SQL Server** | 1.2 | Persistência de dados de escalas e referências |
| **VCL (Visual Component Library)** | 1.2 | Framework de componentes visuais |
| **Git** | 1.2 | Controle de versão |

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

- **SQL Server** configurado e acessível na rede
- Arquivo executável: `Project2.exe`
- Arquivo de configuração: `config.ini` (deve estar na mesma pasta do `.exe`)

### ⚡ Passos Rápidos (Usuário Final)

#### 1️⃣ **Localize os arquivos na pasta de instalação**

Na pasta onde está `Project2.exe`, você encontrará:
```
SistemaNotasMusicais/
├── Project2.exe          ← Executável do sistema
└── config.ini            ← Arquivo de configuração
```

#### 2️⃣ **Edite o arquivo `config.ini`**

Abra o arquivo `config.ini` com um **editor de texto** (Bloco de Notas, VS Code, etc.):

```ini
[BANCO]
Servidor=SEU_SERVIDOR\INSTANCIA
NomeBanco=NotasMusicais
AutenticacaoWindows=Yes
```

**Altere os seguintes parâmetros:**

| Parâmetro | Descrição | Exemplo |
|-----------|-----------|---------|
| **Servidor** | Nome do servidor SQL + instância | `localhost\SQLEXPRESS` ou `192.168.1.100\SERVERCURSO` |
| **NomeBanco** | Nome do banco de dados (pode manter padrão) | `NotasMusicais` |
| **AutenticacaoWindows** | Usar autenticação do Windows | `Yes` (para Windows) ou `No` (para SQL Server login) |

**Exemplos de configuração:**

```ini
# Opção 1: SQL Server Express Local
[BANCO]
Servidor=localhost\SQLEXPRESS
NomeBanco=NotasMusicais
AutenticacaoWindows=Yes

# Opção 2: SQL Server em outro computador
[BANCO]
Servidor=192.168.1.100\INSTANCIA
NomeBanco=NotasMusicais
AutenticacaoWindows=Yes

# Opção 3: SQL Server com autenticação de usuário/senha
[BANCO]
Servidor=SERVIDOR\INSTANCIA
NomeBanco=NotasMusicais
AutenticacaoWindows=No
```

**⚠️ Notas importantes:**
- Certifique-se de que o SQL Server está **ligado e acessível**
- Salve o arquivo após editar

#### 3️⃣ **Execute o sistema**

Após configurar, simplesmente **clique duas vezes** em `Project2.exe`:

```
Duplo-clique em Project2.exe
         ↓
Aplicação verifica config.ini
         ↓
Conecta ao SQL Server
         ↓
Cria banco e tabelas (se não existirem)
         ↓
Sistema pronto para usar! ✅
```

**Na primeira execução:**
- ✅ O banco de dados `NotasMusicais` será criado automaticamente
- ✅ As 4 tabelas serão criadas: `notas`, `tipoEscala`, `tonalidades`, `escalas`
- ✅ Dados iniciais serão inseridos (12 notas, 8 tipos de escalas)

#### 4️⃣ **Comece a usar o sistema**

Quando a tela principal abrir:

- **Cadastro → Notas** - Visualize as 12 notas musicais criadas
- **Cadastro → Tonalidades** - Veja tonalidades musicais
- **Cadastro → Tipo Escala** - Veja 8 tipos de escalas pré-carregados
- **Arquivos → Importar/Exportar** - Importe escalas do arquivo TXT ou exporte as cadastradas

---

## 🏗️ Como Funciona a Inicialização Automática

Quando você abre `Project2.exe`, o sistema executa **automaticamente** dois procedimentos:

### **Procedimento 1: `ConfigurarConexaoDinamicamente`**

**O que acontece:**
- 🔍 Busca o arquivo `config.ini` na pasta do executável
- 📖 Lê as informações do servidor e banco de dados
- 🔌 Configura a conexão FireDAC automaticamente

---

### **Procedimento 2: `ConfigurarBancoInicial`**

**O que acontece:**
- ✅ Cria o banco de dados `NotasMusicais` (se não existir)
- ✅ Cria 4 tabelas automaticamente
- ✅ Insere dados iniciais (notas e tipos de escalas)
- ⚠️ Se houver erro, mostra mensagem

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
| **Tipo** | String | 50 | ✅ Sim | Tipo de escala (ex: "Maior", "Menor Natural", "Pentatônica Maior") |
| **Tonalidade** | String | 50 | ✅ Sim | Tonalidade base (ex: "Dó Maior", "Lá Maior") |
| **Notas** | String | 255 | ✅ Sim | Notas separadas por vírgula (ex: "Dó, Ré, Mi, Fá, Sol, Lá, Si") |
| **Descricao** | String | 500 | ❌ Não | Descrição opcional da escala |

#### Exemplos de Arquivo Válido

Crie um arquivo chamado `escalas.txt`:

```txt
Escala Maior em Dó | Maior | Dó Maior | Dó, Ré, Mi, Fá, Sol, Lá, Si | Escala diatônica maior
Escala Menor em Lá | Menor Natural | Lá Maior | Lá, Si, Dó, Ré, Mi, Fá, Sol | Escala relativa menor
Pentatônica Maior em Sol | Pentatônica Maior | Sol Maior | Sol, Lá, Si, Ré, Mi | Sem 4ª e 7ª
Escala Blues em Mi | Blues | Mi Maior | Mi, Sol, Lá, Si, Ré, Mi | Com blue note
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
```

**Arquivo de saída após exportação:** `EscalasMusicais_20260512_173000.txt`
```txt
Escala Maior em Dó | Maior | Dó Maior | Dó, Ré, Mi, Fá, Sol, Lá, Si | Fundamental
Escala Menor Harmônica | Menor Harmônica | Lá Maior | Lá, Si, Dó, Ré, Mi, Fá, Sol# | Com 7ª aumentada
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

### 5. **Persistência de Configuração**

#### Arquivo INI para Conexão de Banco

```pascal
NomeArquivo: config.ini (mesma pasta do executável)

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

### 8. **Tratamento de Erros**

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
├── Project2.exe                    # Executável (abrir para usar)
├── Project2.dproj                  # Projeto Delphi (apenas para desenvolvimento)
├── config.ini                      # Configurações de conexão (EDITAR PARA SEU AMBIENTE)
├── README.md                       # Este arquivo
│
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
└── Img/                            # Imagens e recursos
```

---

## 🔄 Fluxo de Dados

### Inicialização da Aplicação (Automática)

```
Usuário clica em Project2.exe
     ↓
Aplicação verifica config.ini
     ↓
ConfigurarConexaoDinamicamente()
├─ Lê arquivo config.ini
└─ Configura parâmetros de conexão
     ↓
ConfigurarBancoInicial()
├─ Cria banco NotasMusicais (se não existir)
├─ Cria 4 tabelas
└─ Insere dados iniciais
     ↓
Sistema Pronto para Usar! ✅
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
| config.ini não encontrado | Cria com valores padrão | Tenta conectar em localhost\SQLEXPRESS |
| Servidor SQL indisponível | Exception no DataModuleCreate | Mostra mensagem de erro |
| Arquivo vazio | Validação na importação | Mensagem "Arquivo vazio!" |
| Tipo não existente | Validação de negócio | Status ERRO + motivo |
| Nota inválida | Query sem retorno | Status ERRO + nome da nota |
| Duplicidade de escala | COUNT(*) no banco | Status ERRO + mensagem clara |
| Encoding diferente | Carregamento UTF-8 | Caracteres corrompidos (avisar usuário) |
| Campo obrigatório vazio | Trim() + validação | Status ERRO no grid |

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

**Última atualização:** 12/05/2026  
**Versão:** 1.2  
**Autor:** viniciente  
