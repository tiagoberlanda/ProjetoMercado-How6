program MeuMercado;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitLogin in 'UnitLogin.pas' {FormLogin},
  UnitPrincipal in 'UnitPrincipal.pas' {FormPrincipal},
  UnitData in 'UnitData.pas' {DM: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormLogin, FormLogin);
  Application.CreateForm(TDM, DM);
  Application.Run;
end.
