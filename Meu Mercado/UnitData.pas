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
    FDTabelaUsuarios: TFDTable;
    FDTabelaUsuariosusuario: TStringField;
    FDTabelaUsuariosnome: TStringField;
    FDTabelaUsuariossenha: TStringField;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    function Criptografa(Action, Src: String): String;
    { Public declarations }
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

  Key := '@&*()(&*)_(($%@#$$%&%*%&)_*(_)*&%%$!@#$*()_!@#$%*()_)*&&*)&*(&%%&*(&%$#@!#%&%&)*_(*&%$#$@#$@#$&$*()(*&_)%%$&$1DFSBH2ST34TRH5RTH6RTH7T854Y4UI96O08LZ8A�P9QP809WPS6YXHGERCVDWEA34ERF34RWFG5F4WWYHVUJ76BIG8OT8Y6ERIH76NIO67MI7I6JRIU76II76KI6LI67OI7I76IPUI76I�76I';
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
    raise Exception.Create('Erro de conex�o com o banco de dados: ' + e.Message);
  end;

end;

end.
