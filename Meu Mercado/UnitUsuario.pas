unit UnitUsuario;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UnitTemplate, FMX.Controls.Presentation, FMX.Objects, FMX.Layouts,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.TabControl, FMX.Edit, fmx.DialogService;

type
  TFormUsuario = class(TFormTemplate)
    Layout_centConsutaUsuario: TLayout;
    ListView_usuario: TListView;
    Image_voltar: TImage;
    Image_adicionar: TImage;
    TabControlUsuario: TTabControl;
    TabConsulta: TTabItem;
    TabEdicao: TTabItem;
    Layout_central_cadastro: TLayout;
    RoundRect_nomecompleto: TRoundRect;
    Edit_nomecompleto: TEdit;
    RoundRect_usuario: TRoundRect;
    Edit_usuario_cadastro: TEdit;
    RoundRect_senha: TRoundRect;
    Edit_senha_cadastro: TEdit;
    ImageExcluir: TImage;
    ImageEditar: TImage;
    StyleBook1: TStyleBook;
    CheckBoxSenha: TCheckBox;
    Image_confirmar: TImage;
    procedure Image_voltarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListView_usuarioItemClickEx(const Sender: TObject;
      ItemIndex: Integer; const LocalClickPos: TPointF;
      const ItemObject: TListItemDrawable);
    procedure Image_adicionarClick(Sender: TObject);
    procedure Label_salvarClick(Sender: TObject);
    procedure CheckBoxSenhaChange(Sender: TObject);
    procedure Image_confirmarClick(Sender: TObject);
  private
    { Private declarations }
    procedure AdicionaListViewUsuarios(usuario,nome: string);
    procedure ManutencaoUsuario(id: string);
  public
    { Public declarations }
  end;

var
  FormUsuario: TFormUsuario;

implementation

{$R *.fmx}

uses UnitInicial, UnitData;

// Adiciona Itens no List View Usuários
procedure TFormUsuario.AdicionaListViewUsuarios(usuario,nome: string);
begin
  ListView_usuario.Items.Clear;

  DM.FDConnexao.Close;
  DM.FDConnexao.Open;

  DM.Query.Close; //Executa a Query de Consultar Usuários
  DM.Query.sql.Clear;
  DM.Query.SQL.Add(' select * from usuario order by usuario ');
  DM.Query.Open;

  while not DM.Query.Eof do
    begin
      usuario := DM.Query.FieldByName('usuario').AsString;
      nome := DM.Query.FieldByName('nome').AsString;

      with ListView_usuario.Items.Add do
        begin
          TagString := usuario;

          TListItemText(Objects.FindDrawable('Linha')).Text := usuario + ' | ' + nome;
          TListItemImage(Objects.FindDrawable('Editar')).Bitmap :=  ImageEditar.Bitmap;
          TListItemImage(Objects.FindDrawable('Excluir')).Bitmap :=  ImageExcluir.Bitmap;
        end;

      DM.Query.Next;
    end;

  DM.FDConnexao.Close;
end;


procedure TFormUsuario.ManutencaoUsuario(id: string);
begin
  DM.FDConnexao.Connected := false;
  DM.FDConnexao.Connected := True;

  TabControlUsuario.ActiveTab := TabEdicao;

  if id <> '' then
    begin
      // entra para edição
      DM.Query.Close;
      DM.Query.SQL.Clear;
      DM.Query.SQL.Add('select * from usuario where usuario =' + QuotedStr(id));
      DM.Query.Open;

      Edit_usuario_cadastro.TagString := id;
      Edit_nomecompleto.Text := DM.Query.FieldByName('nome').AsString;
      Edit_usuario_cadastro.Text := DM.Query.FieldByName('usuario').AsString;
      Edit_senha_cadastro.Text := dm.Criptografa('D',DM.Query.FieldByName('senha').AsString);
      DM.Query.Close;
      //Zera tagString, evita bugs
      Edit_nomecompleto.TagString := '';
    end
    else
    begin
      // entro para inserir
      Edit_nomecompleto.TagString := '';
      Edit_nomecompleto.Text := '';
      Edit_usuario_cadastro.Text := '';
      Edit_senha_cadastro.Text := '';
    end;
end;



procedure TFormUsuario.CheckBoxSenhaChange(Sender: TObject);
begin
  Edit_senha_cadastro.Password := not Edit_senha_cadastro.Password;
end;

procedure TFormUsuario.FormCreate(Sender: TObject);
begin
  inherited;
  //Esconder Imagens
  ImageEditar.Visible := False;
  ImageExcluir.Visible := False;
  Image_confirmar.Visible := False;

  //Exibe informações na tela
  AdicionaListViewUsuarios('','');

  //Tela Padrao
  TabControlUsuario.ActiveTab := TabConsulta;
end;

procedure TFormUsuario.Image_adicionarClick(Sender: TObject);
begin
  inherited;
  ManutencaoUsuario('');
  Edit_usuario_cadastro.Enabled := True; //Desabilita Edit Usuario
  Image_adicionar.Visible := False;
  Image_confirmar.Visible := True;
end;

procedure TFormUsuario.Image_confirmarClick(Sender: TObject);
begin
  inherited;
  // Novo Registro
  if Edit_usuario_cadastro.TagString = '' then
  begin
      if (Edit_nomecompleto.Text <> '') and     //Valida se foi digitado informação
      (Edit_senha_cadastro.Text <> '') and (Edit_usuario_cadastro.Text <> '') then
      begin
        if UnitData.DM.ValidarCadastro(Edit_usuario_cadastro.Text) then  //Se retornar True é porque o usuário existe
        begin
          ShowMessage('Usuário já existente, use outro e tente novamene.');
          Edit_nomecompleto.Text := '';    // Se o usuário já existir irá apagar o que foi digitado nos Edits
          Edit_senha_cadastro.Text := '';
          Edit_usuario_cadastro.Text := '';
        end
        else
        begin
          UnitData.DM.InserirUsuario(Edit_usuario_cadastro.Text,Edit_senha_cadastro.Text,Edit_nomecompleto.Text);
          ShowMessage('Cadastro Feito Com sucesso!');
          AdicionaListViewUsuarios('','');
          TabControlUsuario.ActiveTab := TabConsulta;
          Image_adicionar.Visible := True;
          Image_confirmar.Visible := False;
        end;
        end
        else
        begin
          ShowMessage('Preencha Todas as informações!');
        end;
  end
  //Edicao de Registro
  else
  begin
    if (Edit_nomecompleto.Text <> '') and     //Valida se foi digitado informação
      (Edit_senha_cadastro.Text <> '') and (Edit_usuario_cadastro.Text <> '') then
      begin
        DM.FDConnexao.Close;
        DM.FDConnexao.Open;
        DM.Query.Close;
        DM.Query.Open;
        Dm.Query.SQL.Clear;
        Dm.Query.SQL.Add('UPDATE usuario SET nome = :nome,senha = :senha WHERE usuario = :usuario');
        DM.Query.ParamByName('usuario').AsString := Edit_usuario_cadastro.TagString;
        DM.Query.ParamByName('nome').AsString := Edit_nomecompleto.Text;
        DM.Query.ParamByName('senha').AsString := dm.Criptografa('C', Edit_senha_cadastro.Text);
        Dm.Query.ExecSQL;
        ShowMessage('Cadastro Atualizado Com sucesso!');
        AdicionaListViewUsuarios('','');
        TabControlUsuario.ActiveTab := TabConsulta;
        Image_adicionar.Visible := True;
        Image_confirmar.Visible := False;
      end
      else
      begin
       ShowMessage('Preencha Todas as informações!');
      end;
  end;
end;

procedure TFormUsuario.Image_voltarClick(Sender: TObject);
begin
  inherited;
  if TabControlUsuario.ActiveTab = TabEdicao then
  begin
    TabControlUsuario.ActiveTab := TabConsulta;
    Image_adicionar.Visible := True;
    Image_confirmar.Visible := False;

    //Zera Valores dos Edits e a TagString
    Edit_nomecompleto.TagString := '';
    Edit_nomecompleto.Text := '';
    Edit_usuario_cadastro.Text := '';
    Edit_senha_cadastro.Text := '';
  end
  else
  begin
    FormInicial := TFormInicial.Create(Self);
    FormUsuario.close;
    FormInicial.show;
  end;
end;

procedure TFormUsuario.Label_salvarClick(Sender: TObject);
begin
  inherited;
  // Novo Registro
  if Edit_usuario_cadastro.TagString = '' then
  begin
      if (Edit_nomecompleto.Text <> '') and     //Valida se foi digitado informação
      (Edit_senha_cadastro.Text <> '') and (Edit_usuario_cadastro.Text <> '') then
      begin
        if UnitData.DM.ValidarCadastro(Edit_usuario_cadastro.Text) then  //Se retornar True é porque o usuário existe
        begin
          ShowMessage('Usuário já existente, use outro e tente novamene.');
          //Limpa o conteúdo das Edits
          Edit_nomecompleto.Text := '';    // Se o usuário já existir irá apagar o que foi digitado nos Edits
          Edit_senha_cadastro.Text := '';
          Edit_usuario_cadastro.Text := '';
        end
        else
        begin
          UnitData.DM.InserirUsuario(Edit_usuario_cadastro.Text,Edit_senha_cadastro.Text,Edit_nomecompleto.Text);
          ShowMessage('Cadastro Feito Com sucesso!');
          AdicionaListViewUsuarios('','');
          TabControlUsuario.ActiveTab := TabConsulta;

          //Limpa o conteúdo das Edits
          Edit_nomecompleto.Text := '';
          Edit_senha_cadastro.Text := '';
          Edit_usuario_cadastro.Text := '';
        end;
        end
        else
        begin
          ShowMessage('Preencha Todas as informações!');
        end;
  end
  //Edicao de Registro
  else
  begin
    if (Edit_nomecompleto.Text <> '') and     //Valida se foi digitado informação
      (Edit_senha_cadastro.Text <> '') and (Edit_usuario_cadastro.Text <> '') then
      begin
        DM.FDConnexao.Close;
        DM.FDConnexao.Open;
        DM.Query.Close;
        DM.Query.Open;
        Dm.Query.SQL.Clear;
        Dm.Query.SQL.Add('UPDATE usuario SET nome = :nome,senha = :senha WHERE usuario = :usuario');
        DM.Query.ParamByName('usuario').AsString := Edit_usuario_cadastro.TagString;
        DM.Query.ParamByName('nome').AsString := Edit_nomecompleto.Text;
        DM.Query.ParamByName('senha').AsString := dm.Criptografa('C', Edit_senha_cadastro.Text);
        Dm.Query.ExecSQL;
        ShowMessage('Cadastro Atualizado Com sucesso!');
        AdicionaListViewUsuarios('','');
        TabControlUsuario.ActiveTab := TabConsulta;
        //Limpa o conteúdo das Edits
        Edit_nomecompleto.Text := '';
        Edit_senha_cadastro.Text := '';
        Edit_usuario_cadastro.Text := '';
      end
      else
      begin
       ShowMessage('Preencha Todas as informações!');
      end;
  end;


end;

procedure TFormUsuario.ListView_usuarioItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  inherited;
 if ItemObject <> nil then    //Usuário clicou em algum objeto
  begin
    if ItemObject.Name = 'Editar' then
    begin
      ManutencaoUsuario(ListView_usuario.Items[ItemIndex].TagString);
      Edit_usuario_cadastro.Enabled := False;
      Image_adicionar.Visible := False;
      Image_confirmar.Visible := True;
    end;

    if ItemObject.Name = 'Excluir' then
      begin
      // Lembra de declarar no uses: fmx.DialogService
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
            DM.Query.SQL.Add('delete from usuario where usuario = ' + QuotedStr(ListView_usuario.Items[ItemIndex].TagString));
            DM.Query.ExecSQL;
            AdicionaListViewUsuarios('','');
          end;
        end);

      end;
  end;
end;

end.
