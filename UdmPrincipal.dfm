object dmPrincipal: TdmPrincipal
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 167
  Width = 263
  object fdConexao: TFDConnection
    Params.Strings = (
      'Database=api-caixa'
      'User_Name=postgres'
      'Password=postgres'
      'DriverID=PG')
    LoginPrompt = False
    Left = 104
    Top = 56
  end
end
