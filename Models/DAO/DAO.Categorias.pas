unit DAO.Categorias;

interface 

uses SqlExpr, SimpleDS, Classes, SysUtils, DateUtils,
     StdCtrls, Model.Categorias, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.PG,
     FireDAC.Phys.PGDef, FireDAC.ConsoleUI.Wait, Data.DB, FireDAC.Comp.Client,
     System.Generics.Collections;

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
         Function RetornaColecao : TObjectList<TCategoria>;
         Function Retorna(pId : Integer) : TCategoria;
         Function Insere(pCategorias: TCategoria) : Boolean;
         Function InsereColecao(pCategorias: TObjectList<TCategoria>) : Boolean;
         Function Atualiza(pCategorias: TCategoria) : Boolean;
         Function Deleta(pId : Integer) : Boolean;
         Function AtualizaColecao(pCategorias: TObjectList<TCategoria>):Boolean;
         Function Existe(pId: Integer): Boolean;
      end;
implementation 

Function TCategoriasDao.RetornaSql : String;
begin
   Result := 
      'SELECT *         '+
      'FROM CATEGORIAS  '+
      'ORDER BY ID      ';
End;

Function TCategoriasDao.RetornaSqlComChave : String;
begin
   Result :=
      'SELECT  *        '+
      'FROM CATEGORIAS  '+
      'WHERE ID = :ID   ';
End;

Function TCategoriasDao.RetornaSqlInsert : String;
begin
   Result :=
      'INSERT INTO CATEGORIAS (NOME)  '+
      'VALUES (:NOME)                 ';
End;

Function TCategoriasDao.RetornaSqlUpdate : String;
begin
   Result := 
      'UPDATE CATEGORIAS '+
      'SET NOME = :NOME  '+
      'WHERE ID = :ID    ';
End;

Function TCategoriasDao.RetornaSqlDeleta : String;
begin
   Result :=
      'DELETE FROM CATEGORIAS   '+
      'WHERE ID = :ID           ';
end;

function TCategoriasDao.RetornaColecao : TObjectList<TCategoria>;
var
   QueryCategorias : TFdQuery;
   ObjCategorias : TCategoria;
begin
   Result := nil;
   QueryCategorias := TFDQuery.Create(Nil);
   Result := TObjectList<TCategoria>.Create;
   try
      QueryCategorias.Connection := Self.vConexao;
      QueryCategorias.Sql.Text := RetornaSql;
      QueryCategorias.Open;
      if QueryCategorias.IsEmpty then
         Exit;
      while Not(QueryCategorias).Eof do
      begin
         ObjCategorias := TCategoria.Create;
         ObjCategorias.Id    := QueryCategorias.FieldByName('Id'  ).AsInteger;
         ObjCategorias.Nome  := QueryCategorias.FieldByName('Nome').AsString;
         Result.Add(ObjCategorias);
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

function TCategoriasDao.Retorna(pId : Integer) : TCategoria;
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
      Result := TCategoria.Create;
      Result.Id    := QueryCategorias.FieldByName('Id'  ).AsInteger;
      Result.Nome  := QueryCategorias.FieldByName('Nome').AsString;
   finally
      FreeAndNil(QueryCategorias);
   end;
end;

Function TCategoriasDao.Insere(pCategorias: TCategoria) : Boolean;
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

Function TCategoriasDao.InsereColecao(pCategorias: TObjectList<TCategoria>) : Boolean;
var
   indice: Integer;
begin
   Result := False;
   for indice := 0 to pCategorias.count -1 do
   begin
      if not Self.Insere(pCategorias[Indice]) then
         Exit;
   end;
   Result := True;
end;

Function TCategoriasDao.Atualiza(pCategorias: TCategoria) : Boolean;
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

Function TCategoriasDao.AtualizaColecao(pCategorias: TObjectList<TCategoria>):Boolean;
var
   indice: Integer;
begin
   Result := True;
   for indice := 0 to pCategorias.Count -1 do
   begin
      if not Self.Atualiza(pCategorias[Indice]) then
      begin
         Result := False;
         Exit;
      end;
   end;
end;

function TCategoriasDao.Existe(pId : Integer) : Boolean;
var
   QueryCategorias : TFdQuery;
begin
   Result := false;
   QueryCategorias := TFdQuery.Create(Nil);
   try
      QueryCategorias.Connection := Self.vConexao;
      QueryCategorias.Sql.Text := RetornaSqlComChave;
      QueryCategorias.ParamByName('ID').AsInteger := pId;
      QueryCategorias.Open;
      Result := not QueryCategorias.IsEmpty;
   finally
      FreeAndNil(QueryCategorias);
   end;
end;
end.
