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
    RoundRect_usuário: TRoundRect;
    RoundRect_acessar: TRoundRect;
    Label_acessar: TLabel;
    StyleBook1: TStyleBook;
    Edit_usuario: TEdit;
    TabControl_login_cadastro: TTabControl;
    Login: TTabItem;
    Cadastro: TTabItem;
    Layout_central_cadastro: TLayout;
    RoundRect_nomecompleto: TRoundRect;
    Edit_nomecompleto: TEdit;
    RoundRect_senha_cadastro: TRoundRect;
    Edit_senha_cadastro: TEdit;
    RoundRect_salvar: TRoundRect;
    Label_salvar_cadastro: TLabel;
    RoundRect_usuario_cadastro: TRoundRect;
    Edit_usuario_cadastro: TEdit;
    Label_cadastrese: TLabel;
    Layout_inferior: TLayout;
    Layout_inferior_cadastro: TLayout;
    Label_voltarlogin: TLabel;
    Edit_senha: TEdit;
    RoundRect_senha: TRoundRect;
    CheckBoxSenha: TCheckBox;
    CheckBoxSenhaCad: TCheckBox;
    procedure Label_cadastreseClick(Sender: TObject);
    procedure Label_voltarloginClick(Sender: TObject);
    procedure RoundRect_salvarClick(Sender: TObject);
    procedure RoundRect_acessarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CheckBoxSenhaChange(Sender: TObject);
    procedure CheckBoxSenhaCadChange(Sender: TObject);

  private
    { Private declarations }
    function RetornaNomeUsuario(usuario: string):string;
    function PegaNomeDoUsuario(nome: string):string;
    function ValidarUsuario(usuario, senha: string): Boolean;

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

//Função que retorna o nome completo do usuário que foi passado como parâmetro
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

function TFormLogin.ValidarUsuario(usuario, senha: string): Boolean;
begin
  DM.FDConnexao.Close;
  DM.FDConnexao.Open;
  DM.Query.Close;
  DM.Query.SQL.Clear;
  DM.Query.SQL.Add('SELECT usuario,senha FROM usuario WHERE usuario = :USUARIO');
  DM.Query.ParamByName('USUARIO').AsString := usuario;
  DM.Query.Open;

  if DM.Query.RecordCount = 0 then     // Se for 0, não existe o usuário
    begin
      Result := False;
    end
  else   // Se não for 0 o usuário existe
    begin
      if dm.Criptografa('D', DM.Query.FieldByName('senha').AsString) = senha then //Descriptografa e valida a senha
        begin
          Result := True;    //Se for igual, retorna True
        end
      else
        begin
          Result := False;  // Se não retorna False
        end;
    end;

end;

// Procedure que insere usuário no Banco de Dados
procedure TFormLogin.CheckBoxSenhaCadChange(Sender: TObject);
begin
  // Exibe ou oculta o campo de senha dentro do cadastro
  Edit_senha_cadastro.Password := not Edit_senha_cadastro.Password;
end;

procedure TFormLogin.CheckBoxSenhaChange(Sender: TObject);
begin
  // Exibe ou oculta o campo de senha
  Edit_senha.Password := not Edit_senha.Password;
end;

procedure TFormLogin.FormCreate(Sender: TObject);
begin
  // Define tela de login como Padrão.
  TabControl_login_cadastro.ActiveTab := Login;
end;

// Clique Label para fazer cadastro
procedure TFormLogin.Label_cadastreseClick(Sender: TObject);
begin
  TabControl_login_cadastro.ActiveTab := Cadastro;
end;

// Clique Label  para voltar para login
procedure TFormLogin.Label_voltarloginClick(Sender: TObject);
begin
  TabControl_login_cadastro.ActiveTab := Login;
  //Remove os valores dos Edits
  Edit_usuario.Text := '';
  Edit_nomecompleto.Text := '';
  Edit_senha_cadastro.Text := '';
  Edit_usuario_cadastro.Text := '';
  Edit_senha.Text := '';
end;

function TFormLogin.PegaNomeDoUsuario(nome: string): string;
begin
  //
end;

//Botão Acessar - Login
procedure TFormLogin.RoundRect_acessarClick(Sender: TObject);
begin
  if ValidarUsuario(Edit_usuario.Text,Edit_senha.Text) then   //Se a Validação retornar True (defalt)
  begin
      //Retorna o nome do usuário e joga na variavel nomeUsuario
      nomeUsuario := RetornaNomeUsuario(Edit_usuario.Text);
      UnitInicial.FormInicial := UnitInicial.TFormInicial.Create(self);
      UnitInicial.FormInicial.Show;
      FormLogin.hide;
  end
  else  // Senão
  begin
    ShowMessage('Usuário ou senha Inválidos!');
  end;

end;


//Botão Salvar - Cadastro
procedure TFormLogin.RoundRect_salvarClick(Sender: TObject);
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
      //Troca Tela
      TabControl_login_cadastro.ActiveTab := Login;
      //Zera Valor dos Edits
      Edit_usuario.text := '';
      Edit_senha.Text := '';
    end;
  end
  else
  begin
    ShowMessage('Preencha Todas as informações!')
  end;

end;


end.
