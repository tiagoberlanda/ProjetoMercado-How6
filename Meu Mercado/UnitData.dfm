object DM: TDM
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 482
  Width = 523
  object FDConnexao: TFDConnection
    Params.Strings = (
      
        'Database=C:\Users\berla\OneDrive - UNIVALI\Hands On Work 6\Meu M' +
        'ercado\Win32\Debug\mercado.db'
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
    Left = 160
    Top = 56
  end
  object FDTabelaUsuarios: TFDTable
    IndexFieldNames = 'usuario'
    DetailFields = 'nome'
    Connection = FDConnexao
    TableName = 'usuario'
    Left = 248
    Top = 56
    object FDTabelaUsuariosusuario: TStringField
      FieldName = 'usuario'
      Origin = 'usuario'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
      Size = 300
    end
    object FDTabelaUsuariosnome: TStringField
      FieldName = 'nome'
      Origin = 'nome'
      Required = True
      Size = 400
    end
    object FDTabelaUsuariossenha: TStringField
      FieldName = 'senha'
      Origin = 'senha'
      Required = True
      Size = 150
    end
  end
end
