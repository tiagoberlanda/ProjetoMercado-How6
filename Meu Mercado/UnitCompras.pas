unit UnitCompras;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UnitTemplate, FMX.Objects, FMX.Controls.Presentation, FMX.Layouts, FMX.Edit,
  FMX.ListBox, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, FMX.TabControl;

type
  TFormCompras = class(TFormTemplate)
    Image_voltar: TImage;
    Layout_central_cadastro: TLayout;
    StyleBook1: TStyleBook;
    Image_confirmar: TImage;
    ListView_Lista: TListView;
    ImageAdicionar: TImage;
    ImageConfirmar: TImage;
    TabControl_Compras: TTabControl;
    TabCompras: TTabItem;
    TabProduto: TTabItem;
    Label_titulo: TLabel;
    RoundRect_nomecompleto: TRoundRect;
    Edit_nomecompleto: TEdit;
    Label_nomeLista: TLabel;
    Label_info: TLabel;
    Label1: TLabel;
    Layout_titulos: TLayout;
    Label2: TLabel;
    procedure Image_voltarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListView_ListaItemClickEx(const Sender: TObject;
      ItemIndex: Integer; const LocalClickPos: TPointF;
      const ItemObject: TListItemDrawable);
  private
    procedure MontaListView(tag:integer);
    function validaListaCompras(nome: string): boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormCompras: TFormCompras;

implementation

{$R *.fmx}

uses UnitInicial, UnitData;

procedure TFormCompras.FormCreate(Sender: TObject);
begin
  inherited;
  //Esconde Imagens
  ImageAdicionar.Visible := False;
  ImageConfirmar.Visible := False;

  //define tab padrão
  TabControl_Compras.ActiveTab := TabCompras;

  //limpa informações
  ListView_Lista.Items.Clear;

  //Monta a listView de produto
  MontaListView(0);
end;

procedure TFormCompras.Image_voltarClick(Sender: TObject);
begin
  inherited;
  //verifica em qual tab esta
  if TabControl_Compras.ActiveTab = TabCompras then
  begin
    //valida Digitação da lista de compras
    if Edit_nomecompleto.Text = '' then  //se estiver vazio o campo nome
    begin
      ShowMessage('Preencha o nome da Lista de compras!')
    end
    else //Se não
    begin
      if Edit_nomecompleto.Tag = 0 then    //Adicionando novo registro
      begin
        if validaListaCompras(Edit_nomecompleto.Text) = True then //verifica se a lista já existe na base
        begin
          ShowMessage('Essa Lista de Compras Já existe, use outra!');
        end
        else  // se não exisitir, insere na base
        begin
          DM.Query.Close;
          DM.Query.SQL.Clear;
          DM.Query.SQL.Add(' INSERT INTO lista (descricao) VALUES (:descricao)');
          DM.Query.ParamByName('descricao').AsString := Edit_nomecompleto.Text;
          DM.Query.ExecSQL;

          //Pega a ID da lista criada
          DM.Query.Close;
          DM.Query.SQL.Clear;
          DM.Query.SQL.Add(' SELECT id FROM lista WHERE descricao = :descricao');
          DM.Query.ParamByName('descricao').AsString := Edit_nomecompleto.Text;
          DM.Query.open;

          Edit_nomecompleto.Tag := DM.Query.FieldByName('id').AsInteger;

          //Troca a tab
          TabControl_Compras.ActiveTab := TabProduto;
        end;
      end
      else
      begin
      //update
        DM.Query.Close;
        DM.Query.SQL.Clear;
        DM.Query.SQL.Add(' update lista ' +
                         ' set descricao = :descricao ' +
                         ' where id = :id ');
        DM.Query.ParamByName('descricao').AsString := Edit_nomecompleto.Text;
        DM.Query.ParamByName('id').AsInteger := Edit_nomecompleto.Tag;
        DM.Query.ExecSQL;



        //Pega a ID da lista criada
        DM.Query.Close;
        DM.Query.SQL.Clear;
        DM.Query.SQL.Add(' SELECT id FROM lista WHERE descricao = :descricao');
        DM.Query.ParamByName('descricao').AsString := Edit_nomecompleto.Text;
        DM.Query.open;

        Edit_nomecompleto.Tag := DM.Query.FieldByName('id').AsInteger;

        //preencher os produtos já na lista
        MontaListView(Edit_nomecompleto.Tag);

        //Troca a tab
        TabControl_Compras.ActiveTab := TabProduto;
      end;

    end;
  end
  else
  begin
    ShowMessage('Lista Cadastrada Com sucesso!');
    FormInicial := TFormInicial.Create(Self);
    FormCompras.close;
    FormInicial.show;
  end;
end;

procedure TFormCompras.ListView_ListaItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
var
  vsTemp, vsProd, vsEst, vsPreco : String;
begin
  inherited;

  if ItemObject <> nil then    //Usuário clicou em algum objeto
  begin
    if ItemObject.Name = 'adicionar' then
    begin

      ListView_Lista.Items[ItemIndex].Bitmap := Image_confirmar.Bitmap;
      //Pega Valores
      vsEst := Copy(ListView_Lista.Items[ItemIndex].TagString,
                    1,
                    Pos('|', ListView_Lista.Items[ItemIndex].TagString)-1);

      vsTemp := Copy(ListView_Lista.Items[ItemIndex].TagString,
                     Pos('|', ListView_Lista.Items[ItemIndex].TagString)+1,
                     100);

      vsProd := Copy(vsTemp,
                     1,
                     Pos('|', vsTemp)-1);

      vsTemp := Copy(vsTemp,
                     Pos('|', vsTemp)+1,
                     100);

      vsPreco := Copy(vsTemp,
                     1,
                     Pos('|', vsTemp)+1);
      if ListView_Lista.Items[ItemIndex].Checked then
      begin
        DM.Query.Close;
        DM.Query.SQL.Clear;
        DM.Query.SQL.Add(' DELETE FROM lista_prod ' +
                            'WHERE id_lista = :id_lista ' +
                            'and id_produto = :id_produto ' +
                            'and id_estabelecimento = :id_estabelecimento '+
                            'and valor =:valor');
        DM.Query.ParamByName('id_lista').AsInteger := Edit_nomecompleto.Tag;
        DM.Query.ParamByName('id_produto').AsInteger := vsProd.ToInteger;
        DM.Query.ParamByName('id_estabelecimento').AsInteger := vsEst.ToInteger;
        DM.Query.ParamByName('valor').AsCurrency := vsPreco.ToDouble;
        DM.Query.ExecSQL;
        ListView_Lista.Items[ItemIndex].Bitmap := ImageAdicionar.Bitmap;
      end
      else
      begin
        DM.Query.Close;
        DM.Query.SQL.Clear;
        DM.Query.SQL.Add(' insert into lista_prod(id_lista,id_produto, id_estabelecimento, valor) ' +
                         '       values(:id_lista,:id_produto, :id_estabelecimento, :valor) ');
        DM.Query.ParamByName('id_lista').AsInteger := Edit_nomecompleto.Tag;
        DM.Query.ParamByName('id_produto').AsInteger := vsProd.ToInteger;
        DM.Query.ParamByName('id_estabelecimento').AsInteger := vsEst.ToInteger;
        DM.Query.ParamByName('valor').AsCurrency := vsPreco.ToDouble;
        DM.Query.ExecSQL;
        ListView_Lista.Items[ItemIndex].Bitmap := ImageConfirmar.Bitmap;
      end;
    end;
  end;

  MontaListView(Edit_nomecompleto.Tag);
end;

procedure TFormCompras.MontaListView(tag: integer);
begin
  ListView_Lista.Items.Clear; //limpa listview lista

  DM.Query.Close;
  Dm.Query.SQL.Clear;
  Dm.Query.SQL.Add('SELECT ESTABELECIMENTO.id AS ESTAB_COD, ESTABELECIMENTO.descricao AS ESTAB_DESC, ' +
                   '       PRODUTO.id AS PROD_COD, PRODUTO.nome AS PROD_dESC, ' +
                   '       PRECO.valor, ' +
                   '       (select count(*) from lista_prod p ' +
                   '        where p.id_lista = :id_lista ' +
                   '          and p.id_produto = PRODUTO.id ' +
                   '          and p.id_estabelecimento = ESTABELECIMENTO.id) as inserido ' +
                   ' FROM PRECO, ESTABELECIMENTO, PRODUTO ' +
                   ' WHERE PRODUTO.id = PRECO.id_produto ' +
                   '   AND ESTABELECIMENTO.id = PRECO.id_estabelecimento ' +
                   ' order by ESTABELECIMENTO.descricao ');
  Dm.Query.ParamByName('id_lista').AsInteger := tag;
  Dm.Query.Open;
  while not DM.Query.Eof do
    begin
      with ListView_Lista.Items.Add do
        begin
          TagString := Dm.Query.FieldByName('ESTAB_COD').AsString + '|' +
                       Dm.Query.FieldByName('PROD_COD').AsString + '|' +
                       Dm.Query.FieldByName('valor').AsString;

          TListItemText(Objects.FindDrawable('produto')).Text := Dm.Query.FieldByName('PROD_dESC').AsString;
          TListItemText(Objects.FindDrawable('estabelecimento')).Text := Dm.Query.FieldByName('ESTAB_DESC').AsString;
          TListItemText(Objects.FindDrawable('preco')).Text := 'R$' + Dm.Query.FieldByName('valor').AsString;

          if Dm.Query.FieldByName('inserido').AsInteger = 0 then
            begin
              TListItemImage(Objects.FindDrawable('adicionar')).Bitmap :=  ImageAdicionar.Bitmap;
              Checked := False;
            end
          else
            begin
              TListItemImage(Objects.FindDrawable('adicionar')).Bitmap :=  Image_confirmar.Bitmap;
              Checked := True;
            end;
        end;

      DM.Query.Next;
    end;

  DM.FDConnexao.Close;
end;

function TFormCompras.validaListaCompras(nome: string): boolean;
begin
    DM.Query.Close;
    DM.Query.SQL.Clear;
    DM.Query.SQL.Add(' select id from lista where descricao = ' +QuotedStr(nome));
    DM.Query.open;
    if Dm.Query.RecordCount = 0  then
    begin
      Result := False;
    end
    else
    begin
      Result := True;
    end;
end;

end.
