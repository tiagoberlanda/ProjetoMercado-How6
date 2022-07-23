object DM: TDM
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 482
  Width = 523
  object FDConnexao: TFDConnection
    Params.Strings = (
      
        'Database=C:\Users\berla\Desktop\Desenvolvimento\Delphi\Meu Merca' +
        'do\Win32\Debug\mercado.db'
      'OpenMode=ReadWrite'
      'LockingMode=Normal'
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 32
    Top = 48
  end
  object Query: TFDQuery
    Connection = FDConnexao
    SQL.Strings = (
      'select * from usuario')
    Left = 104
    Top = 48
  end
  object QueryCategoria: TFDQuery
    Connection = FDConnexao
    SQL.Strings = (
      'select * from categoria')
    Left = 112
    Top = 112
  end
end
