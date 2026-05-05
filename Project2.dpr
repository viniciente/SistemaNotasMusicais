program Project2;

uses
  Vcl.Forms,
  TelaHeranca in 'TelaHeranca.pas' {frmTelaHeranca},
  uCadNotas in 'Cadastro\uCadNotas.pas' {frmCadNotas};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmTelaHeranca, frmTelaHeranca);
  Application.CreateForm(TfrmCadNotas, frmCadNotas);
  Application.Run;
end.
