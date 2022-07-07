unit UnitLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Edit, FMX.TabControl,
  System.Actions, FMX.ActnList;

type
  TFormLogin = class(TForm)
    Layout_central: TLayout;
    Image_logo: TImage;
    Image_perfil: TImage;
    Layout_perfil: TLayout;
    Layout_usu�rio: TLayout;
    RoundRect_usu�rio: TRoundRect;
    Layout_senha: TLayout;
    Layout_central_inferior: TLayout;
    RoundRect_acessar: TRoundRect;
    Label_acessar: TLabel;
    StyleBook1: TStyleBook;
    Edit_usuario: TEdit;
    TabControl_login_cadastro: TTabControl;
    Login: TTabItem;
    Cadastro: TTabItem;
    Layout_central_cadastro: TLayout;
    Layout2: TLayout;
    RoundRect_nomecompleto: TRoundRect;
    Edit_nomecompleto: TEdit;
    Layout3: TLayout;
    RoundRect_senha_cadastro: TRoundRect;
    Edit_senha_cadastro: TEdit;
    Layout4: TLayout;
    RoundRect_salvar: TRoundRect;
    Label_salvar_cadastro: TLabel;
    Layout1: TLayout;
    RoundRect_usuario_cadastro: TRoundRect;
    Edit_usuario_cadastro: TEdit;
    ActionList1: TActionList;
    ChangeTabAction_login: TChangeTabAction;
    ChangeTabAction_cadastro: TChangeTabAction;
    Label_cadastrese: TLabel;
    Layout_inferior: TLayout;
    Layout_inferior_cadastro: TLayout;
    Label_voltarlogin: TLabel;
    Edit_senha: TEdit;
    RoundRect_senha: TRoundRect;
    procedure Label_cadastreseClick(Sender: TObject);
    procedure Label_voltarloginClick(Sender: TObject);
    procedure RoundRect_salvarClick(Sender: TObject);
    procedure RoundRect_acessarClick(Sender: TObject);

  private
    { Private declarations }
    function ValidarUsuario(usuario: string;senha: string):Boolean;
    function ValidarCadastro(usuario:string):Boolean;
    procedure InserirUsuario(usuario: string;senha: string;nome: string);
    function RetornaNomeUsuario(usuario: string):string;
    function PegaNomeDoUsuario(nome: string):string;

  public
    { Public declarations }
    var
      nomeUsuario: string;
  end;

var
  FormLogin: TFormLogin;


implementation

{$R *.fmx}

uses UnitData, UnitTemplate, UnitInicial;

//Fun��o que retorna o nome completo do usu�rio que foi passado como par�metro
function TFormLogin.RetornaNomeUsuario(usuario: string): string;
begin
  DM.FDConnexao.Close;
  DM.FDConnexao.Open();
  DM.Query.SQL.Clear;
  DM.Query.SQL.Add('SELECT nome FROM usuario WHERE usuario = :USUARIO;');
  DM.Query.ParamByName('USUARIO').AsString := usuario;
  DM.Query.Open();
  Result :=  DM.Query.FieldByName('nome').AsString;

end;

//Fun��o para validar se o usu�rio existe, retorna True se sim e False se n�o.
function TFormLogin.ValidarCadastro(usuario: string): Boolean;
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

function TFormLogin.ValidarUsuario(usuario, senha: string): Boolean;
begin
  DM.FDConnexao.Close;
  DM.FDConnexao.Open;
  DM.Query.Close;
  DM.Query.SQL.Clear;
  DM.Query.SQL.Add('SELECT usuario,senha FROM usuario WHERE usuario = :USUARIO');
  DM.Query.ParamByName('USUARIO').AsString := usuario;
  DM.Query.Open;

  if DM.Query.RecordCount = 0 then     // Se for 0, n�o existe o usu�rio
    begin
      Result := False;
    end
  else   // Se n�o for 0 o usu�rio existe
    begin
      if dm.Criptografa('D', DM.Query.FieldByName('senha').AsString) = senha then //Descriptografa e valida a senha
        begin
          Result := True;    //Se for igual, retorna True
        end
      else
        begin
          Result := False;  // Se n�o retorna False
        end;
    end;

end;

// Procedure que insere usu�rio no Banco de Dados
procedure TFormLogin.InserirUsuario(usuario, senha, nome: string);
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

// Clique Label para fazer cadastro
procedure TFormLogin.Label_cadastreseClick(Sender: TObject);
begin
  ChangeTabAction_cadastro.Execute;
end;

// Clique Label  para voltar para login
procedure TFormLogin.Label_voltarloginClick(Sender: TObject);
begin
  ChangeTabAction_login.Execute;
end;

function TFormLogin.PegaNomeDoUsuario(nome: string): string;
begin
  //
end;

//Bot�o Acessar - Login
procedure TFormLogin.RoundRect_acessarClick(Sender: TObject);
begin
  if ValidarUsuario(Edit_usuario.Text,Edit_senha.Text) then   //Se a Valida��o retornar True (defalt)
  begin
      //Retorna o nome do usu�rio e joga na variavel nomeUsuario
      nomeUsuario := RetornaNomeUsuario(Edit_usuario.Text);
      UnitInicial.FormInicial := UnitInicial.TFormInicial.Create(self);
      UnitInicial.FormInicial.Show;
      FormLogin.hide;
  end
  else  // Sen�o
  begin
    ShowMessage('Usu�rio ou senha Inv�lidos!');
  end;

end;


//Bot�o Salvar - Cadastro
procedure TFormLogin.RoundRect_salvarClick(Sender: TObject);
begin
  if (Edit_nomecompleto.Text <> '') and     //Valida se foi digitado informa��o
  (Edit_senha_cadastro.Text <> '') and (Edit_usuario_cadastro.Text <> '') then
  begin
    if ValidarCadastro(Edit_usuario_cadastro.Text) then  //Se retornar True � porque o usu�rio existe
    begin
      ShowMessage('Usu�rio j� existente, use outro e tente novamene.');
      Edit_nomecompleto.Text := '';    // Se o usu�rio j� existir ir� apagar o que foi digitado nos Edits
      Edit_senha_cadastro.Text := '';
      Edit_usuario_cadastro.Text := '';
    end
    else
    begin
      InserirUsuario(Edit_usuario_cadastro.Text,Edit_senha_cadastro.Text,Edit_nomecompleto.Text);
      ShowMessage('Cadastro Feito Com sucesso!');
      ChangeTabAction_login.Execute;
    end;

  end
  else
  begin
    ShowMessage('Preencha Todas as informa��es!')
  end;

end;


end.
