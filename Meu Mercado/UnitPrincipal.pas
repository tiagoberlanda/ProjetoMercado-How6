unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.TabControl, FMX.Edit,
  FMX.Memo.Types, FMX.ScrollBox, FMX.Memo;

type
  TFormPrincipal = class(TForm)
    Layout_superior: TLayout;
    Image_perfil: TImage;
    Image_menu: TImage;
    Label_bemvindo: TLabel;
    Label_nomeUsuario: TLabel;
    Layout_BemVindo: TLayout;
    TabControlPrincipal: TTabControl;
    Tab_Perfil: TTabItem;
    Tab_Menu: TTabItem;
    Tab_Adicionar: TTabItem;
    StyleBook1: TStyleBook;
    RoundRect_sair: TRoundRect;
    Layout_central: TLayout;
    Label_sair: TLabel;
    Tab_Principal: TTabItem;
    Image_adicionar: TImage;
    Layout_central_adicionar: TLayout;
    RoundRect_adicionarListaCompras: TRoundRect;
    listaDeCompras: TLabel;
    Image_adicionarListaCompras: TImage;
    Layout_Superior_Principal: TLayout;
    Layout2: TLayout;
    Image_voltar_adicionar: TImage;
    Layout3: TLayout;
    Image1: TImage;
    Layout4: TLayout;
    Image2: TImage;
    RoundRect_Estabelecimentos: TRoundRect;
    Label_estabelecimento: TLabel;
    Image_adicionarEstabelecimento: TImage;
    RoundRect_produtos: TRoundRect;
    Label_adicionarProdutos: TLabel;
    Image_adicionarProdutos: TImage;
    Tab_adicionar_estabelecimento: TTabItem;
    Layout_superiorAddEstabelecimento: TLayout;
    Image_voltarAddEstabelecimento: TImage;
    Layout_central_addEstabelecimento: TLayout;
    RoundRect_nomeEstabelecimento: TRoundRect;
    Edit_nomeEstabelecimento: TEdit;
    RoundRect_enderecoEstabelecimento: TRoundRect;
    Edit_enderecoEstabelecimento: TEdit;
    RoundRect_telefone: TRoundRect;
    Edit_telefoneEstabelecimento: TEdit;
    RoundRect_salvarEstabelecimento: TRoundRect;
    Label_salvarEstabelecimento: TLabel;
    Label_opcoesPerfil: TLabel;
    Label_menuOpcoes: TLabel;
    Label_telaInicial: TLabel;
    Label_adicionarEstabelecimento: TLabel;
    Label_adicionar: TLabel;
    �: TLayout;
    RoundRect_consultarUsuarios: TRoundRect;
    Label_consultarUsuarios: TLabel;
    RoundRect_consultarEstabelecimentos: TRoundRect;
    Label_consultarEstabelecimentos: TLabel;
    RoundRect_consultarProdutos: TRoundRect;
    Label_consultarProdutos: TLabel;
    Layout_centralPrincipal: TLayout;
    Memo_principal: TMemo;
    Line3: TLine;
    Line1: TLine;
    Line2: TLine;
    Line4: TLine;
    Line5: TLine;
    Line6: TLine;
    Line7: TLine;
    Line8: TLine;
    Line9: TLine;
    Line10: TLine;
    procedure FormCreate(Sender: TObject);
    procedure Image_perfilClick(Sender: TObject);
    procedure Image_menuClick(Sender: TObject);
    procedure RoundRect_sairClick(Sender: TObject);
    procedure Image_adicionarClick(Sender: TObject);
    procedure listaDeComprasClic(Sender: TObject);
    procedure Image_voltar_adicionarClick(Sender: TObject);
    procedure Label_estabelecimentoClick(Sender: TObject);
    procedure Label_salvarEstabelecimentoClick(Sender: TObject);
    procedure Image_voltarAddEstabelecimentoClick(Sender: TObject);
    procedure Label_consultarUsuariosClick(Sender: TObject);
    procedure Label_consultarEstabelecimentosClick(Sender: TObject);
    procedure Label_consultarProdutosClick(Sender: TObject);
    procedure Label_adicionarProdutosClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.fmx}

uses UnitLogin;

procedure TFormPrincipal.FormCreate(Sender: TObject);
begin
  Label_nomeUsuario.Text := FormLogin.nomeUsuario;
  TabControlPrincipal.ActiveTab := Tab_Principal;
end;

procedure TFormPrincipal.Image_adicionarClick(Sender: TObject);
begin
  TabControlPrincipal.ActiveTab := Tab_Adicionar;
end;

procedure TFormPrincipal.Image_menuClick(Sender: TObject);
begin
  TabControlPrincipal.ActiveTab := Tab_Menu;
end;

procedure TFormPrincipal.Image_perfilClick(Sender: TObject);
begin
  TabControlPrincipal.ActiveTab := Tab_Perfil;
end;

procedure TFormPrincipal.Image_voltarAddEstabelecimentoClick(Sender: TObject);
begin
  TabControlPrincipal.ActiveTab := Tab_Adicionar;
end;

procedure TFormPrincipal.Image_voltar_adicionarClick(Sender: TObject);
begin
  TabControlPrincipal.ActiveTab := Tab_Principal;
end;

procedure TFormPrincipal.Label_adicionarProdutosClick(Sender: TObject);
begin
  ShowMessage('Ta quase l�!');
end;

procedure TFormPrincipal.Label_consultarEstabelecimentosClick(Sender: TObject);
begin
  ShowMessage('Na pr�xima vers�o!!');
end;

procedure TFormPrincipal.Label_consultarProdutosClick(Sender: TObject);
begin
  ShowMessage('Quase l�');
end;

procedure TFormPrincipal.Label_consultarUsuariosClick(Sender: TObject);
begin
  ShowMessage('Somente Administrador!');
end;

procedure TFormPrincipal.Label_estabelecimentoClick(Sender: TObject);
begin
  TabControlPrincipal.ActiveTab := Tab_adicionar_estabelecimento;
end;

procedure TFormPrincipal.Label_salvarEstabelecimentoClick(Sender: TObject);
begin
  ShowMessage('Estabelecimento Salvo com Sucesso!');
  TabControlPrincipal.ActiveTab := Tab_Adicionar;
end;

procedure TFormPrincipal.listaDeComprasClic(Sender: TObject);
begin
  ShowMessage('Em Breve!');
end;

procedure TFormPrincipal.RoundRect_sairClick(Sender: TObject);
begin
  Application.Terminate;
end;

end.
