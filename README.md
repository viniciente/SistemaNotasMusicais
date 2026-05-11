# Sistema de Notas Musicais

## 🎵 Objetivo

Sistema de gestão de escalas musicais com suporte completo para entrada e saída de dados em arquivos TXT. Este projeto implementa um desafio de processamento de dados musicais, permitindo catalogar, importar e exportar escalas musicais com suas tonalidades e notas correspondentes.

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
| **Delphi/Pascal** | - | Linguagem Pascal |
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

- Banco de dados SQL Server configurado
- Arquivo `Project2.exe`
- 

### Passos para Execução

1. **Abra o projeto no Delphi:**
   ```bash
   delphi Project2.dproj
   ```

2. **Configure a conexão do banco de dados:**
   - Acesse `DataModule/dmDados.pas`
   - Configure as credenciais de conexão FireDAC

3. **Compile o projeto:**
   - Pressione `Ctrl+Shift+F9` (Build All) no Delphi
   - Ou acesse Menu → Project → Build Project

4. **Execute o aplicativo:**
   - Pressione `F9` ou clique no botão Run
   - A tela principal (`uPrincipal`) será exibida

5. **Popule o banco com dados iniciais:**
   - Acesse **Cadastro → Notas** para criar as notas musicais
   - Acesse **Cadastro → Tonalidades** para adicionar tonalidades
   - Acesse **Cadastro → Tipo Escala** para definir os tipos

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
Escala Menor em Lá | Menor | Lá | Lá, Si, Dó, Ré, Mi, Fá, Sol | Escala relativa menor
Pentatônica Maior | Pentatônica | Sol | Sol, Lá, Si, Ré, Mi | Escala pentatônica sem 4ª e 7ª
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
   - Ou use o atalho **Importação Direta** (painel específico)

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
Escala Maior em Dó | Maior | Dó | Dó, Ré, Mi, Fá, Sol, Lá, Si | Fundamental
Escala Menor Harmônica | Menor | Lá | Lá, Si, Dó, Ré, Mi, Fá, Sol# | Com 7ª aumentada
Modo Dórico | Modo | Ré | Ré, Mi, Fá, Sol, Lá, Si, Dó | Segundo modo
```

**Arquivo de saída após exportação:** `EscalasMusicais_20260511_173000.txt`
```txt
Escala Maior em Dó | Maior | Dó | Dó, Ré, Mi, Fá, Sol, Lá, Si | Fundamental
Escala Menor Harmônica | Menor | Lá | Lá, Si, Dó, Ré, Mi, Fá, Sol# | Com 7ª aumentada
Modo Dórico | Modo | Ré | Ré, Mi, Fá, Sol, Lá, Si, Dó | Segundo modo
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
│   dmDados (DataModule)                  │
├─────────────────────────────────────────┤
│   Banco de Dados                        │
│   SQLite / SQL Server                   │
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

1. **Fase 1 - Formatação (LerArquivoTXT):**
   ```pascal
   - Verifica 5 campos separados por |
   - Detecta campos vazios obrigatórios
   - Status: OK ou ERRO (formatação)
   ```

2. **Fase 2 - Negócio (ValidarESalvarLinha):**
   ```pascal
   - Busca IDs no banco (Tipo, Tonalidade, Notas)
   - Valida duplicidade de escalas
   - Insere com transaction implícita
   - Status: ERRO (validação) ou SALVO (sucesso)
   ```

**Justificativa:** Permite feedback claro ao usuário, possibilita correção de erros antes da persistência.

### 4. **Armazenamento de Escalas**

#### Estrutura de Dados - Tabela `escalas`

```sql
CREATE TABLE escalas (
  escalaId        INTEGER PRIMARY KEY AUTOINCREMENT,
  nome            VARCHAR(100) NOT NULL,
  tonalidadeId    INTEGER NOT NULL FOREIGN KEY,
  tipoId          INTEGER NOT NULL FOREIGN KEY,
  listaNota       TEXT NOT NULL,  -- IDs separadas por vírgula (ex: "1,3,5,7")
  descricao       TEXT,
  caminhoArquivo  TEXT,           -- Para rastreabilidade
  nomeArquivo     TEXT,           -- Nome do arquivo de origem
  conteudoArquivo TEXT,           -- Conteúdo raw do arquivo
  FOREIGN KEY (tonalidadeId) REFERENCES tonalidades(tonalidadeId),
  FOREIGN KEY (tipoId) REFERENCES tipoEscala(tipoEscalaId)
);
```

**Decisão: Armazenar notas como IDs delimitados por vírgula**

**Justificativa:**
- ✅ Rápido: Evita JOINs complexos na consulta
- ✅ Flexível: Permite notas em qualquer ordem
- ✅ Rastreável: Campo `caminhoArquivo` mostra origem
- ❌ Menos normalizado, mas aceitável para este contexto

### 5. **Persistência de Configuração da Interface**

#### Arquivo INI para Grid Layout

```pascal
NomeArquivo: config_grids.ini (pasta do executável)

Formato:
[frmArquivos_dbGridConsulta_Width]
nome=120
tipoEscala=100
...

[frmArquivos_dbGridConsulta_Index]
nome=0
...
```

**Decisão:** Usar arquivo INI em vez de banco de dados para configurações de UI

**Justificativa:**
- ✅ Leve e rápido
- ✅ Não requer tabela adicional
- ✅ Fácil debug (legível)
- ✅ Permite per-usuario (futuro)

### 6. **Gerenciamento de Conexão**

#### Uso de DataModule Centralizado

```pascal
// dmDados.pas - Singleton pattern
dmDados.FDConexao  // Conexão única reutilizada
```

**Vantagens:**
- ✅ Evita múltiplas conexões ao banco
- ✅ Compartilhamento seguro de recursos
- ✅ Fácil manutenção da string de conexão

### 7. **Codificação de Caracteres**

#### UTF-8 em Todos os Arquivos

```pascal
linhas.LoadFromFile(caminho, TEncoding.UTF8);  // Importação
linhas.SaveToFile(arquivo, TEncoding.UTF8);    // Exportação
```

**Justificativa:** 
- Suporta acentuação portuguesa/espanhola (Dó, Ré, Mi, Fá, Sol, Lá, Si)
- Universal para sistemas operacionais
- Evita problemas com caracteres especiais

### 8. **Componentes Visuais Customizados**

#### Grid com Localização de Dados

```pascal
procedure CentralizarColunas(pGrid: TDBGrid);
procedure CarregarConfiguracaoGrid(pGrid: TDBGrid);
procedure SalvarConfiguracaoGrid(pGrid: TDBGrid);
```

**Benefício:** Interface consistente e agradável, com estado persistente.

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

### 10. **Performance**

#### Otimizações Aplicadas

| Otimização | Local | Benefício |
|-----------|-------|-----------|
| `DisableControls` | Loop de salvamento | Evita redraw de grids |
| `Bookmark` | Exportação | Mantém posição original |
| Query reutilizada | ValidarESalvarLinha | Evita criar múltiplas queries |
| Índices no banco | escalas(nome, tonalidadeId) | Busca rápida de duplicidade |

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
│   └── dmDados.pas                # Conexão FireDAC centralizada
│
├── Cadastro/                       # Formulários de cadastro
│   ├── uCadNotas.pas
│   ├── uCadTonalidades.pas
│   ├── uCadEscalaMusical.pas
│   └── uCadTipoEscala.pas
│
├── Win32/                          # Arquivos compilados
├── Img/                            # Imagens e recursos
├── README.md                       # Este arquivo
└── config_grids.ini               # Configurações salvas (gerado em runtime)
```

---

## 🔄 Fluxo de Dados

### Importação

```
Usuário seleciona .txt
         ↓
  LerArquivoTXT()
         ↓
  Parse: 5 campos, validação básica
         ↓
  Carrega grid com Status OK/ERRO
         ↓
Usuário clica "Salvar"
         ↓
  ValidarESalvarLinha() para cada linha
         ↓
  Busca IDs (Tipo, Tonalidade, Notas)
         ↓
  Verifica duplicidade
         ↓
  TEscalas.Inserir() → Banco
         ↓
  Relatório final
```

### Exportação

```
Usuário clica "Exportar"
         ↓
  qryArquivos.Open() → Lê todas as escalas
         ↓
  Loop: Para cada escala
         ├─ ObterNomesNotas() → Converte IDs em nomes
         └─ Formata: Nome | Tipo | Tonalidade | Notas | Descrição
         ↓
  Salva em UTF-8
         ↓
  Mensagem: Confirmação + caminho
```

---

## 🐛 Tratamento de Exceções Conhecidas

| Situação | Tratamento | Resultado |
|----------|-----------|-----------|
| Arquivo vazio | Validação na importação | Mensagem "Arquivo vazio!" |
| Tipo não existente | Validação de negócio | Status ERRO + motivo |
| Nota inválida | Query sem retorno | Status ERRO + nome da nota |
| Duplicidade | COUNT(*) no banco | Status ERRO + mensagem clara |
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
│ caminhoArquivo       │
└──────────────────────┘
        ↑       ↑
        │       └────────────────┐
        │                        │
┌──────────────────┐  ┌──────────────────┐
│  TONALIDADES     │  │ TIPOESCALA       │
├──────────────────┤  ├──────────────────┤
│ tonalidadeId (PK)│  │ tipoEscalaId (PK)│
│ nome             │  │ nome             │
└──────────────────┘  └──────────────────┘
```

---

## 🚀 Melhorias Futuras Sugeridas

- [ ] **Validação avançada**: Detectar progressões não-diatônicas
- [ ] **Modo escuro**: Opção visual na interface
- [ ] **Export em CSV**: Formato adicional
- [ ] **Banco de dados em nuvem**: Sync automático
- [ ] **Busca/Filtro de escalas**: Grid dinâmico
- [ ] **Histórico de versões**: Tracking de mudanças
- [ ] **API REST**: Integração com mobile
- [ ] **Testes unitários**: QA automatizado

---

## 📞 Suporte e Dúvidas

Para dúvidas sobre o formato de importação ou problemas técnicos, consulte:
- Arquivo: `uArquivos.pas` (funções `LerArquivoTXT`, `ValidarESalvarLinha`)
- Classe: `Classes/cCadEscalaMusical.pas` (persistência)
- DataModule: Configurar conexão em `dmDados`

---

**Última atualização:** 11/05/2026  
**Versão:** 1.0  
**Autor:** viniciente  
**Licença:** MIT (Recomendado)
