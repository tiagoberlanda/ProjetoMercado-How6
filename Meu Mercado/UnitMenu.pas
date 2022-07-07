unit UnitMenu;

interface

uses
  System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UnitTemplate, FMX.Controls.Presentation, FMX.Objects, FMX.Layouts,
  FMX.TabControl, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, FMX.Edit;

type
  TFormMenu = class(TFormTemplate)
    TabControlMenu: TTabControl;
    TabMenu: TTabItem;
    q: TLayout;
    RoundRectUsuarios: TRoundRect;
    LabelConsutlarUsuarios: TLabel;
    RoundRectEstabelecimentos: TRoundRect;
    LabelConsultarEstabelecimento: TLabel;
    RoundRectProdutos: TRoundRect;
    LabelConsultarProdutos: TLabel;
    Image1: TImage;
    TabConsultaEstabelecimento: TTabItem;
    Layout_centralConsultaEstabelecimento: TLayout;
    ListView_consultaEstabelecimento: TListView;
    StyleBook1: TStyleBook;
    TabConsultaUsuarios: TTabItem;
    Layout_centConsutaUsuario: TLayout;
    ListView_usuario: TListView;
    ImageEditar: TImage;
    TabEditUsuario: TTabItem;
    TabEditEstabelecimento: TTabItem;
    Layout_central_cadastro: TLayout;
    RoundRect_nomecompleto: TRoundRect;
    Edit_nomecompleto: TEdit;
    RoundRect_senha: TRoundRect;
    Edit_senha_cadastro: TEdit;
    RoundRect_salvar: TRoundRect;
    Label_atualizar_cadastro: TLabel;
    RoundRect_usuario: TRoundRect;
    Edit_usuario_cadastro: TEdit;
    Layout_central_EditEstabelecimento: TLayout;
    RoundRect_nomeEstabelecimento: TRoundRect;
    Edit_nomeEstabelecimento: TEdit;
    RoundRect_enderecoEstabelecimento: TRoundRect;
    Edit_enderecoEstabelecimento: TEdit;
    RoundRect_telefone: TRoundRect;
    Edit_telefoneEstabelecimento: TEdit;
    RoundRect_salvarEstabelecimento: TRoundRect;
    Label_salvarEstabelecimento: TLabel;
    Image_adicionar: TImage;
    ImageExcluir: TImage;
    ImageCancelar: TImage;
    procedure Image_perfilClick(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure LabelConsultarEstabelecimentoClick(Sender: TObject);
    procedure LabelConsutlarUsuariosClick(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure LabelConsultarProdutosClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ImageVoltarManUsuarioClick(Sender: TObject);
    procedure Image_menuClick(Sender: TObject);
    procedure ImageCancelarManUsuarioClick(Sender: TObject);
    procedure ListView_consultaEstabelecimentoItemClickEx(const Sender: TObject; ItemIndex: Integer; const LocalClickPos: TPointF;
      const ItemObject: TListItemDrawable);
    procedure Image_adicionarClick(Sender: TObject);
    procedure RoundRect_salvarEstabelecimentoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListView_usuarioItemClickEx(const Sender: TObject; ItemIndex: Integer; const LocalClickPos: TPointF;
      const ItemObject: TListItemDrawable);
    procedure Label_atualizar_cadastroClick(Sender: TObject);
  private
    { Private declarations }
    procedure AdicionaListViewEstabelecimento(id, estabelecimento: string);
    procedure AdicionaListViewUsuarios(usuario,nome: string);
    procedure ManutencaoEstabelecimento(id: string);
    procedure ManutencaoUsuario(id: string);
  public
    { Public declarations }
    function ExecPergunta(vsPergunta : String) : TModalResult;
  end;

var
  FormMenu: TFormMenu;

implementation

{$R *.fmx}

uses UnitPerfil, UnitInicial, UnitData, System.SysUtils;

procedure TFormMenu.AdicionaListViewEstabelecimento(id, estabelecimento: string);
begin
  ListView_consultaEstabelecimento.Items.Clear;

  DM.FDConnexao.Close;
  DM.FDConnexao.Open;
  DM.QueryEstabelecimentos.Open;

  while not DM.QueryEstabelecimentos.Eof do
    begin
      id := DM.QueryEstabelecimentos.FieldByName('id').AsString;
      estabelecimento := DM.QueryEstabelecimentos.FieldByName('descricao').AsString;

      with ListView_consultaEstabelecimento.Items.Add do
        begin
          Tag := StrToInt(id);

          TListItemText(Objects.FindDrawable('Linha')).Text := id + ' | ' + estabelecimento;
          TListItemImage(Objects.FindDrawable('Editar')).Bitmap :=  ImageEditar.Bitmap;
          TListItemImage(Objects.FindDrawable('Excluir')).Bitmap :=  ImageExcluir.Bitmap;
        end;

      DM.QueryEstabelecimentos.Next;
    end;

  DM.FDConnexao.Close;
end;


// Adiciona Itens no List View Usuários
procedure TFormMenu.AdicionaListViewUsuarios(usuario,nome: string);
begin
  ListView_usuario.Items.Clear;

  DM.FDConnexao.Close;
  DM.FDConnexao.Open;

  DM.QueryUsuarios.Close; //Executa a Query de Consultar Usuários
  DM.QueryUsuarios.sql.Clear;
  DM.QueryUsuarios.SQL.Add(' select * from usuario order by usuario ');
  DM.QueryUsuarios.Open;

  while not DM.QueryUsuarios.Eof do
    begin
      usuario := DM.QueryUsuarios.FieldByName('usuario').AsString;
      nome := DM.QueryUsuarios.FieldByName('nome').AsString;

      with ListView_usuario.Items.Add do
        begin
          TagString := usuario;

          TListItemText(Objects.FindDrawable('Linha')).Text := usuario + ' | ' + nome;
          TListItemImage(Objects.FindDrawable('Editar')).Bitmap :=  ImageEditar.Bitmap;
          TListItemImage(Objects.FindDrawable('Excluir')).Bitmap :=  ImageExcluir.Bitmap;
        end;

      DM.QueryUsuarios.Next;
    end;

  DM.FDConnexao.Close;
end;

procedure TFormMenu.FormCreate(Sender: TObject);
begin
  inherited;

  ImageEditar.Visible := False; //Esconde imagem de editar
  ImageExcluir.Visible := False; //Esconde imagem de editar
  ImageCancelar.Visible := False; //Esconde imagem de editar

  TabControlMenu.ActiveTab := TabMenu;
end;

procedure TFormMenu.FormShow(Sender: TObject);
begin
  inherited;

  Image_menu.Visible := False;
  Image_adicionar.Visible := False;
end;

procedure TFormMenu.Image1Click(Sender: TObject);
begin
  inherited;
  Label_Caption.Text := 'Menu Principal';

  // testar a posição
  if TabControlMenu.ActiveTab = TabMenu then
    begin
      UnitInicial.FormInicial := UnitInicial.TFormInicial.Create(Self);
      UnitInicial.FormInicial.Show;
      FormMenu.hide;
    end;

    if TabControlMenu.ActiveTab = TabConsultaEstabelecimento then
    begin
      TabControlMenu.ActiveTab := TabMenu;
    end;


    if TabControlMenu.ActiveTab = TabConsultaUsuarios then
    begin
      TabControlMenu.ActiveTab := TabMenu;
    end;


    if TabControlMenu.ActiveTab = TabEditEstabelecimento then
    begin
      TabControlMenu.ActiveTab := TabConsultaEstabelecimento;
    end;

    if TabControlMenu.ActiveTab = TabEditUsuario then
    begin
      TabControlMenu.ActiveTab := TabConsultaUsuarios;
    end;


  // testar os botoes
    if TabControlMenu.ActiveTab = TabConsultaEstabelecimento then
    begin
      Image_adicionar.Visible := True;
    end;

    if TabControlMenu.ActiveTab = TabMenu then
    begin
      Image_adicionar.Visible := False;
    end;

    if TabControlMenu.ActiveTab = TabConsultaUsuarios then
    begin
      Image_adicionar.Visible := True;
    end;


end;


procedure TFormMenu.Image3Click(Sender: TObject);
begin
  inherited;
  TabControlMenu.ActiveTab := TabMenu;
end;

procedure TFormMenu.ImageCancelarManUsuarioClick(Sender: TObject);
begin
  inherited;
  ShowMessage('Alterações canceladas!');
  TabControlMenu.ActiveTab := TabConsultaUsuarios;
end;

procedure TFormMenu.ImageVoltarManUsuarioClick(Sender: TObject);
begin
  inherited;
  TabControlMenu.ActiveTab := TabConsultaUsuarios;
end;

procedure TFormMenu.Image_adicionarClick(Sender: TObject);
begin
  inherited;

  if TabControlMenu.ActiveTab = TabConsultaEstabelecimento then
  begin
    ManutencaoEstabelecimento('0');
  end;


  if TabControlMenu.ActiveTab = TabConsultaUsuarios then
  begin
    ManutencaoUsuario('');
  end;
end;

procedure TFormMenu.Image_menuClick(Sender: TObject);
begin
  inherited;
  TabControlMenu.ActiveTab := TabMenu;
end;

procedure TFormMenu.Image_perfilClick(Sender: TObject);
begin
  inherited;
  Label_Caption.Text := 'Opções do Perfil';
  UnitPerfil.FormPerfil := UnitPerfil.TFormPerfil.Create(Self);
  UnitPerfil.FormPerfil.Show;
  FormMenu.hide;
end;

procedure TFormMenu.LabelConsutlarUsuariosClick(Sender: TObject);
begin
  inherited;
  Image_adicionar.Visible := True;
  Label_Caption.Text := 'Manutenção Usuários';
  AdicionaListViewUsuarios('',''); //Chama Procedure para buscar as informações na base
  TabControlMenu.ActiveTab := TabConsultaUsuarios; //Exibe a tela de consulta
end;

// Adiciona / Atualiza cadastro de usuário
procedure TFormMenu.Label_atualizar_cadastroClick(Sender: TObject);
begin
  inherited;

  if Edit_usuario_cadastro.Text = '' then
    begin
      ShowMessage('Informe o nome do Usuário...');
      abort;
    end;

  if Edit_usuario_cadastro.TagString <> '' then
    begin
      DM.Query.Close;
      DM.Query.SQL.Clear;
      DM.Query.SQL.Add(' update usuario ' +
                       '   set usuario = ' + QuotedStr(Edit_usuario_cadastro.Text) + ', ' +
                       '       nome  = ' + QuotedStr(Edit_nomecompleto.Text) + ', ' +
                       '       senha  = ' + QuotedStr( Dm.Criptografa('C',Edit_senha_cadastro.Text)) +
                       ' where usuario = ' + QuotedStr(Edit_usuario_cadastro.TagString));
      DM.Query.ExecSQL;
    end
  else
    begin
      DM.FDConnexao.Close;
      DM.FDConnexao.Open;
      DM.Query.Close;
      DM.Query.SQL.Clear;
      DM.Query.SQL.Add('INSERT INTO usuario (usuario,nome,senha) VALUES (:USUARIO,:NOME,:SENHA); ');
      DM.Query.ParamByName('USUARIO').AsString := Edit_usuario_cadastro.Text;
      DM.Query.ParamByName('NOME').AsString :=  Edit_nomecompleto.Text;
      DM.Query.ParamByName('SENHA').AsString :=  Dm.Criptografa('C',Edit_senha_cadastro.Text);
      DM.Query.ExecSQL;
    end;
   AdicionaListViewUsuarios('','');
  Image1Click(sender);
end;

procedure TFormMenu.ListView_consultaEstabelecimentoItemClickEx(
  const Sender: TObject;
  ItemIndex: Integer;
  const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  inherited;

  if ItemObject <> nil then    //Usuário clicou em algum objeto
  begin
    if ItemObject.Name = 'Editar' then
    begin
      ManutencaoEstabelecimento(ListView_consultaEstabelecimento.Items[ItemIndex].Tag.ToString);
    end;

    if ItemObject.Name = 'Excluir' then
    begin
      DM.FDConnexao.Connected := false;
      DM.FDConnexao.Connected := True;
      DM.Query.Close;
      DM.Query.SQL.Clear;
      DM.Query.SQL.Add(' delete from estabelecimento where id = ' + ListView_consultaEstabelecimento.Items[ItemIndex].Tag.ToString);
      DM.Query.ExecSQL;
      AdicionaListViewEstabelecimento('','');
    end;
  end;
end;

procedure TFormMenu.ListView_usuarioItemClickEx(const Sender: TObject; ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  inherited;

  if ItemObject <> nil then    //Usuário clicou em algum objeto
  begin
    if ItemObject.Name = 'Editar' then
    begin
      ManutencaoUsuario(ListView_usuario.Items[ItemIndex].TagString);
    end;

    if ItemObject.Name = 'Excluir' then
      begin
        DM.FDConnexao.Connected := false;
        DM.FDConnexao.Connected := True;
        DM.Query.Close;
        DM.Query.SQL.Clear;
        DM.Query.SQL.Add('delete from usuario where usuario = ' + QuotedStr(ListView_usuario.Items[ItemIndex].TagString));
        DM.Query.ExecSQL;
        AdicionaListViewUsuarios('','');
      end;
  end;
  DM.FDConnexao.Connected := false;
end;

procedure TFormMenu.ManutencaoEstabelecimento(id: string);
begin
  DM.FDConnexao.Connected := false;
  DM.FDConnexao.Connected := True;

  Image_adicionar.Visible := False;

  TabControlMenu.ActiveTab := TabEditEstabelecimento;

  if id <> '' then
    begin
      // entra para edição

      Label_Caption.Text := 'Manutenção de Estabelecimento';
      DM.Query.Close;
      DM.Query.SQL.Clear;
      DM.Query.SQL.Add(' select * from estabelecimento where id = ' + id);
      DM.Query.Open;

      Edit_nomeEstabelecimento.Tag := StrToInt(id);
      Edit_nomeEstabelecimento.Text := DM.Query.FieldByName('descricao').AsString;
      Edit_enderecoEstabelecimento.Text := DM.Query.FieldByName('endereco').AsString;
      Edit_telefoneEstabelecimento.Text := DM.Query.FieldByName('telefone').AsString;

      DM.Query.Close;
    end
    else
    begin
      // entro para inserir
      Label_Caption.Text := 'Cadastro de Estabelecimento';
      Edit_nomeEstabelecimento.Tag := 0;
      Edit_nomeEstabelecimento.Text := '';
      Edit_enderecoEstabelecimento.Text := '';
      Edit_telefoneEstabelecimento.Text := '';
    end;
    DM.FDConnexao.Connected := false;
end;


procedure TFormMenu.ManutencaoUsuario(id: string);
begin
  DM.FDConnexao.Connected := false;
  DM.FDConnexao.Connected := True;

  Image_adicionar.Visible := False;

  TabControlMenu.ActiveTab := TabEditUsuario;

  if id <> '' then
    begin
      // entra para edição
      Label_Caption.Text := 'Manutenção de Usuário';
      DM.Query.Close;
      DM.Query.SQL.Clear;
      DM.Query.SQL.Add('select * from usuario where usuario = ' + QuotedStr(id));
      DM.Query.Open;

      Edit_usuario_cadastro.TagString := id;
      Edit_nomecompleto.Text := DM.Query.FieldByName('nome').AsString;
      Edit_usuario_cadastro.Text := DM.Query.FieldByName('usuario').AsString;
      Edit_senha_cadastro.Text := dm.Criptografa('D',DM.Query.FieldByName('senha').AsString);
      DM.Query.Close;
    end
    else
    begin
      // entro para inserir
      Label_Caption.Text := 'Cadastro de Usuário';
      Edit_nomecompleto.Tag := 0;
      Edit_usuario_cadastro.Text := '';
      Edit_senha_cadastro.Text := '';
    end;
end;




function TFormMenu.ExecPergunta(vsPergunta: String): TModalResult;
var
  MR : TModalResult;
begin
   MessageDlg(vsPergunta,
              System.UITypes.TMsgDlgType.mtConfirmation,
              [System.UITypes.TMsgDlgBtn.mbYes, System.UITypes.TMsgDlgBtn.mbNo],
              0,
              procedure(const AResult: TModalResult)
              begin
                 MR:=AResult;
              end);

   while MR = mrNone do
     Application.ProcessMessages;
   Result := MR;
end;

procedure TFormMenu.RoundRect_salvarEstabelecimentoClick(Sender: TObject);
begin
  inherited;

  if Edit_nomeEstabelecimento.Text = '' then
    begin
      ShowMessage('Informe o nome do estabelecimento...');
      abort;
    end;

  if Edit_nomeEstabelecimento.Tag <> 0 then
    begin
      DM.Query.Close;
      DM.Query.SQL.Clear;
      DM.Query.SQL.Add(' update estabelecimento ' +
                       '   set descricao = ' + QuotedStr(Edit_nomeEstabelecimento.Text) + ', ' +
                       '       endereco  = ' + QuotedStr(Edit_enderecoEstabelecimento.Text) + ', ' +
                       '       telefone  = ' + QuotedStr(Edit_telefoneEstabelecimento.Text) +
                       ' where id = ' + Edit_nomeEstabelecimento.Tag.ToString);
      DM.Query.ExecSQL;
    end
  else
    begin
      DM.FDConnexao.Close;
      DM.FDConnexao.Open;
      DM.Query.Close;
      DM.Query.SQL.Clear;
      DM.Query.SQL.Add('INSERT INTO estabelecimento (descricao,endereco,telefone) VALUES (:NOME,:ENDERECO,:TELEFONE); ');
      DM.Query.ParamByName('NOME').AsString := Edit_nomeEstabelecimento.Text;
      DM.Query.ParamByName('ENDERECO').AsString := Edit_enderecoEstabelecimento.Text;
      DM.Query.ParamByName('TELEFONE').AsString :=  Edit_telefoneEstabelecimento.Text;
      DM.Query.ExecSQL;
    end;

  AdicionaListViewEstabelecimento('','');
  Image1Click(sender);
end;

procedure TFormMenu.LabelConsultarEstabelecimentoClick(Sender: TObject);
begin
  inherited;
  Image_adicionar.Visible := True;
  Label_Caption.Text := 'Manutenção Estabelecimento';
  AdicionaListViewEstabelecimento('',''); //Chama Procedure para buscar as informações na base
  TabControlMenu.ActiveTab := TabConsultaEstabelecimento; //Exibe a tela de consulta
end;

procedure TFormMenu.LabelConsultarProdutosClick(Sender: TObject);
begin
  inherited;
  Showmessage('Em breve...');
end;

end.
