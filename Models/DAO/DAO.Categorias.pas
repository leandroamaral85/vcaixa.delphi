unit DAO.Categorias;

interface 

uses SqlExpr, SimpleDS, Classes, SysUtils, DateUtils,
     StdCtrls, UCategorias, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.PG,
     FireDAC.Phys.PGDef, FireDAC.ConsoleUI.Wait, Data.DB, FireDAC.Comp.Client;

type
   TCategoriasDao = Class
      Private
         vConexao : TFDConnection;
         Function RetornaSql : String;
         Function RetornaSqlComChave : String;
         Function RetornaSqlInsert : String;
         Function RetornaSqlUpdate : String;
         Function RetornaSqlDeleta : String;
      Public
         Constructor Create(pConexao : TFDConnection);
         Function RetornaColecao : TColCategorias;
         Function Retorna(pId : Integer) : TCategorias;
         Function Insere(pCategorias: TCategorias) : Boolean;
         Function InsereColecao(pCategorias: TColCategorias) : Boolean;
         Function Atualiza(pCategorias: TCategorias) : Boolean;
         Function Deleta(pId : Integer) : Boolean;
         Function AtualizaColecao(pCategorias: TColCategorias):Boolean;
      end;
implementation 

Function TCategoriasDao.RetornaSql : String;
begin
   Result := 
      'Select *         '+
      'From Categorias  ';
End;

Function TCategoriasDao.RetornaSqlComChave : String;
begin
   Result :=
      'Select  *        '+
      'From Categorias  '+
      'Where            '+
      ' ID = :ID        ';
End;

Function TCategoriasDao.RetornaSqlInsert : String;
begin
   Result :=
     'INSERT INTO Categorias (Categorias.Nome)  '+
     'VALUES (:Nome)                            ';
End;

Function TCategoriasDao.RetornaSqlUpdate : String;
begin
   Result := 
      'UPDATE Categorias SET      '+
      'Categorias.Nome  = :Nome   '+
      'Where                      '+
      ' ID = :ID                  ';
End;

Function TCategoriasDao.RetornaSqlDeleta : String;
begin
   Result :=
      'Delete From Categorias   '+
      'Where                    '+
      ' ID = :ID                ';
end;

function TCategoriasDao.RetornaColecao : TColCategorias;
var
   QueryCategorias : TFdQuery;
   ObjCategorias : TCategorias;
begin
   Result := nil;
   QueryCategorias := TFDQuery.Create(Nil);
   try
      QueryCategorias.Connection := Self.vConexao;
      QueryCategorias.Sql.Text := RetornaSql;
      QueryCategorias.Open;
      if QueryCategorias.IsEmpty then
         Exit;
      Result := TColCategorias.Create;
      while Not(QueryCategorias).Eof do
      begin
         ObjCategorias := TCategorias.Create;
         ObjCategorias.Id    := QueryCategorias.FieldByName('Id'  ).AsInteger;
         ObjCategorias.Nome  := QueryCategorias.FieldByName('Nome').AsString;
         Result.Adiciona(ObjCategorias);
         QueryCategorias.Next;
      end;
   finally
      FreeAndNil(QueryCategorias);
   end;
end;

constructor TCategoriasDao.Create(pConexao: TFDConnection);
begin
   Self.vConexao := pConexao;
end;

function TCategoriasDao.Retorna(pId : Integer) : TCategorias;
var
   QueryCategorias : TFdQuery;
begin
   Result := Nil;
   QueryCategorias := TFdQuery.Create(Nil);
   try
      QueryCategorias.Connection := Self.vConexao;
      QueryCategorias.Sql.Text := RetornaSqlComChave;
      QueryCategorias.ParamByName('ID').AsInteger := pId;
      QueryCategorias.Open;
      if QueryCategorias.IsEmpty then
         Exit;
      Result := TCategorias.Create;
      Result.Id    := QueryCategorias.FieldByName('Id'  ).AsInteger;
      Result.Nome  := QueryCategorias.FieldByName('Nome').AsString;
   finally
      FreeAndNil(QueryCategorias);
   end;
end;

Function TCategoriasDao.Insere(pCategorias: TCategorias) : Boolean;
var
   QueryCategorias : TFdQuery;
begin
   Result := False;
   QueryCategorias := TFdQuery.Create(Nil);
   try
      QueryCategorias.Connection := Self.vConexao;
      QueryCategorias.Sql.Text := RetornaSqlInsert;
      QueryCategorias.ParamByName('Nome').AsString := pCategorias.Nome;
      try
         QueryCategorias.ExecSql;
      except
         on E: Exception do
         begin
            raise Exception.Create('Ocorreu um erro ao tentar inserir os dados '+
               'da tabela CATEGORIAS.' + #13 +
               'Motivo: ' + e.Message);
         end;
      end;
   finally
      FreeAndNil(QueryCategorias);
   end;
   Result := True;
end;

Function TCategoriasDao.InsereColecao(pCategorias: TColCategorias) : Boolean;
var
   indice: Integer;
begin
   Result := False;
   for indice := 0 to pCategorias.count -1 do
   begin
      if not Self.Insere(pCategorias.Retorna(Indice)) then
         Exit;
   end;
   Result := True;
end;

Function TCategoriasDao.Atualiza(pCategorias: TCategorias) : Boolean;
var
   QueryCategorias : TFdQuery;
begin
   Result := False;
   QueryCategorias := TFdQuery.Create(Nil);
   try
      QueryCategorias.Connection := Self.vConexao;
      QueryCategorias.Sql.Text := RetornaSqlUpdate;
      QueryCategorias.ParamByName('Id'  ).AsInteger := pCategorias.Id;
      QueryCategorias.ParamByName('Nome').AsString  := pCategorias.Nome;
      try
         QueryCategorias.ExecSql;
      except
         on E: Exception do
         begin
            raise Exception.Create('Ocorreu um erro ao tentar atualizar os dados '+
               'da tabela CATEGORIAS.' + #13 + 'Motivo: ' + e.Message);
         end;
      end;
   finally
      FreeAndNil(QueryCategorias);
   end;
   Result := True;
end;

Function TCategoriasDao.Deleta(pId : Integer) : Boolean;
var
   QueryCategorias : TFdQuery;
begin
   Result := False;
   QueryCategorias := TFdQuery.Create(Nil);
   try
      QueryCategorias.Connection := Self.vConexao;
      QueryCategorias.Sql.Text := RetornaSqlDeleta;
      QueryCategorias.ParamByName('ID').AsInteger := pID;
      try
         QueryCategorias.ExecSql;
      except
         on E: Exception do
         begin
            raise Exception.Create('Ocorreu um erro ao tentar apagar os dados '+               'da tabela CATEGORIAS.' + #13 + 'Motivo: ' + e.Message);         end;
      end;
   finally
      FreeAndNil(QueryCategorias);
   end;
   Result := True;
end;

Function TCategoriasDao.AtualizaColecao(pCategorias: TColCategorias):Boolean;
var
   indice: Integer;
begin
   Result := True;
   for indice := 0 to pCategorias.count -1 do
   begin
      if not Self.Atualiza(pCategorias.Retorna(Indice)) then
      begin
         Result := False;
         Exit;
      end;
   end;
end;
end.
