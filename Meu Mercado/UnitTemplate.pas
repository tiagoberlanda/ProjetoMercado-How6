unit UnitTemplate;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts;

type
  TFormTemplate = class(TForm)
    Layout_superior: TLayout;
    Layout_esquerdo: TLayout;
    Layout_direito: TLayout;
    Line4: TLine;
    Layout_bemvindo: TLayout;
    Label_bemvindo: TLabel;
    Label_nomeUsuario: TLabel;
    Label_nomeTela: TLabel;
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

uses UnitLogin;

procedure TFormTemplate.FormCreate(Sender: TObject);
begin
  Label_nomeUsuario.Text := FormLogin.nomeUsuario; //Pega o nome do usuário e joga no label nomeUsuario
end;

end.
