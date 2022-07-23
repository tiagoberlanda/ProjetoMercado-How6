unit UnitPreco;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UnitTemplate, FMX.Controls.Presentation, FMX.Objects, FMX.Layouts,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.ListBox, FMX.Edit;

type
  TFormPreco = class(TFormTemplate)
    layout_central: TLayout;
    RoundRect_nomecompleto: TRoundRect;
    Edit_nomeProduto: TEdit;
    Layout_estabelecimento: TLayout;
    RoundRect_categoria: TRoundRect;
    ComboBox_Estabelecimento: TComboBox;
    Label_valorProduto: TLabel;
    Edit_Preco: TEdit;
    Image_voltar: TImage;
    Image_confirmar: TImage;
    Layout_preco: TLayout;
    RoundRect_preco: TRoundRect;
    Label1: TLabel;
    Label2: TLabel;
    procedure updateClick(Sender: TObject);
    procedure insertClick(Sender: TObject);
    procedure Image_voltarClick(Sender: TObject);
    procedure Image_adicionarClick(Sender: TObject);
    procedure Image_confirmarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormPreco: TFormPreco;

implementation

{$R *.fmx}

uses UnitData, UnitProduto;

procedure TFormPreco.updateClick(Sender: TObject);
var
  vscombo : String;
begin
  inherited;

  vscombo := ComboBox_Estabelecimento.Items[ComboBox_Estabelecimento.ItemIndex];

  vscombo := Trim(Copy(vsCombo, 1, Pos('|', vscombo)-1));

  DM.Query.Close;
  DM.Query.SQL.Clear;
  DM.Query.SQL.Add(' UPDATE PRECO ' +
                   ' SET VALOR = :VALOR ' +
                   ' WHERE ID_PRODUTO = :ID_PRODUTO ' +
                   '   AND ID_ESTABELECIMENTO = :ID_ESTABELECIMENTO ');
  DM.Query.ParamByName('ID_PRODUTO').AsInteger := Edit_nomeProduto.tag;
  DM.Query.ParamByName('ID_ESTABELECIMENTO').AsInteger := StrToInt(vscombo);
  DM.Query.ParamByName('VALOR').AsCurrency := StrToFloat(Edit_Preco.Text);
  DM.Query.ExecSQL;

end;

procedure TFormPreco.Image_adicionarClick(Sender: TObject);
var
  vscombo : String;
begin
  inherited;

end;

procedure TFormPreco.Image_confirmarClick(Sender: TObject);
var
  vscombo : string;
begin
  inherited;
  if Image_confirmar.Tag = 0 then
  begin
    //Inserir
    vscombo := ComboBox_Estabelecimento.Items[ComboBox_Estabelecimento.ItemIndex];

    vscombo := Trim(Copy(vsCombo, 1, Pos('|', vscombo)-1));

    DM.Query.Close;
    DM.Query.SQL.Clear;
    DM.Query.SQL.Add(' INSERT INTO PRECO(ID_PRODUTO, ID_ESTABELECIMENTO, VALOR) ' +
                     ' VALUES(:ID_PRODUTO, :ID_ESTABELECIMENTO, :VALOR) ');
    DM.Query.ParamByName('ID_PRODUTO').AsInteger := Edit_nomeProduto.tag;
    DM.Query.ParamByName('ID_ESTABELECIMENTO').AsInteger := StrToInt(vscombo);
    DM.Query.ParamByName('VALOR').AsCurrency := StrToFloat(Edit_Preco.Text);
    DM.Query.ExecSQL;
    ShowMessage('Registro Inserido com sucesso!');
    FormProduto := TFormProduto.Create(self);
    FormPreco.close;
    FormProduto.show;
  end
  else
  begin
   vscombo := ComboBox_Estabelecimento.Items[ComboBox_Estabelecimento.ItemIndex];

    vscombo := Trim(Copy(vsCombo, 1, Pos('|', vscombo)-1));

    DM.Query.Close;
    DM.Query.SQL.Clear;
    DM.Query.SQL.Add(' UPDATE PRECO ' +
                     ' SET VALOR = :VALOR ' +
                     ' WHERE ID_PRODUTO = :ID_PRODUTO ' +
                     '   AND ID_ESTABELECIMENTO = :ID_ESTABELECIMENTO ');
    DM.Query.ParamByName('ID_PRODUTO').AsInteger := Edit_nomeProduto.tag;
    DM.Query.ParamByName('ID_ESTABELECIMENTO').AsInteger := StrToInt(vscombo);
    DM.Query.ParamByName('VALOR').AsCurrency := StrToFloat(Edit_Preco.Text);
    DM.Query.ExecSQL;
    ShowMessage('Registro Atualizado com sucesso!');
    FormProduto := TFormProduto.Create(self);
    FormPreco.close;
    FormProduto.show;
  end;

end;

procedure TFormPreco.Image_voltarClick(Sender: TObject);
begin
  inherited;
 FormProduto := TFormProduto.Create(Self);
 FormPreco.close;
 FormProduto.show;
end;

procedure TFormPreco.insertClick(Sender: TObject);
var
  vscombo : String;
begin
  inherited;

  vscombo := ComboBox_Estabelecimento.Items[ComboBox_Estabelecimento.ItemIndex];

  vscombo := Trim(Copy(vsCombo, 1, Pos('|', vscombo)-1));

  DM.Query.Close;
  DM.Query.SQL.Clear;
  DM.Query.SQL.Add(' INSERT INTO PRECO(ID_PRODUTO, ID_ESTABELECIMENTO, VALOR) ' +
                   ' VALUES(:ID_PRODUTO, :ID_ESTABELECIMENTO, :VALOR) ');
  DM.Query.ParamByName('ID_PRODUTO').AsInteger := Edit_nomeProduto.tag;
  DM.Query.ParamByName('ID_ESTABELECIMENTO').AsInteger := StrToInt(vscombo);
  DM.Query.ParamByName('VALOR').AsCurrency := StrToFloat(Edit_Preco.Text);
  DM.Query.ExecSQL;
end;

end.
