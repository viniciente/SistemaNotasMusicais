unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, uCadNotas, uCadTonalidades, uCadEscalaMusical, uCadTipoEscala,
  uArquivos, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Imaging.pngimage;

type
  TfrmPrincipal = class(TForm)
    pnlFundo: TPanel;
    pnlImgPiano: TPanel;
    Image1: TImage;
    MainMenu1: TMainMenu;
    CADASTRO1: TMenuItem;
    ESCALAMUSICAL1: TMenuItem;
    N1: TMenuItem;
    ONALIDADE1: TMenuItem;
    IPOESCALA1: TMenuItem;
    NOTAS1: TMenuItem;
    N2: TMenuItem;
    FECHAR1: TMenuItem;
    ARQUIVOS1: TMenuItem;
    IMPORTAOEXPORTAO1: TMenuItem;
    PnlBtnImportar: TPanel;
    lblImportTitulo: TLabel;
    Label1: TLabel;
    Image2: TImage;
    PnlExportar: TPanel;
    lblExportar: TLabel;
    Label3: TLabel;
    Image3: TImage;
    procedure FECHAR1Click(Sender: TObject);
    procedure NOTAS1Click(Sender: TObject);
    procedure ESCALAMUSICAL1Click(Sender: TObject);
    procedure IMPORTAOEXPORTAO1Click(Sender: TObject);
    procedure ONALIDADE1Click(Sender: TObject);
    procedure IPOESCALA1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PnlBtnImportarClick(Sender: TObject);
    procedure PnlExportarClick(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure Label1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

procedure TfrmPrincipal.ESCALAMUSICAL1Click(Sender: TObject);
var
  frmEscalaMusical: TfrmCadEscalaMusical;
begin
  frmEscalaMusical := TfrmCadEscalaMusical.Create(Application);
  try
    frmEscalaMusical.ShowModal;
  finally
    frmEscalaMusical.Free;
  end;
end;

procedure TfrmPrincipal.FECHAR1Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  lblImportTitulo.Font.Color := $00FF5EB1;
  lblImportTitulo.Font.Style := [fsBold];
  lblExportar.Font.Color := $00FF5EB1;
  lblExportar.Font.Style := [fsBold];
end;

procedure TfrmPrincipal.Image2Click(Sender: TObject);
begin
  if not Assigned(frmArquivos) then
    Application.CreateForm(TfrmArquivos, frmArquivos);

  frmArquivos.Show;

  frmArquivos.AbrirImportacaoDireta;
end;

procedure TfrmPrincipal.Image3Click(Sender: TObject);
var
  frmArquivos: TfrmArquivos;
begin
  frmArquivos := TfrmArquivos.Create(Application);
  try
    frmArquivos.ShowModal;
  finally
    frmArquivos.Free;
  end;
end;

procedure TfrmPrincipal.IMPORTAOEXPORTAO1Click(Sender: TObject);
var
  frmArquivos: TfrmArquivos;
begin
  frmArquivos := TfrmArquivos.Create(Application);
  try
    frmArquivos.ShowModal;
  finally
    frmArquivos.Free;
  end;
end;

procedure TfrmPrincipal.IPOESCALA1Click(Sender: TObject);
var
  frmTipoEscala: TfrmCadTipoEscala;
begin
  frmTipoEscala := TfrmCadTipoEscala.Create(Application);
  try
    frmTipoEscala.ShowModal;
  finally
    frmTipoEscala.Free;
  end;
end;

procedure TfrmPrincipal.Label1Click(Sender: TObject);
begin
  if not Assigned(frmArquivos) then
    Application.CreateForm(TfrmArquivos, frmArquivos);

  frmArquivos.Show;

  frmArquivos.AbrirImportacaoDireta;
end;

procedure TfrmPrincipal.Label3Click(Sender: TObject);
var
  frmArquivos: TfrmArquivos;
begin
  frmArquivos := TfrmArquivos.Create(Application);
  try
    frmArquivos.ShowModal;
  finally
    frmArquivos.Free;
  end;
end;

procedure TfrmPrincipal.NOTAS1Click(Sender: TObject);
var
  frmNotas: TfrmCadNotas;
begin
  frmNotas := TfrmCadNotas.Create(Application);
  try
    frmNotas.ShowModal;
  finally
    frmNotas.Free;
  end;
end;

procedure TfrmPrincipal.ONALIDADE1Click(Sender: TObject);
var frmTonalidades : TfrmCadTonalidades;
begin
  frmTonalidades := TfrmCadTonalidades.Create(Application);
  try
    frmTonalidades.ShowModal;
  finally
    frmTonalidades.Free;
  end;
end;

procedure TfrmPrincipal.PnlBtnImportarClick(Sender: TObject);
begin
  if not Assigned(frmArquivos) then
    Application.CreateForm(TfrmArquivos, frmArquivos);

  frmArquivos.Show;

  frmArquivos.AbrirImportacaoDireta;
end;

procedure TfrmPrincipal.PnlExportarClick(Sender: TObject);
var
  frmArquivos: TfrmArquivos;
begin
  frmArquivos := TfrmArquivos.Create(Application);
  try
    frmArquivos.ShowModal;
  finally
    frmArquivos.Free;
  end;
end;

end.
