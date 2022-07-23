unit UnitInicial;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UnitTemplate, FMX.Controls.Presentation, FMX.Objects, FMX.Layouts,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView,fmx.DialogService;

type
  TFormInicial = class(TFormTemplate)
    Layout_centralPrincipal: TLayout;
    ListView_Lista: TListView;
    Image_adicionar: TImage;
    Panel_menu: TPanel;
    Label_usuarios: TLabel;
    Label_estabelecimento: TLabel;
    Label_produtos: TLabel;
    StyleBook1: TStyleBook;
    Label_menu: TLabel;
    Line3: TLine;
    Image_perfil: TImage;
    Image_menu: TImage;
    Panel_perfil: TPanel;
    label_trocarUsuario: TLabel;
    Label_sair: TLabel;
    Label5: TLabel;
    Line2: TLine;
    Line1: TLine;
    Line5: TLine;
    Label_versao: TLabel;
    Line6: TLine;
    Line7: TLine;
    Line8: TLine;
    ImageEditar: TImage;
    ImageExcluir: TImage;
    Label1: TLabel;
    procedure Image_perfilClick(Sender: TObject);
    procedure Image_menuClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label_sairClick(Sender: TObject);
    procedure label_trocarUsuarioClick(Sender: TObject);
    procedure Label_usuariosClick(Sender: TObject);
    procedure Label_estabelecimentoClick(Sender: TObject);
    procedure Label_produtosClick(Sender: TObject);
    procedure Image_adicionarClick(Sender: TObject);
    procedure ListView_ListaClick(Sender: TObject);
    procedure ListView_ListaItemClickEx(const Sender: TObject;
      ItemIndex: Integer; const LocalClickPos: TPointF;
      const ItemObject: TListItemDrawable);
  private
    { Private declarations }
    procedure AdicionaListViewLista();
    procedure ManutencaoCompras(id: string);
  public
    { Public declarations }
  end;

var
  FormInicial: TFormInicial;

implementation

{$R *.fmx}

uses UnitLogin, UnitUsuario, UnitEstabelecimento, UnitProduto, UnitCompras,
  UnitData;

procedure TFormInicial.AdicionaListViewLista;
begin
  ListView_Lista.Items.Clear;

  Dm.FDConnexao.Close;
  DM.FDConnexao.Open;
  DM.Query.Close;
  Dm.Query.SQL.Clear;
  Dm.Query.SQL.Add('SELECT id, descricao ' +
                   ' FROM lista ' +
                   ' order by id ');
  Dm.Query.Open;
  while not DM.Query.Eof do
    begin
      with ListView_Lista.Items.Add do
        begin
          Tag := Dm.Query.FieldByName('id').AsInteger;

          TListItemText(Objects.FindDrawable('lista')).Text := Dm.Query.FieldByName('descricao').AsString;
          TListItemImage(Objects.FindDrawable('editar')).Bitmap :=  ImageEditar.Bitmap;
          TListItemImage(Objects.FindDrawable('excluir')).Bitmap :=  ImageExcluir.Bitmap;
        end;

      DM.Query.Next;
    end;

  DM.FDConnexao.Close;
end;

procedure TFormInicial.FormCreate(Sender: TObject);
begin
  inherited;
  //Esconde Paineis
  Panel_Menu.Visible := False;
  Panel_perfil.Visible := False;

  //Esconde Imagens
  ImageEditar.Visible := False;
  ImageExcluir.Visible := False;

  AdicionaListViewLista;
end;

procedure TFormInicial.Image_adicionarClick(Sender: TObject);
begin
  inherited;
  // Chama a próxima tela
  FormCompras := TFormCompras.Create(self);
  FormInicial.Close;
  FormCompras.show;
end;

procedure TFormInicial.Image_menuClick(Sender: TObject);
begin
  //Esconde Painel do Perfil
  Panel_perfil.Visible := False;
  //Exibe ou oculta o painel do Menu
  Panel_menu.Visible := not Panel_menu.Visible;

  //Verifica se tem algum panel ativo, se um ou outro estiver visivel o listview fica invisivel
  if (Panel_perfil.Visible = True )or(Panel_menu.Visible = True) then
  begin
    ListView_Lista.Visible := False;
  end
  else // caso contrário fica visivel
  ListView_Lista.Visible := True;
end;

procedure TFormInicial.Image_perfilClick(Sender: TObject);
begin
  //Esonde painel Menu
  Panel_menu.Visible := False;
  //Exibe ou oculta o painel do perfil
  Panel_Perfil.Visible := not Panel_Perfil.Visible;

  //Verifica se tem algum panel ativo, se um ou outro estiver visivel o listview fica invisivel
  if (Panel_perfil.Visible = True )or(Panel_menu.Visible = True) then
  begin
    ListView_Lista.Visible := False;
  end
  else
  ListView_Lista.Visible := True;
end;

procedure TFormInicial.Label_estabelecimentoClick(Sender: TObject);
begin
  inherited;
  // Chama a tela de Estabelecimento
  FormEstabelecimento := TFormEstabelecimento.Create(Self);
  FormInicial.close;
  FormEstabelecimento.show;
end;

procedure TFormInicial.Label_produtosClick(Sender: TObject);
begin
  inherited;
  // Chama a tela de Produto
  FormProduto := TFormProduto.Create(Self);
  FormInicial.close;
  FormProduto.Show;
end;

procedure TFormInicial.Label_sairClick(Sender: TObject);
begin
  inherited;
  //Finaliza a Aplicação
  Application.Terminate;
end;

procedure TFormInicial.label_trocarUsuarioClick(Sender: TObject);
begin
  inherited;
  //Volta para a Tela de login
  FormLogin := TFormLogin.Create(Self);
  FormInicial.close;
  FormLogin.Show;
end;

procedure TFormInicial.Label_usuariosClick(Sender: TObject);
begin
  inherited;
  // Chama a tela de Usuário
  FormUsuario := TFormUsuario.Create(Self);
  FormInicial.close;
  FormUsuario.show;
end;

procedure TFormInicial.ListView_ListaClick(Sender: TObject);
begin
  inherited;
  // Quando for clicado na lista ambos os panel ficarão invisiveis
  Panel_menu.Visible := False;
  Panel_perfil.Visible := False;
end;

procedure TFormInicial.ListView_ListaItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  inherited;
 if ItemObject <> nil then    //Usuário clicou em algum objeto
  begin
    // Se for clicado para editar
    if ItemObject.Name = 'editar' then
    begin
      manutencaoCompras(ListView_Lista.Items[ItemIndex].Tag.ToString);
    end;

    // Se for clicado para excluir
    if ItemObject.Name = 'excluir' then
    begin
    // Confirmação de Exclusão
    // Lembra de declarar no uses: fmx.DialogService  //
        TDialogService.MessageDialog('Confirma exclusão?',
                                   TMsgDlgType.mtConfirmation,
                                   [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
                                   TMsgDlgBtn.mbNo,
                                   0,
        procedure(const AResult: TModalResult)
        begin
          if AResult = mrYes then   // Se for confirmado deleta da Base
          begin
            DM.FDConnexao.Connected := false;
            DM.FDConnexao.Connected := True;
            DM.Query.Close;
            DM.Query.SQL.Clear;
            DM.Query.SQL.Add(' delete from lista where id = ' + ListView_Lista.Items[ItemIndex].Tag.ToString);
            DM.Query.ExecSQL;
            AdicionaListViewLista;
          end;
        end);

      end;
  end;
end;

procedure TFormInicial.ManutencaoCompras(id: string);
begin
// Invoca o form compras e instancia ele.
  FormCompras := TFormCompras.Create(self);
  Dm.FDConnexao.close;
  Dm.FDConnexao.Open();
  Dm.Query.Close;
  DM.Query.SQL.Clear;
  DM.Query.SQL.Add('SELECT * FROM lista WHERE id = '+ id);
  Dm.Query.Open;

  // adiciona valor ao edit nomecompleto
  FormCompras.Edit_nomecompleto.text := Dm.Query.FieldByName('descricao').AsString;
  FormCompras.Edit_nomecompleto.Tag := Dm.Query.FieldByName('id').AsInteger;

  //Exibe a tela de Compras e fecha a tela atual.
  FormInicial.close;
  FormCompras.show;
end;

end.
