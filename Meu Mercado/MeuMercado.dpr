program MeuMercado;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitLogin in 'UnitLogin.pas' {FormLogin},
  UnitData in 'UnitData.pas' {DM: TDataModule},
  UnitTemplate in 'UnitTemplate.pas' {FormTemplate},
  UnitPerfil in 'UnitPerfil.pas' {FormPerfil},
  UnitMenu in 'UnitMenu.pas' {FormMenu},
  UnitInicial in 'UnitInicial.pas' {FormInicial};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TFormLogin, FormLogin);
  Application.CreateForm(TFormTemplate, FormTemplate);
  Application.CreateForm(TFormPerfil, FormPerfil);
  Application.CreateForm(TFormMenu, FormMenu);
  Application.CreateForm(TFormInicial, FormInicial);
  Application.Run;
end.
