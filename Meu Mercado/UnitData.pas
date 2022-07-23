unit UnitData;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet,System.IOUtils;

type
  TDM = class(TDataModule)
    FDConnexao: TFDConnection;
    Query: TFDQuery;
    QueryCategoria: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function Criptografa(Action, Src: String): String;
    procedure InserirUsuario(usuario, senha, nome: string);
    procedure InserirProduto(nome, categoria, descricao: string);
    procedure InserirEstabelecimento(nome, endereco, telefone: string);
    function ValidarCadastro(usuario: string): Boolean;
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

function TDM.Criptografa(Action, Src: String): String;
Label Fim;
var KeyLen, KeyPos, OffSet, SrcPos, SrcAsc, TmpSrcAsc, Range : Integer;
    Dest, Key : String;
begin
  if (Src = '') Then
    begin
      Result:= '';
      Goto Fim;
    end;

  Key := '@&*()(&*)_(($%@#$$%&%*%&)_*(_)*&%%$!@#$*()_!@#$%*()_)*&&*)&*(&%%&*(&%$#@!#%&%&)*_(*&%$#$@#$@#$&$*()(*&_)%%$&$1DFSBH2ST34TRH5RTH6RTH7T854Y4UI96O08LZ8AÇP9QP809WPS6YXHGERCVDWEA34ERF34RWFG5F4WWYHVUJ76BIG8OT8Y6ERIH76NIO67MI7I6JRIU76II76KI6LI67OI7I76IPUI76IÇ76I';
  Dest := '';
  KeyLen := Length(Key);
  KeyPos := 0;
  SrcPos := 0;
  SrcAsc := 0;
  Range := 256;

  if (Action = UpperCase('C')) then
    begin
      Randomize;
      OffSet := Random(Range);
      Dest := Format('%1.2x',[OffSet]);
      for SrcPos := 1 to Length(Src) do
        begin
          SrcAsc := (Ord(Src[SrcPos]) + OffSet) Mod 255;

          if KeyPos < KeyLen then
            KeyPos := KeyPos + 1
          else
            KeyPos := 1;

          SrcAsc := SrcAsc Xor Ord(Key[KeyPos]);
          Dest := Dest + Format('%1.2x',[SrcAsc]);
          OffSet := SrcAsc;
        end;
    end
  else
    if (Action = UpperCase('D')) then
      begin
        OffSet := StrToInt('$'+ copy(Src,1,2));
        SrcPos := 3;

        repeat
          SrcAsc := StrToInt('$'+ copy(Src,SrcPos,2));

          if (KeyPos < KeyLen) Then
            KeyPos := KeyPos + 1
          else
            KeyPos := 1;

          TmpSrcAsc := SrcAsc Xor Ord(Key[KeyPos]);

          if TmpSrcAsc <= OffSet then
            TmpSrcAsc := 255 + TmpSrcAsc - OffSet
          else
            TmpSrcAsc := TmpSrcAsc - OffSet;

          Dest := Dest + Chr(TmpSrcAsc);
          OffSet := SrcAsc;
          SrcPos := SrcPos + 2;
        until (SrcPos >= Length(Src));
      end;
  Result:= Dest;
  Fim:
end;

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  FDConnexao.Params.Values['DriverID'] := 'SQLite';

  {$IFDEF MSWINDOWS}
  FDConnexao.Params.Values['Database'] := System.SysUtils.GetCurrentDir + '\mercado.db';
  {$ELSE}
  FDConnexao.Params.Values['Database'] := TPath.Combine(TPath.GetDocumentsPath, 'mercado.db');
  {$ENDIF}

  try
    FDConnexao.Connected := true;
  except on e:exception do
    raise Exception.Create('Erro de conexão com o banco de dados: ' + e.Message);
  end;
  FDConnexao.Connected := False;
end;

procedure TDM.InserirEstabelecimento(nome, endereco, telefone: string);
begin
  DM.FDConnexao.Close;
  DM.FDConnexao.Open;
  DM.Query.Close;
  DM.Query.SQL.Clear;
  DM.Query.SQL.Add('INSERT INTO estabelecimento (descricao,endereco,telefone) VALUES (:nome,:endereco,:telefone); ');
  DM.Query.ParamByName('nome').AsString := nome;
  DM.Query.ParamByName('endereco').AsString := endereco;
  DM.Query.ParamByName('telefone').AsString := telefone;
  DM.Query.ExecSQL;
end;

procedure TDM.InserirProduto(nome, categoria, descricao: string);
begin
  DM.FDConnexao.Close;
  DM.FDConnexao.Open;
  DM.Query.Close;
  DM.Query.SQL.Clear;
  DM.Query.SQL.Add('INSERT INTO produto (nome,categoria,descricao) VALUES (:nome,:categoria,:descricao); ');
  DM.Query.ParamByName('nome').AsString := nome;
  DM.Query.ParamByName('categoria').AsString := categoria;
  DM.Query.ParamByName('descricao').AsString := descricao;
  DM.Query.ExecSQL;
end;

procedure TDM.InserirUsuario(usuario, senha, nome: string);
begin
  DM.FDConnexao.Close;
  DM.FDConnexao.Open;
  DM.Query.Close;
  DM.Query.SQL.Clear;
  DM.Query.SQL.Add('INSERT INTO usuario (usuario,nome,senha) VALUES (:USUARIO,:NOME,:SENHA); ');
  DM.Query.ParamByName('USUARIO').AsString := usuario;
  DM.Query.ParamByName('NOME').AsString := nome;
  DM.Query.ParamByName('SENHA').AsString := dm.Criptografa('C', senha);
  DM.Query.ExecSQL;
end;

function TDM.ValidarCadastro(usuario: string): Boolean;
begin
  DM.FDConnexao.Close;
  DM.FDConnexao.Open();
  DM.Query.Close;
  DM.Query.SQL.Clear;
  DM.Query.SQL.Add('SELECT usuario FROM usuario WHERE usuario = :USUARIO');
  DM.Query.ParamByName('USUARIO').AsString := usuario;
  DM.Query.Open;

  if DM.Query.RecordCount > 0 then
  begin
    Result := True;
  end
  else
  begin
    Result := False;
  end;

end;

end.
