program MeuMercado;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitLogin in 'UnitLogin.pas' {FormLogin},
  UnitData in 'UnitData.pas' {DM: TDataModule},
  UnitTemplate in 'UnitTemplate.pas' {FormTemplate},
  UnitInicial in 'UnitInicial.pas' {FormInicial},
  UnitUsuario in 'UnitUsuario.pas' {FormUsuario},
  UnitEstabelecimento in 'UnitEstabelecimento.pas' {FormEstabelecimento},
  UnitProduto in 'UnitProduto.pas' {FormProduto},
  UnitCompras in 'UnitCompras.pas' {FormCompras},
  UnitPreco in 'UnitPreco.pas' {FormPreco};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TFormLogin, FormLogin);
  Application.CreateForm(TFormTemplate, FormTemplate);
  Application.Run;
end.
