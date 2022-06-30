unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.TabControl, FMX.Edit,
  FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView;

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
    Layout_superior_menu: TLayout;
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
    Layou_central_menu: TLayout;
    RoundRect_consultarUsuarios: TRoundRect;
    Label_consultarUsuarios: TLabel;
    RoundRect_consultarEstabelecimentos: TRoundRect;
    Label_consultarEstabelecimentos: TLabel;
    RoundRect_consultarProdutos: TRoundRect;
    Label_consultarProdutos: TLabel;
    Layout_centralPrincipal: TLayout;
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
    Tab_ConsultaUsuario: TTabItem;
    Layout_supConsultaUsuario: TLayout;
    Image3: TImage;
    Label_consutaUsuario: TLabel;
    Line11: TLine;
    Line12: TLine;
    ListView_usuario: TListView;
    Layout_centConsutaUsuario: TLayout;
    RoundRect1: TRoundRect;
    Label_trocarUsuario: TLabel;
    Tab_consultaEstabelecimento: TTabItem;
    Layout_supConsultaEstabelecimento: TLayout;
    Image_voltarConsultaEstabelecimento: TImage;
    Label_consultaEstabelecimento: TLabel;
    Line13: TLine;
    Line14: TLine;
    Layout_centralConsultaEstabelecimento: TLayout;
    ListView_consultaEstabelecimento: TListView;
    ListViewPrincipal: TListView;
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
    procedure Image3Click(Sender: TObject);
    procedure Label_trocarUsuarioClick(Sender: TObject);
    procedure Image_voltarConsultaEstabelecimentoClick(Sender: TObject);
  private
    { Private declarations }
    procedure AdicionaListViewUsuarios(usuario,nome: string);
    procedure AdicionaListViewEstabelecimento(id,estabelecimento: string);
    procedure InsereEstabelecimento(nome, endereco,telefone: string);
  public
    { Public declarations }
  end;

var
  FormPrincipal: TFormPrincipal;
  vbLimpar: boolean;
implementation

{$R *.fmx}

uses UnitLogin, UnitData;

// Adiciona Itens no List View Usu�rios
procedure TFormPrincipal.AdicionaListViewUsuarios(usuario,nome: string);
begin
  ListView_usuario.Items.Clear;  //Limpa informa��es do ListView
  DM.FDConnexao.Close;   //Fecha conex�o com Banco
  DM.FDConnexao.Open();  //Abre conex�o com Banco
  DM.QueryUsuarios.Open; //Executa a Query de Consultar Usu�rios

  with ListView_usuario.Items.Add do  // Adiciona informa��o no List View
  begin
    TListItemText(Objects.FindDrawable('Linha')).Text := 'Nome Completo | Usu�rio';
  end;

  while not DM.QueryUsuarios.Eof do  // Enquanto tiver informa��o no Select ira seguir conforme abaixo
  begin
    with ListView_usuario.Items.Add do //Ira adicionar no ListView as seguintes informa��es
    begin
        nome :=DM.QueryUsuarios.FieldByName('nome').AsString;  // Nome completo do usu�rio
        usuario :=DM.QueryUsuarios.FieldByName('usuario').AsString;   // Nome do usu�rio
        TListItemText(Objects.FindDrawable('Linha')).Text := nome + ' | ' + usuario;  // Escreve na linha concatenando nome e usu�rio
        DM.QueryUsuarios.Next; //Passa para a pr�xima linha do resultado do Select
    end;

  end;
  DM.FDConnexao.Close;
end;

// Adiciona Itens no List View Estabelcimentos
procedure TFormPrincipal.AdicionaListViewEstabelecimento(id, estabelecimento: string);
begin
  ListView_consultaEstabelecimento.Items.Clear;
  DM.FDConnexao.Close;
  DM.FDConnexao.Open;
  DM.QueryEstabelecimentos.Open;

  with ListView_consultaEstabelecimento.Items.Add do
  begin
   TListItemText(Objects.FindDrawable('Linha')).Text := 'ID | Estabelecimento';
  end;

  while not DM.QueryEstabelecimentos.Eof do
  begin
    with ListView_consultaEstabelecimento.Items.Add do
    begin
      id := DM.QueryEstabelecimentos.FieldByName('id').AsString;
      estabelecimento := DM.QueryEstabelecimentos.FieldByName('descricao').AsString;
      TListItemText(Objects.FindDrawable('Linha')).Text := id + ' | ' + estabelecimento;
      DM.QueryEstabelecimentos.Next;
    end;
  end;
  DM.FDConnexao.Close;
end;

procedure TFormPrincipal.FormCreate(Sender: TObject);
begin
  Label_nomeUsuario.Text := FormLogin.nomeUsuario; //Pega o nome do usu�rio e joga no label nomeUsuario
  TabControlPrincipal.ActiveTab := Tab_Principal; //Troca Tab
end;

procedure TFormPrincipal.Image3Click(Sender: TObject);
begin
  TabControlPrincipal.ActiveTab := Tab_Menu;
end;

procedure TFormPrincipal.Image_adicionarClick(Sender: TObject);
begin
  TabControlPrincipal.ActiveTab := Tab_Adicionar;  //Troca Tab
end;

procedure TFormPrincipal.Image_menuClick(Sender: TObject);
begin
  TabControlPrincipal.ActiveTab := Tab_Menu; //Troca Tab
end;

procedure TFormPrincipal.Image_perfilClick(Sender: TObject);
begin
  TabControlPrincipal.ActiveTab := Tab_Perfil; //Troca Tab
end;

procedure TFormPrincipal.Image_voltarAddEstabelecimentoClick(Sender: TObject);
begin
  TabControlPrincipal.ActiveTab := Tab_Adicionar; //Troca Tab
end;

procedure TFormPrincipal.Image_voltarConsultaEstabelecimentoClick(
  Sender: TObject);
begin
  TabControlPrincipal.ActiveTab := Tab_menu;
end;

procedure TFormPrincipal.Image_voltar_adicionarClick(Sender: TObject);
begin
  TabControlPrincipal.ActiveTab := Tab_Principal; //Troca Tab
end;

procedure TFormPrincipal.InsereEstabelecimento(nome, endereco,
  telefone: string);
begin
  DM.FDConnexao.Close;
  DM.FDConnexao.Open;
  DM.Query.Close;
  DM.Query.SQL.Clear;
  DM.Query.SQL.Add('INSERT INTO estabelecimento (descricao,endereco,telefone) VALUES (:NOME,:ENDERECO,:TELEFONE); ');
  DM.Query.ParamByName('NOME').AsString := nome;
  DM.Query.ParamByName('ENDERECO').AsString := endereco;
  DM.Query.ParamByName('TELEFONE').AsString :=  telefone;
  DM.Query.ExecSQL;
end;

procedure TFormPrincipal.Label_adicionarProdutosClick(Sender: TObject);
begin
  ShowMessage('Dispon�vel na pr�xima vers�o :)');
end;

procedure TFormPrincipal.Label_consultarEstabelecimentosClick(Sender: TObject);
begin
  AdicionaListViewEstabelecimento('','');
  TabControlPrincipal.ActiveTab := Tab_consultaEstabelecimento;
end;

procedure TFormPrincipal.Label_consultarProdutosClick(Sender: TObject);
begin
  ShowMessage('Dispon�vel na pr�xima vers�o :)');
end;

procedure TFormPrincipal.Label_consultarUsuariosClick(Sender: TObject);
begin
  AdicionaListViewUsuarios('','');
  TabControlPrincipal.ActiveTab := Tab_ConsultaUsuario;  //Troca Tab
end;

procedure TFormPrincipal.Label_estabelecimentoClick(Sender: TObject);
begin
  TabControlPrincipal.ActiveTab := Tab_adicionar_estabelecimento; //Troca Tab
end;

procedure TFormPrincipal.Label_salvarEstabelecimentoClick(Sender: TObject);
begin
  if (Edit_nomeEstabelecimento.Text = '') then
  begin
    ShowMessage('Preencha o Nome do Estabelecimento!')
  end
  else
  begin
    InsereEstabelecimento(Edit_nomeEstabelecimento.Text,
    Edit_enderecoEstabelecimento.Text,Edit_telefoneEstabelecimento.Text);
    ShowMessage('Estabelecimento Salvo com Sucesso!');
    TabControlPrincipal.ActiveTab := Tab_Adicionar;  //Troca Tab
  end;

end;

procedure TFormPrincipal.Label_trocarUsuarioClick(Sender: TObject);
begin
  FormLogin := TFormLogin.Create(Self);  //Invoca o Objeto
  FormPrincipal.hide; //Fecha tela principal
  FormLogin.Show; //Exibe tela de login
end;

procedure TFormPrincipal.listaDeComprasClic(Sender: TObject);
begin
  ShowMessage('Em Breve!');
end;

procedure TFormPrincipal.RoundRect_sairClick(Sender: TObject);
begin
  Application.Terminate;  //Encerra a aplica��o
end;

end.
