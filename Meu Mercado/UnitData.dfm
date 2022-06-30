object DM: TDM
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 482
  Width = 523
  object FDConnexao: TFDConnection
    Params.Strings = (
      'Database=C:\temp\Meu Mercado\Win32\Debug\mercado.db'
      'OpenMode=ReadWrite'
      'LockingMode=Normal'
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 40
    Top = 48
  end
  object Query: TFDQuery
    Connection = FDConnexao
    SQL.Strings = (
      'select * from usuario')
    Left = 104
    Top = 48
  end
  object QueryUsuarios: TFDQuery
    Connection = FDConnexao
    SQL.Strings = (
      'SELECT nome,usuario FROM USUARIO')
    Left = 104
    Top = 112
  end
  object QueryEstabelecimentos: TFDQuery
    Connection = FDConnexao
    SQL.Strings = (
      'SELECT id,descricao FROM estabelecimento')
    Left = 104
    Top = 168
  end
end
