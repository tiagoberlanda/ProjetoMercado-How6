unit UnitEstabelecimento;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UnitTemplate, FMX.Controls.Presentation, FMX.Layouts, FMX.Objects,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.TabControl, FMX.Edit,fmx.DialogService;

type
  TFormEstabelecimento = class(TFormTemplate)
    Image_voltar: TImage;
    Image_adicionar: TImage;
    Layout_centralConsultaEstabelecimento: TLayout;
    ListView_consultaEstabelecimento: TListView;
    TabControlEstabelecimento: TTabControl;
    TabConsulta: TTabItem;
    TabEdicao: TTabItem;
    Layout_central_Edit: TLayout;
    RoundRect_nome: TRoundRect;
    Edit_nome: TEdit;
    RoundRect_endereco: TRoundRect;
    Edit_endereco: TEdit;
    RoundRect_telefone: TRoundRect;
    Edit_telefone: TEdit;
    ImageEditar: TImage;
    ImageExcluir: TImage;
    StyleBook1: TStyleBook;
    Image_confirmar: TImage;
    procedure Image_voltarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListView_consultaEstabelecimentoItemClickEx(const Sender: TObject;
      ItemIndex: Integer; const LocalClickPos: TPointF;
      const ItemObject: TListItemDrawable);
    procedure Image_adicionarClick(Sender: TObject);
    procedure Label_salvarClick(Sender: TObject);
    procedure Image_confirmarClick(Sender: TObject);
  private
    { Private declarations }
    procedure AdicionaListViewEstabelecimento(id, estabelecimento: string);
    procedure ManutencaoEstabelecimento(id: integer);
  public
    { Public declarations }
  end;

var
  FormEstabelecimento: TFormEstabelecimento;

implementation

{$R *.fmx}

uses UnitInicial, UnitData;


procedure TFormEstabelecimento.AdicionaListViewEstabelecimento(id, estabelecimento: string);
begin
  ListView_consultaEstabelecimento.Items.Clear;

  DM.FDConnexao.Close;
  DM.FDConnexao.Open;
  DM.Query.Close;
  Dm.Query.SQL.Clear;
  Dm.Query.SQL.Add('Select id,descricao FROM estabelecimento');
  Dm.Query.Open;
  while not DM.Query.Eof do
    begin
      id := DM.Query.FieldByName('id').AsString;
      estabelecimento := DM.Query.FieldByName('descricao').AsString;

      with ListView_consultaEstabelecimento.Items.Add do
        begin
          Tag := StrToInt(id);

          TListItemText(Objects.FindDrawable('Linha')).Text := id + ' | ' + estabelecimento;
          TListItemImage(Objects.FindDrawable('Editar')).Bitmap :=  ImageEditar.Bitmap;
          TListItemImage(Objects.FindDrawable('Excluir')).Bitmap :=  ImageExcluir.Bitmap;
        end;

      DM.Query.Next;
    end;

  DM.FDConnexao.Close;
end;


procedure TFormEstabelecimento.ManutencaoEstabelecimento(id: integer);
begin
  DM.FDConnexao.Connected := false;
  DM.FDConnexao.Connected := True;


  TabControlEstabelecimento.ActiveTab := TabEdicao;

  if id <> 0 then
    begin
      // entra para edição
      DM.Query.Close;
      DM.Query.SQL.Clear;
      DM.Query.SQL.Add(' select * from estabelecimento where id = ' + inttostr(id));
      DM.Query.Open;

      Edit_nome.Tag := id;
      Edit_nome.Text := DM.Query.FieldByName('descricao').AsString;
      Edit_endereco.Text := DM.Query.FieldByName('endereco').AsString;
      Edit_telefone.Text := DM.Query.FieldByName('telefone').AsString;

      DM.Query.Close;
    end
    else
    begin
      // entro para inserir
      Edit_nome.Tag := 0;
      Edit_nome.Text := '';
      Edit_endereco.Text := '';
      Edit_telefone.Text := '';
    end;
    DM.FDConnexao.Connected := false;
end;


procedure TFormEstabelecimento.FormCreate(Sender: TObject);
begin
  inherited;
  // Esconde itens
  ImageEditar.Visible := False;
  ImageExcluir.Visible := False;
  Image_confirmar.Visible := False;

  // Adiciona Informações na Tela
  AdicionaListViewEstabelecimento('','');

  //Tela Padrao
  TabControlEstabelecimento.ActiveTab := TabConsulta;
end;

procedure TFormEstabelecimento.Image_adicionarClick(Sender: TObject);
begin
  inherited;
  ManutencaoEstabelecimento(0);
  Image_adicionar.Visible := False;
  Image_confirmar.Visible := True;
end;

procedure TFormEstabelecimento.Image_confirmarClick(Sender: TObject);
begin
  inherited;
  //Validação de Digitação dos campos
  if (Edit_nome.text <> '' ) and (Edit_endereco.Text <> '') and
      (Edit_telefone.Text <> '') then
  begin
    if Edit_nome.Tag = 0 then  //Caso seja um novo cadastro
    begin
      UnitData.DM.InserirEstabelecimento(Edit_nome.text, Edit_endereco.Text,Edit_telefone.text);
      ShowMessage('Cadastro realizado com sucesso!');
      AdicionaListViewEstabelecimento('','');
      TabControlEstabelecimento.ActiveTab := TabConsulta;
      Image_adicionar.Visible := True;
      Image_confirmar.Visible := False;
      //Zera Valores dos Edits e a TagString
      Edit_nome.Tag := 0;
      Edit_nome.Text := '';
      Edit_endereco.Text := '';
      Edit_telefone.Text := '';
    end
    else    //Caso seja edição de cadastro
    begin
    DM.FDConnexao.Close;
      DM.FDConnexao.Open;
      DM.Query.Close;
      DM.Query.SQL.Clear;
      DM.Query.SQL.Add('UPDATE estabelecimento SET descricao = :nome, endereco = :endereco,' +
      'telefone = :telefone WHERE id = :id');
      DM.Query.ParamByName('nome').AsString := Edit_nome.Text;
      DM.Query.ParamByName('endereco').AsString := Edit_endereco.Text;
      DM.Query.ParamByName('telefone').AsString := Edit_telefone.Text;
      DM.Query.ParamByName('id').AsInteger := Edit_nome.Tag;
      Dm.Query.ExecSQL;

      ShowMessage('Cadastro Atualizado com Sucesso!');
      AdicionaListViewEstabelecimento('','');
      TabControlEstabelecimento.ActiveTab := TabConsulta;
      Image_adicionar.Visible := True;
      Image_confirmar.Visible := False;
      //Zera Valores dos Edits e a TagString
      Edit_nome.Tag := 0;
      Edit_nome.Text := '';
      Edit_endereco.Text := '';
      Edit_telefone.Text := '';
    end;
  end
  else
  begin
    ShowMessage('Preencha todas as informações!');
  end;

end;

procedure TFormEstabelecimento.Image_voltarClick(Sender: TObject);
begin
  if TabControlEstabelecimento.ActiveTab = TabEdicao then
  begin
    TabControlEstabelecimento.ActiveTab := TabConsulta;
    Image_adicionar.Visible := True;
    Image_confirmar.Visible := False;

    //Zera Valores dos Edits e a TagString
    Edit_nome.Tag := 0;
    Edit_nome.Text := '';
    Edit_endereco.Text := '';
    Edit_telefone.Text := '';
  end
  else
  begin
    FormInicial := TFormInicial.Create(Self);
    FormEstabelecimento.close;
    FormInicial.show;
  end;
end;

procedure TFormEstabelecimento.Label_salvarClick(Sender: TObject);
begin
  inherited;
  //Validação de Digitação dos campos
  if (Edit_nome.text <> '' ) and (Edit_endereco.Text <> '') and
      (Edit_telefone.Text <> '') then
  begin
    if Edit_nome.Tag = 0 then  //Caso seja um novo cadastro
    begin
      UnitData.DM.InserirEstabelecimento(Edit_nome.text, Edit_endereco.Text,Edit_telefone.text);
      ShowMessage('Cadastro realizado com sucesso!');
      AdicionaListViewEstabelecimento('','');
      TabControlEstabelecimento.ActiveTab := TabConsulta;
    end
    else    //Caso seja edição de cadastro
    begin
    DM.FDConnexao.Close;
      DM.FDConnexao.Open;
      DM.Query.Close;
      DM.Query.SQL.Clear;
      DM.Query.SQL.Add('UPDATE estabelecimento SET descricao = :nome, endereco = :endereco,' +
      'telefone = :telefone WHERE id = :id');
      DM.Query.ParamByName('nome').AsString := Edit_nome.Text;
      DM.Query.ParamByName('endereco').AsString := Edit_endereco.Text;
      DM.Query.ParamByName('telefone').AsString := Edit_telefone.Text;
      DM.Query.ParamByName('id').AsInteger := Edit_nome.Tag;
      Dm.Query.ExecSQL;

      ShowMessage('Cadastro Atualizado com Sucesso!');
      AdicionaListViewEstabelecimento('','');
      TabControlEstabelecimento.ActiveTab := TabConsulta;
    end;
  end
  else
  begin
    ShowMessage('Preencha todas as informações!');
  end;

end;

procedure TFormEstabelecimento.ListView_consultaEstabelecimentoItemClickEx(
  const Sender: TObject; ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  inherited;
 if ItemObject <> nil then    //Usuário clicou em algum objeto
  begin
    if ItemObject.Name = 'Editar' then
    begin
      ManutencaoEstabelecimento(ListView_consultaEstabelecimento.Items[ItemIndex].Tag);
      Image_adicionar.Visible := False;
      Image_confirmar.Visible := True;
    end;

    if ItemObject.Name = 'Excluir' then
    begin
    // Confirmação de Exclusão
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
            DM.Query.SQL.Add(' delete from estabelecimento where id = ' + ListView_consultaEstabelecimento.Items[ItemIndex].Tag.ToString);
            DM.Query.ExecSQL;

            AdicionaListViewEstabelecimento('','');

          end;
        end);

      end;
  end;
end;

end.
