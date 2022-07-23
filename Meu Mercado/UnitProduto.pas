unit UnitProduto;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UnitTemplate, FMX.Controls.Presentation, FMX.Layouts, FMX.Objects,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.Edit, FMX.ListView, FMX.TabControl, FMX.ListBox, FMX.Memo.Types,
  FMX.ScrollBox, FMX.Memo,fmx.DialogService;

type
  TFormProduto = class(TFormTemplate)
    Image_voltar: TImage;
    Image_adicionar: TImage;
    TabControlProduto: TTabControl;
    TabConsulta: TTabItem;
    Layout_centConsutaProduto: TLayout;
    ListView_produto: TListView;
    TabEdicao: TTabItem;
    Layout_central_cadastro: TLayout;
    RoundRect_nomecompleto: TRoundRect;
    Edit_nomeProduto: TEdit;
    StyleBook1: TStyleBook;
    ImageExcluir: TImage;
    ImageEditar: TImage;
    RoundRect_categoria: TRoundRect;
    Layout1: TLayout;
    ComboBox_cateoria: TComboBox;
    Memo_descricao: TMemo;
    Label1: TLabel;
    Image_confirmar: TImage;
    Layout2: TLayout;
    ToolBar1: TToolBar;
    ListView_Preco: TListView;
    Label2: TLabel;
    Image_adicionarPreco: TImage;
    Label3: TLabel;
    procedure Image_voltarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label_SalvarClick(Sender: TObject);
    procedure Image_adicionarClick(Sender: TObject);
    procedure ListView_produtoItemClickEx(const Sender: TObject;
      ItemIndex: Integer; const LocalClickPos: TPointF;
      const ItemObject: TListItemDrawable);
    procedure Image_confirmarClick(Sender: TObject);
    procedure Image_adicionarPrecoClick(Sender: TObject);
    procedure ListView_PrecoItemClickEx(const Sender: TObject;
      ItemIndex: Integer; const LocalClickPos: TPointF;
      const ItemObject: TListItemDrawable);
  private
    procedure AdicionaListViewProduto(id, produto: string);
    procedure ManutencaoProduto(id: integer);
    procedure AdicionaListViewPreco(idproduto: string);
    { Private declarations }
  public
    viSelProduto, viSelEstab : Integer;
    { Public declarations }
  end;

var
  FormProduto: TFormProduto;

implementation

{$R *.fmx}

uses UnitInicial, UnitData, UnitPreco;

procedure TFormProduto.FormCreate(Sender: TObject);
begin
  inherited;
  //Esconde Imagens
  ImageEditar.Visible := False;
  ImageExcluir.Visible := False;
  Image_confirmar.Visible := False;

  // Adiciona Informações na Tela
  AdicionaListViewProduto('','');

  //Define Tab Padrao
  TabControlProduto.ActiveTab := TabConsulta;
end;


procedure TFormProduto.ManutencaoProduto(id: integer);
begin
  DM.FDConnexao.Connected := false;
  DM.FDConnexao.Connected := True;

  TabControlProduto.ActiveTab := TabEdicao;

  if id <> 0 then
    begin
      // entra para edição
      DM.Query.Close;
      DM.Query.SQL.Clear;
      DM.Query.SQL.Add('select * from produto where id =' + IntToStr(id));
      Edit_nomeProduto.tag := id;
      DM.Query.Open();
      Edit_nomeProduto.Text := DM.Query.FieldByName('nome').AsString;
      Memo_descricao.Lines.Add(DM.Query.FieldByName('descricao').AsString);
      ComboBox_cateoria.ItemIndex := DM.Query.FieldByName('categoria').AsInteger;
    end
    else
    begin
      // entro para inserir
      Edit_nomeProduto.TagString := '';
      ComboBox_cateoria.ItemIndex := 0;
      Memo_descricao.Lines.Clear;
    end;

    DM.Query.Close;
    DM.FDConnexao.Connected := false;
end;

procedure TFormProduto.Image_adicionarPrecoClick(Sender: TObject);
begin
  inherited;
 //Instancia o FormPreco
 FormPreco := TFormPreco.Create(Self);
 DM.FDConnexao.Close;
 DM.FDConnexao.open;
 DM.Query.Close;
 DM.Query.SQL.Clear;
 DM.Query.SQL.Add(' select id, descricao from estabelecimento order by descricao ');
 DM.Query.Open;

 FormPreco.ComboBox_Estabelecimento.Items.Clear; //limpa combobox estabelecimento

 FormPreco.Edit_nomeProduto.Text := Edit_nomeProduto.Text;   //Leva o nome do produto
 FormPreco.Edit_nomeProduto.Tag := viSelProduto;   //leva a tag do produto
 FormPreco.Image_confirmar.tag := 0;
 //Adiciona estabelecimentos no combo box
 while not DM.Query.Eof do
 begin
   FormPreco.ComboBox_Estabelecimento.Items.Add(DM.Query.FieldByName('id').AsString + ' | ' + DM.Query.FieldByName('descricao').AsString);
   DM.Query.Next;
 end;

 FormProduto.close;
 FormPreco.show;
end;

procedure TFormProduto.Image_adicionarClick(Sender: TObject);
begin
  inherited;
  ListView_Preco.Items.Clear;
  ManutencaoProduto(0);
  Image_adicionar.Visible := False;
  Image_confirmar.Visible := True;

  //Esconde barra de adição pois não é possivel cadastrar preco se o produto ainda não foi cadastrado

  ToolBar1.Visible := False;

  //Zera valor do Edit
  Edit_nomeProduto.text := '';

  //Zera valor do combo box
  ComboBox_cateoria.ItemIndex := 0;
end;

procedure TFormProduto.Image_confirmarClick(Sender: TObject);
begin
  inherited;
  //Validação de Digitação dos campos
  if (Edit_nomeProduto.text <> '' ) and (ComboBox_cateoria.ItemIndex <> 0) then
  begin
    if Edit_nomeProduto.Tag = 0 then  //Caso seja um novo cadastro
    begin
      UnitData.DM.InserirProduto(Edit_nomeProduto.text,
      ComboBox_cateoria.ItemIndex.ToString,Memo_descricao.Lines.text);
      ShowMessage('Cadastro realizado com sucesso!');
      AdicionaListViewProduto('','');
      TabControlProduto.ActiveTab := TabConsulta;

      //Zera Valores dos Edits
      Edit_nomeProduto.Text := '';
      ComboBox_cateoria.ItemIndex := 0;
      Memo_descricao.Lines.clear;
    end
    else    //Caso seja edição de cadastro
    begin
      DM.FDConnexao.Close;
      DM.FDConnexao.Open;
      DM.Query.Close;
      DM.Query.SQL.Clear;
      DM.Query.SQL.Add('UPDATE produto SET nome = :nome, categoria = :categoria,' +
      'descricao = :descricao WHERE id = :id');
      DM.Query.ParamByName('nome').AsString := Edit_nomeProduto.Text;
      DM.Query.ParamByName('categoria').AsInteger := ComboBox_cateoria.ItemIndex;
      DM.Query.ParamByName('descricao').AsString := Memo_descricao.Lines.Text;
      DM.Query.ParamByName('id').AsInteger := Edit_nomeProduto.Tag;
      Dm.Query.ExecSQL;

      ShowMessage('Cadastro Atualizado com Sucesso!');
      AdicionaListViewProduto('','');
      TabControlProduto.ActiveTab := TabConsulta;

      //Zera Valores dos Edits
      Edit_nomeProduto.Text := '';
      ComboBox_cateoria.ItemIndex := 0;
      Memo_descricao.Lines.clear;
    end;
  end
  else
  begin
    ShowMessage('Preencha todas as informações!');
  end;
end;

procedure TFormProduto.Image_voltarClick(Sender: TObject);
begin
  if TabControlProduto.ActiveTab = TabEdicao then
  begin
    TabControlProduto.ActiveTab := TabConsulta;
    Image_adicionar.Visible := True;
    Image_confirmar.Visible := False;
  end
  else
  begin
    FormInicial := TFormInicial.Create(Self);
    FormProduto.close;
    FormInicial.show;
  end;
end;

procedure TFormProduto.Label_SalvarClick(Sender: TObject);
begin
  inherited;
  //Validação de Digitação dos campos
  if (Edit_nomeProduto.text <> '' ) and (ComboBox_cateoria.ItemIndex <> 0) then
  begin
    if Edit_nomeProduto.Tag = 0 then  //Caso seja um novo cadastro
    begin
      UnitData.DM.InserirProduto(Edit_nomeProduto.text,
      ComboBox_cateoria.ItemIndex.ToString,Memo_descricao.Lines.text);
      ShowMessage('Cadastro realizado com sucesso!');
      AdicionaListViewProduto('','');
      TabControlProduto.ActiveTab := TabConsulta;

      //Zera Valores dos Edits
      Edit_nomeProduto.Text := '';
      ComboBox_cateoria.ItemIndex := 0;
      Memo_descricao.Lines.clear;
    end
    else    //Caso seja edição de cadastro
    begin
      DM.FDConnexao.Close;
      DM.FDConnexao.Open;
      DM.Query.Close;
      DM.Query.SQL.Clear;
      DM.Query.SQL.Add('UPDATE produto SET nome = :nome, categoria = :categoria,' +
      'descricao = :descricao WHERE id = :id');
      DM.Query.ParamByName('nome').AsString := Edit_nomeProduto.Text;
      DM.Query.ParamByName('categoria').AsInteger := ComboBox_cateoria.ItemIndex;
      DM.Query.ParamByName('descricao').AsString := Memo_descricao.Lines.Text;
      DM.Query.ParamByName('id').AsInteger := Edit_nomeProduto.Tag;
      Dm.Query.ExecSQL;

      ShowMessage('Cadastro Atualizado com Sucesso!');
      AdicionaListViewProduto('','');
      TabControlProduto.ActiveTab := TabConsulta;

      //Zera Valores dos Edits
      Edit_nomeProduto.Text := '';
      ComboBox_cateoria.ItemIndex := 0;
      Memo_descricao.Lines.clear;
    end;
  end
  else
  begin
    ShowMessage('Preencha todas as informações!');
  end;

end;

procedure TFormProduto.ListView_PrecoItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
var
  viSeq : Integer;
begin
  inherited;

  viSelEstab := ListView_Preco.Items[ItemIndex].Tag;

  if ItemObject <> nil then    //Usuário clicou em algum objeto
  begin
    if ItemObject.Name = 'editar' then
    begin
      FormPreco := TFormPreco.Create(Self);
      FormProduto.close;

      DM.Query.Close;
      DM.Query.SQL.Clear;
      DM.Query.SQL.Add(' select id, descricao from estabelecimento order by descricao ');
      DM.Query.Open;

      FormPreco.ComboBox_Estabelecimento.Items.Clear;
      FormPreco.Image_confirmar.tag := 1;
      viSeq := 0;

      //Adiciona informação no combo box estabelecimento
      while not DM.Query.Eof do
      begin
        FormPreco.ComboBox_Estabelecimento.Items.Add(DM.Query.FieldByName('id').AsString + ' | ' + DM.Query.FieldByName('descricao').AsString);

        // preenchendo o combo, e quando a descrição for do item clicado gravar o id
        if DM.Query.FieldByName('id').AsInteger = viSelEstab then
          DM.Query.Tag := viSeq;

        DM.Query.Next;
        viSeq := viSeq + 1;
      end;

      FormPreco.ComboBox_Estabelecimento.ItemIndex := DM.Query.Tag;

      // preencher os outros campos
      DM.Query.Close;
      DM.Query.SQL.Clear;
      DM.Query.SQL.Add(' SELECT ESTABELECIMENTO.id AS ESTAB_COD, ESTABELECIMENTO.descricao AS ESTAB_DESC, ' +
                       '        PRODUTO.id AS PROD_COD, PRODUTO.nome AS PROD_dESC, ' +
                       '        PRECO.valor ' +
                       ' FROM PRECO, ESTABELECIMENTO, PRODUTO ' +
                       ' WHERE PRODUTO.id = PRECO.id_produto ' +
                       '   and ESTABELECIMENTO.id = ' + IntToStr(viSelEstab) +
                       '   and PRODUTO.id = ' + IntToStr(viSelProduto) +
                       '   AND ESTABELECIMENTO.id = PRECO.id_estabelecimento ' +
                       ' order by ESTABELECIMENTO.descricao ');
      DM.Query.Open;

      FormPreco.Edit_nomeProduto.Text := DM.Query.FieldByName('PROD_dESC').AsString;
      FormPreco.Edit_nomeProduto.Tag := DM.Query.FieldByName('PROD_COD').AsInteger;
      FormPreco.Edit_Preco.Text := DM.Query.FieldByName('valor').AsString;

      FormPreco.show;
    end;

    if ItemObject.Name = 'excluir' then
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
            DM.Query.SQL.Add('delete from preco where id_produto = :id_produto and ' +
            'id_estabelecimento = :id_estabelecimento');
            DM.Query.ParamByName('id_produto').AsInteger := viSelProduto;
            DM.Query.ParamByName('id_estabelecimento').AsInteger := viSelEstab;
            DM.Query.ExecSQL;
            AdicionaListViewPreco(viSelProduto.ToString);
          end;
        end);

      end;
  end;
end;

procedure TFormProduto.ListView_produtoItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  inherited;
if ItemObject <> nil then    //Usuário clicou em algum objeto
  begin
    viSelProduto := ListView_produto.Items[ItemIndex].Tag;

    if ItemObject.Name = 'Editar' then
    begin
      ManutencaoProduto(ListView_produto.Items[ItemIndex].Tag);
      AdicionaListViewPreco(ListView_produto.Items[ItemIndex].Tag.ToString);
      Image_adicionar.Visible := False;
      Image_confirmar.Visible := True;
      ToolBar1.Visible := True;
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
            DM.Query.SQL.Add('delete from produto where id = '+ ListView_produto.Items[ItemIndex].Tag.ToString);
            DM.Query.ExecSQL;
            AdicionaListViewProduto('','');
          end;
        end);

      end;
  end;
end;

procedure TFormProduto.AdicionaListViewPreco(idproduto: string);
begin
  ListView_Preco.Items.Clear;

  DM.FDConnexao.Close;
  DM.FDConnexao.Open;
  DM.Query.Close;
  Dm.Query.SQL.Clear;
  Dm.Query.SQL.Add('SELECT ESTABELECIMENTO.id AS ESTAB_COD, ESTABELECIMENTO.descricao AS ESTAB_DESC, ' +
                   '       PRODUTO.id AS PROD_COD, PRODUTO.descricao AS PROD_dESC, ' +
                   '       PRECO.valor ' +
                   ' FROM PRECO, ESTABELECIMENTO, PRODUTO ' +
                   ' WHERE PRODUTO.id = ' + idproduto +
                   '   and PRODUTO.id = PRECO.id_produto ' +
                   '   AND ESTABELECIMENTO.id = PRECO.id_estabelecimento ' +
                   ' order by ESTABELECIMENTO.descricao ');
  Dm.Query.Open;
  while not DM.Query.Eof do
    begin
      with ListView_Preco.Items.Add do
        begin
          Tag := Dm.Query.FieldByName('ESTAB_COD').AsInteger;

          TListItemText(Objects.FindDrawable('estabelecimento')).Text := Dm.Query.FieldByName('ESTAB_DESC').AsString;
          TListItemText(Objects.FindDrawable('preco')).Text := Dm.Query.FieldByName('valor').AsString;
          TListItemImage(Objects.FindDrawable('editar')).Bitmap :=  ImageEditar.Bitmap;
          TListItemImage(Objects.FindDrawable('excluir')).Bitmap :=  ImageExcluir.Bitmap;
        end;

      DM.Query.Next;
    end;

  DM.FDConnexao.Close;
end;

procedure TFormProduto.AdicionaListViewProduto(id, produto: string);
begin
  ListView_produto.Items.Clear;

  DM.FDConnexao.Close;
  DM.FDConnexao.Open;
  DM.Query.Close;
  Dm.Query.SQL.Clear;
  Dm.Query.SQL.Add('Select id,nome FROM produto');
  Dm.Query.Open;
  while not DM.Query.Eof do
    begin
      id := DM.Query.FieldByName('id').AsString;
      produto := DM.Query.FieldByName('nome').AsString;

      with ListView_produto.Items.Add do
        begin
          Tag := StrToInt(id);

          TListItemText(Objects.FindDrawable('Linha')).Text := id + ' | ' + produto;
          TListItemImage(Objects.FindDrawable('Editar')).Bitmap :=  ImageEditar.Bitmap;
          TListItemImage(Objects.FindDrawable('Excluir')).Bitmap :=  ImageExcluir.Bitmap;
        end;

      DM.Query.Next;
    end;

  DM.FDConnexao.Close;
end;



end.
