unit UnitTemplate;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts;

type
  TFormTemplate = class(TForm)
    Layout_superior: TLayout;
    Image_perfil: TImage;
    Image_menu: TImage;
    Layout_BemVindo: TLayout;
    Label_bemvindo: TLabel;
    Label_nomeUsuario: TLabel;
    Label_Caption: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormTemplate: TFormTemplate;

implementation

{$R *.fmx}

uses UnitLogin, UnitMenu, UnitPerfil;

procedure TFormTemplate.FormCreate(Sender: TObject);
begin
  Label_nomeUsuario.Text := FormLogin.nomeUsuario; //Pega o nome do usuário e joga no label nomeUsuario
end;

end.
