unit DAO.Usuarios;

interface 

uses SqlExpr, SimpleDS, Classes, SysUtils, DateUtils,
     StdCtrls, Model.Usuarios, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.PG,
     FireDAC.Phys.PGDef, FireDAC.ConsoleUI.Wait, Data.DB, FireDAC.Comp.Client,
     System.Generics.Collections;

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
         Function RetornaColecao : TObjectList<TUsuario>;
         Function Retorna(pId : Integer) : TUsuario;
         Function RetornaPeloEmail(pEmail : String) : TUsuario;
         Function Insere(pUsuarios: TUsuario) : Boolean;
         Function InsereColecao(pUsuarios: TObjectList<TUsuario>) : Boolean;
         Function Atualiza(pUsuarios: TUsuario) : Boolean;
         Function Deleta(pId : Integer) : Boolean;
         Function AtualizaColecao(pUsuarios: TObjectList<TUsuario>):Boolean;
         Function Existe(pId: Integer): Boolean;
      end;
implementation

Function TUsuariosDao.RetornaSql : String;
begin
   Result :=
      'SELECT  *          '+
      'FROM USUARIOS      '+
      'ORDER BY ID        ';
End;

Function TUsuariosDao.RetornaSqlComChave : String;
begin
   Result :=
      'SELECT *              '+
      'FROM USUARIOS         '+
      'WHERE ID = :ID        ';
End;

Function TUsuariosDao.RetornaSqlInsert : String;
begin
   Result := 
      'INSERT INTO USUARIOS (NOME, EMAIL, SENHA, EMPRESA_ID) '+
      'VALUES (:NOME, :EMAIL, :SENHA, :EMPRESA_ID)           ';
End;

Function TUsuariosDao.RetornaSqlUpdate : String;
begin
   Result :=
      'UPDATE USUARIOS              '+
      'SET NOME = :NOME,            '+
      '    EMAIL = :EMAIL,          '+
      '    SENHA = :SENHA,          '+
      '    EMPRESA_ID = :EMPRESA_ID '+
      'WHERE ID = :ID               ';
End;

Function TUsuariosDao.RetornaSqlDeleta : String;
begin
   Result :=
      'DELETE FROM USUARIOS  '+
      'WHERE ID = :ID        ';
end;

function TUsuariosDao.RetornaColecao : TObjectList<TUsuario>;
var
   QueryUsuarios : TFDQuery;
   ObjUsuarios : TUsuario;
begin
   Result := nil;
   QueryUsuarios := TFDQuery.Create(Nil);
   Result := TObjectList<TUsuario>.Create;
   try
      QueryUsuarios.Connection := Self.vConexao;
      QueryUsuarios.Sql.Text := RetornaSql;
      QueryUsuarios.Open;
      if QueryUsuarios.IsEmpty then
         Exit;
      while Not(QueryUsuarios).Eof do
      begin
         ObjUsuarios := TUsuario.Create;
         ObjUsuarios.Id          := QueryUsuarios.FieldByName('Id'         ).AsInteger;
         ObjUsuarios.Nome        := QueryUsuarios.FieldByName('Nome'       ).AsString;
         ObjUsuarios.Email       := QueryUsuarios.FieldByName('Email'      ).AsString;
         ObjUsuarios.Senha       := QueryUsuarios.FieldByName('Senha'      ).AsString;
         ObjUsuarios.Empresa_id  := QueryUsuarios.FieldByName('Empresa_id' ).AsInteger;
         Result.Add(ObjUsuarios);
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

function TUsuariosDao.Retorna(pId : Integer) : TUsuario;
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
      Result := TUsuario.Create;
      Result.Id          := QueryUsuarios.FieldByName('Id'         ).AsInteger;
      Result.Nome        := QueryUsuarios.FieldByName('Nome'       ).AsString;
      Result.Email       := QueryUsuarios.FieldByName('Email'      ).AsString;
      Result.Senha       := QueryUsuarios.FieldByName('Senha'      ).AsString;
      Result.Empresa_id  := QueryUsuarios.FieldByName('Empresa_id' ).AsInteger;
   finally
      FreeAndNil(QueryUsuarios);
   end;
end;

function TUsuariosDao.RetornaPeloEmail(pEmail : String) : TUsuario;
var
   QueryUsuarios : TFDQuery;
begin
   Result := Nil;
   QueryUsuarios := TFDQuery.Create(Nil);
   try
      QueryUsuarios.Connection := Self.vConexao;
      QueryUsuarios.Sql.Text :=
         'SELECT *             '+
         'FROM USUARIOS        '+
         'WHERE EMAIL = :EMAIL ';
      QueryUsuarios.ParamByName('EMAIL').AsString := pEmail;
      QueryUsuarios.Open;
      if QueryUsuarios.IsEmpty then
         Exit;
      Result := TUsuario.Create;
      Result.Id          := QueryUsuarios.FieldByName('Id'         ).AsInteger;
      Result.Nome        := QueryUsuarios.FieldByName('Nome'       ).AsString;
      Result.Email       := QueryUsuarios.FieldByName('Email'      ).AsString;
      Result.Senha       := QueryUsuarios.FieldByName('Senha'      ).AsString;
      Result.Empresa_id  := QueryUsuarios.FieldByName('Empresa_id' ).AsInteger;
   finally
      FreeAndNil(QueryUsuarios);
   end;
end;

Function TUsuariosDao.Insere(pUsuarios: TUsuario) : Boolean;
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

Function TUsuariosDao.InsereColecao(pUsuarios: TObjectList<TUsuario>) : Boolean;
var
   indice: Integer;
begin
   Result := False;
   for indice := 0 to pUsuarios.count -1 do
   begin
      if not Self.Insere(pUsuarios[Indice]) then
         Exit;
   end;
   Result := True;
end;

Function TUsuariosDao.Atualiza(pUsuarios: TUsuario) : Boolean;
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

Function TUsuariosDao.AtualizaColecao(pUsuarios: TObjectList<TUsuario>):Boolean;
var
   indice: Integer;
begin
   Result := True;
   for indice := 0 to pUsuarios.count -1 do
   begin
      if not Self.Atualiza(pUsuarios[Indice]) then
      begin
         Result := False;
         Exit;
      end;
   end;
end;

function TUsuariosDao.Existe(pId : Integer) : Boolean;
var
   QueryUsuarios : TFDQuery;
begin
   Result := false;
   QueryUsuarios := TFDQuery.Create(Nil);
   try
      QueryUsuarios.Connection := Self.vConexao;
      QueryUsuarios.Sql.Text := RetornaSqlComChave;
      QueryUsuarios.ParamByName('ID').AsInteger := pId;
      QueryUsuarios.Open;
      Result := not QueryUsuarios.IsEmpty;
   finally
      FreeAndNil(QueryUsuarios);
   end;
end;

end.
