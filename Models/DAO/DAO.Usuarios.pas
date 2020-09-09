unit DAO.Usuarios;

interface 

uses SqlExpr, SimpleDS, Classes, SysUtils, DateUtils,
     StdCtrls, UUsuarios, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.PG,
     FireDAC.Phys.PGDef, FireDAC.ConsoleUI.Wait, Data.DB, FireDAC.Comp.Client;

type
   TUsuariosDao = Class 
      Private
         vConexao : TFDConnection;
         Function RetornaSql : String;
         Function RetornaSqlComChave : String;
         Function RetornaSqlInsert : String;
         Function RetornaSqlUpdate : String;
         Function RetornaSqlDeleta : String;
      Public
         Constructor Create(pConexao : TFDConnection);
         Function RetornaColecao : TColUsuarios;
         Function Retorna(pId : Integer) : TUsuarios;
         Function Insere(pUsuarios: TUsuarios) : Boolean;
         Function InsereColecao(pUsuarios: TColUsuarios) : Boolean;
         Function Atualiza(pUsuarios: TUsuarios) : Boolean;
         Function Deleta(pId : Integer) : Boolean;
         Function AtualizaColecao(pUsuarios: TColUsuarios):Boolean;
      end;
implementation 

Function TUsuariosDao.RetornaSql : String;
begin
   Result :=
      'Select  *          '+
      'From Usuarios      ';
End;

Function TUsuariosDao.RetornaSqlComChave : String;
begin
   Result :=
      'Select *              '+
      'From Usuarios         '+
      'Where                 '+
      ' ID = :ID             ';
End;

Function TUsuariosDao.RetornaSqlInsert : String;
begin
   Result := 
      'INSERT INTO Usuarios '+
      '(                    '+
      'Usuarios.Nome,       '+
      'Usuarios.Email,      '+
      'Usuarios.Senha,      '+
      'Usuarios.Empresa_id  '+
      ')                    '+
      'VALUES               '+
      '(                    '+
      ':Nome,               '+
      ':Email,              '+
      ':Senha,              '+
      ':Empresa_id          '+
      ')                    ';
End;

Function TUsuariosDao.RetornaSqlUpdate : String;
begin
   Result := 
      'UPDATE Usuarios SET                  '+
      'Usuarios.Nome        = :Nome,        '+
      'Usuarios.Email       = :Email,       '+
      'Usuarios.Senha       = :Senha,       '+
      'Usuarios.Empresa_id  = :Empresa_id   '+
      'Where                                '+
      ' ID = :ID                            ';
End;

Function TUsuariosDao.RetornaSqlDeleta : String;
begin
   Result := 
      'Delete From Usuarios  '+
      'Where                 '+
      ' ID = :ID             ';
end;

function TUsuariosDao.RetornaColecao : TColUsuarios;
var
   QueryUsuarios : TFDQuery;
   ObjUsuarios : TUsuarios;
begin
   Result := nil;
   QueryUsuarios := TFDQuery.Create(Nil);
   try
      QueryUsuarios.Connection := Self.vConexao;
      QueryUsuarios.Sql.Text := RetornaSql;
      QueryUsuarios.Open;
      if QueryUsuarios.IsEmpty then
         Exit;
      Result := TColUsuarios.Create;
      while Not(QueryUsuarios).Eof do
      begin
         ObjUsuarios := TUsuarios.Create;
         ObjUsuarios.Id          := QueryUsuarios.FieldByName('Id'         ).AsInteger;
         ObjUsuarios.Nome        := QueryUsuarios.FieldByName('Nome'       ).AsString;
         ObjUsuarios.Email       := QueryUsuarios.FieldByName('Email'      ).AsString;
         ObjUsuarios.Senha       := QueryUsuarios.FieldByName('Senha'      ).AsString;
         ObjUsuarios.Empresa_id  := QueryUsuarios.FieldByName('Empresa_id' ).AsInteger;
         Result.Adiciona(ObjUsuarios);
         QueryUsuarios.Next;
      end;
   finally
      FreeAndNil(QueryUsuarios);
   end;
end;

constructor TUsuariosDao.Create(pConexao: TFDConnection);
begin
   Self.vConexao := pConexao;
end;

function TUsuariosDao.Retorna(pId : Integer) : TUsuarios;
var
   QueryUsuarios : TFDQuery;
begin
   Result := Nil;
   QueryUsuarios := TFDQuery.Create(Nil);
   try
      QueryUsuarios.Connection := Self.vConexao;
      QueryUsuarios.Sql.Text := RetornaSqlComChave;
      QueryUsuarios.ParamByName('ID').AsInteger := pId;
      QueryUsuarios.Open;
      if QueryUsuarios.IsEmpty then
         Exit;
      Result := TUsuarios.Create;
      Result.Id          := QueryUsuarios.FieldByName('Id'         ).AsInteger;
      Result.Nome        := QueryUsuarios.FieldByName('Nome'       ).AsString;
      Result.Email       := QueryUsuarios.FieldByName('Email'      ).AsString;
      Result.Senha       := QueryUsuarios.FieldByName('Senha'      ).AsString;
      Result.Empresa_id  := QueryUsuarios.FieldByName('Empresa_id' ).AsInteger;
   finally
      FreeAndNil(QueryUsuarios);
   end;
end;

Function TUsuariosDao.Insere(pUsuarios: TUsuarios) : Boolean;
var
   QueryUsuarios : TFDQuery;
begin
   Result := False;
   QueryUsuarios := TFDQuery.Create(Nil);
   try
      QueryUsuarios.Connection := Self.vConexao;
      QueryUsuarios.Sql.Text := RetornaSqlInsert;
      QueryUsuarios.ParamByName('Nome'       ).AsString  := pUsuarios.Nome;
      QueryUsuarios.ParamByName('Email'      ).AsString  := pUsuarios.Email;
      QueryUsuarios.ParamByName('Senha'      ).AsString  := pUsuarios.Senha;
      QueryUsuarios.ParamByName('Empresa_id' ).AsInteger := pUsuarios.Empresa_id;
      try
         QueryUsuarios.ExecSql;
      except
         on E: Exception do
         begin
            raise Exception.Create('Ocorreu um erro ao tentar inserir os dados '+
               'da tabela USUARIOS.' + #13 + 'Motivo: ' + e.Message);
         end;
      end;
   finally
      FreeAndNil(QueryUsuarios);
   end;
   Result := True;
end;

Function TUsuariosDao.InsereColecao(pUsuarios: TColUsuarios) : Boolean;
var
   indice: Integer;
begin
   Result := False;
   for indice := 0 to pUsuarios.count -1 do
   begin
      if not Self.Insere(pUsuarios.Retorna(Indice)) then
         Exit;
   end;
   Result := True;
end;

Function TUsuariosDao.Atualiza(pUsuarios: TUsuarios) : Boolean;
var
   QueryUsuarios : TFDQuery;
begin
   Result := False;
   QueryUsuarios := TFDQuery.Create(Nil);
   try
      QueryUsuarios.Connection := Self.vConexao;
      QueryUsuarios.Sql.Text := RetornaSqlUpdate;
      QueryUsuarios.ParamByName('Id'         ).AsInteger := pUsuarios.Id;
      QueryUsuarios.ParamByName('Nome'       ).AsString  := pUsuarios.Nome;
      QueryUsuarios.ParamByName('Email'      ).AsString  := pUsuarios.Email;
      QueryUsuarios.ParamByName('Senha'      ).AsString  := pUsuarios.Senha;
      QueryUsuarios.ParamByName('Empresa_id' ).AsInteger := pUsuarios.Empresa_id;
      try
         QueryUsuarios.ExecSql;
      except
         on E: Exception do
         begin
            raise Exception.Create('Ocorreu um erro ao tentar atualizar os dados '+
               'da tabela USUARIOS.' + #13 + 'Motivo: ' + e.Message);
         end;
      end;
   finally
      FreeAndNil(QueryUsuarios);
   end;
   Result := True;
end;

Function TUsuariosDao.Deleta(pId : Integer) : Boolean;
var
   QueryUsuarios : TFDQuery;
begin
   Result := False;
   QueryUsuarios := TFDQuery.Create(Nil);
   try
      QueryUsuarios.Connection := Self.vConexao;
      QueryUsuarios.Sql.Text := RetornaSqlDeleta;
      QueryUsuarios.ParamByName('ID').AsInteger := pId;
      try
         QueryUsuarios.ExecSql;
      except
         on E: Exception do
         begin
            raise Exception.Create('Ocorreu um erro ao tentar apagar os dados '+               'da tabela USUARIOS.' + #13 + 'Motivo: ' + e.Message);         end;
      end;
   finally
      FreeAndNil(QueryUsuarios);
   end;
   Result := True;
end;

Function TUsuariosDao.AtualizaColecao(pUsuarios: TColUsuarios):Boolean;
var
   indice: Integer;
begin
   Result := True;
   for indice := 0 to pUsuarios.count -1 do
   begin
      if not Self.Atualiza(pUsuarios.Retorna(Indice)) then
      begin
         Result := False;
         Exit;
      end;
   end;
end;

end.
