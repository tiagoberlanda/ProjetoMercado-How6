unit UnitPerfil;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UnitTemplate, FMX.Controls.Presentation, FMX.Objects, FMX.Layouts;

type
  TFormPerfil = class(TFormTemplate)
    Layout_central: TLayout;
    RoundRect_sair: TRoundRect;
    Label_sair: TLabel;
    RoundRect_trocarUsuario: TRoundRect;
    Label_trocarUsuario: TLabel;
    Layout4: TLayout;
    Image2: TImage;
    Label_opcoesPerfil: TLabel;
    Line9: TLine;
    Line10: TLine;
    procedure Image2Click(Sender: TObject);
    procedure Image_menuClick(Sender: TObject);
    procedure Label_sairClick(Sender: TObject);
    procedure Label_trocarUsuarioClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormPerfil: TFormPerfil;

implementation

{$R *.fmx}

uses UnitInicial, UnitMenu, UnitLogin;

procedure TFormPerfil.Image2Click(Sender: TObject);
begin
  inherited;
  UnitInicial.FormInicial := UnitInicial.TFormInicial.Create(Self);
  UnitInicial.FormInicial.Show;
  FormPerfil.hide;
end;

procedure TFormPerfil.Image_menuClick(Sender: TObject);
begin
  inherited;
  UnitMenu.FormMenu :=  UnitMenu.TFormMenu.Create(Self);
  UnitMenu.FormMenu.Show;
  FormPerfil.hide;
end;

procedure TFormPerfil.Label_sairClick(Sender: TObject);
begin
  inherited;
  Application.Terminate;
end;

procedure TFormPerfil.Label_trocarUsuarioClick(Sender: TObject);
begin
  inherited;
  UnitLogin.FormLogin := UnitLogin.TFormLogin.Create(Self);
  UnitLogin.FormLogin.Show;
  FormPerfil.Close;
end;

end.
