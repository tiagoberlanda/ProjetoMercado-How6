unit UnitInicial;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UnitTemplate, FMX.Controls.Presentation, FMX.Objects, FMX.Layouts,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView;

type
  TFormInicial = class(TFormTemplate)
    Layout_centralPrincipal: TLayout;
    ListViewPrincipal: TListView;
    Image_adicionar: TImage;
    procedure Image_perfilClick(Sender: TObject);
    procedure Image_menuClick(Sender: TObject);
    procedure Image_adicionarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormInicial: TFormInicial;

implementation

{$R *.fmx}

uses UnitPerfil, UnitMenu;

procedure TFormInicial.Image_adicionarClick(Sender: TObject);
begin
  inherited;
  ShowMessage('A opçãoo de adicionar uma lista de compras estará disponível em breve.');
end;

procedure TFormInicial.Image_menuClick(Sender: TObject);
begin
  inherited;
  UnitMenu.FormMenu := UnitMenu.TFormMenu.Create(Self);
  UnitMenu.FormMenu.Show;
  FormInicial.hide;
end;

procedure TFormInicial.Image_perfilClick(Sender: TObject);
begin
  inherited;
  UnitPerfil.FormPerfil := UnitPerfil.TFormPerfil.Create(Self);
  UnitPerfil.FormPerfil.Show;
  FormInicial.hide;
end;

end.
