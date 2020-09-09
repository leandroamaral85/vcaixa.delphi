unit DAO.Empresas;

interface 

uses SqlExpr, SimpleDS, Classes, SysUtils, DateUtils,
     StdCtrls, UEmpresas, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.PG,
     FireDAC.Phys.PGDef, FireDAC.ConsoleUI.Wait, Data.DB, FireDAC.Comp.Client;

type
   TEmpresasDao = Class 
      Private
         vConexao : TFDConnection;
         Function RetornaSql : String;
         Function RetornaSqlComChave : String;
         Function RetornaSqlInsert : String;
         Function RetornaSqlUpdate : String;
         Function RetornaSqlDeleta : String;
      Public
         Constructor Create(pConexao : TFDConnection);
         Function RetornaColecao : TColEmpresas;
         Function Retorna(pId : Integer) : TEmpresas;
         Function Insere(pEmpresas: TEmpresas) : Boolean;
         Function InsereColecao(pEmpresas: TColEmpresas) : Boolean;
         Function Atualiza(pEmpresas: TEmpresas) : Boolean;
         Function Deleta(pId : Integer) : Boolean;
         Function AtualizaColecao(pEmpresas: TColEmpresas):Boolean;
      end;
implementation 

Function TEmpresasDao.RetornaSql : String;
begin
   Result := 
      'Select *      '+
      'From Empresas ';
End;


Function TEmpresasDao.RetornaSqlComChave : String;
begin
   Result := 
      'Select *          '+
      'From Empresas     '+
      'Where             '+
      ' ID = :ID         ';

End;

Function TEmpresasDao.RetornaSqlInsert : String;
begin
   Result := 
      'INSERT INTO Empresas(Empresas.Nome, Empresas.Cnpj) '+
      'VALUES (:Nome, :Cnpj)                              ';
End;

Function TEmpresasDao.RetornaSqlUpdate : String;
begin
   Result := 
      'UPDATE Empresas SET     '+
      'Empresas.Nome = :Nome,  '+
      'Empresas.Cnpj = :Cnpj   '+
      'Where                   '+
      ' ID = :ID               ';
End;

Function TEmpresasDao.RetornaSqlDeleta : String;
begin
   Result :=
     'Delete From Empresas '+
     'Where                '+
     ' ID = :ID            ';
end;

function TEmpresasDao.RetornaColecao : TColEmpresas;
var
   QueryEmpresas : TFDQuery;
   ObjEmpresas : TEmpresas;
begin
   Result := nil;
   QueryEmpresas := TFDQuery.Create(Nil);
   try
      QueryEmpresas.Connection := Self.vConexao;
      QueryEmpresas.Sql.Text := RetornaSql;
      QueryEmpresas.Open;
      if QueryEmpresas.IsEmpty then
         Exit;
      Result := TColEmpresas.Create;
      while Not(QueryEmpresas).Eof do
      begin
         ObjEmpresas := TEmpresas.Create;
         ObjEmpresas.Id    := QueryEmpresas.FieldByName('Id'  ).AsInteger;
         ObjEmpresas.Nome  := QueryEmpresas.FieldByName('Nome').AsString;
         ObjEmpresas.Cnpj  := QueryEmpresas.FieldByName('Cnpj').AsString;
         Result.Adiciona(ObjEmpresas);
         QueryEmpresas.Next;
      end;
   finally
      FreeAndNil(QueryEmpresas);
   end;
end;

constructor TEmpresasDao.Create(pConexao: TFDConnection);
begin
   Self.vConexao := pConexao;
end;

function TEmpresasDao.Retorna(pId : Integer) : TEmpresas;
var
   QueryEmpresas : TFDQuery;
begin
   Result := Nil;
   QueryEmpresas := TFDQuery.Create(Nil);
   try
      QueryEmpresas.Connection := Self.vConexao;
      QueryEmpresas.Sql.Text := RetornaSqlComChave;
      QueryEmpresas.ParamByName('ID').AsInteger := pID;
      QueryEmpresas.Open;
      if QueryEmpresas.IsEmpty then
         Exit;
      Result := TEmpresas.Create;
      Result.Id    := QueryEmpresas.FieldByName('Id'  ).AsInteger;
      Result.Nome  := QueryEmpresas.FieldByName('Nome').AsString;
      Result.Cnpj  := QueryEmpresas.FieldByName('Cnpj').AsString;
   finally
      FreeAndNil(QueryEmpresas);
   end;
end;

Function TEmpresasDao.Insere(pEmpresas: TEmpresas) : Boolean;
var
   QueryEmpresas : TFDQuery;
begin
   Result := False;
   QueryEmpresas := TFDQuery.Create(Nil);
   try
      QueryEmpresas.Connection := Self.vConexao;
      QueryEmpresas.Sql.Text := RetornaSqlInsert;
      QueryEmpresas.ParamByName('Nome').AsString := pEmpresas.Nome   ;
      QueryEmpresas.ParamByName('Cnpj').AsString := pEmpresas.Cnpj   ;
      try
         QueryEmpresas.ExecSql;
      except
         on E: Exception do
         begin
            raise Exception.Create('Ocorreu um erro ao tentar inserir os dados '+
               'da tabela EMPRESAS.' + #13 + 'Motivo: ' + e.Message);
         end;
      end;
   finally
      FreeAndNil(QueryEmpresas);
   end;
   Result := True;
end;

Function TEmpresasDao.InsereColecao(pEmpresas: TColEmpresas) : Boolean;
var
   indice: Integer;
begin
   Result := False;
   for indice := 0 to pEmpresas.count -1 do
      begin
      if not Self.Insere(pEmpresas.Retorna(Indice)) then
         Exit;
   end;
   Result := True;
end;

Function TEmpresasDao.Atualiza(pEmpresas: TEmpresas) : Boolean;
var
   QueryEmpresas : TFDQuery;
begin
   Result := False;
   QueryEmpresas := TFDQuery.Create(Nil);
   try
      QueryEmpresas.Connection := Self.vConexao;
      QueryEmpresas.Sql.Text := RetornaSqlUpdate;
      QueryEmpresas.ParamByName('Id'  ).AsInteger := pEmpresas.Id;
      QueryEmpresas.ParamByName('Nome').AsString  := pEmpresas.Nome;
      QueryEmpresas.ParamByName('Cnpj').AsString  := pEmpresas.Cnpj;
      try
         QueryEmpresas.ExecSql;
      except
         on E: Exception do
         begin
            raise Exception.Create('Ocorreu um erro ao tentar atualizar os dados '+
               'da tabela EMPRESAS.' + #13 + 'Motivo: ' + e.Message);
         end;
      end;
   finally
      FreeAndNil(QueryEmpresas);
   end;
   Result := True;
end;

Function TEmpresasDao.Deleta(pId : Integer) : Boolean;
var
   QueryEmpresas : TFDQuery;
begin
   Result := False;
   QueryEmpresas := TFDQuery.Create(Nil);
   try
      QueryEmpresas.Connection := Self.vConexao;
      QueryEmpresas.Sql.Text := RetornaSqlDeleta;
      QueryEmpresas.ParamByName('ID').AsInteger := pId;
      try
         QueryEmpresas.ExecSql;
      except
         on E: Exception do
         begin
            raise Exception.Create('Ocorreu um erro ao tentar apagar os dados '+               'da tabela EMPRESAS.' + #13 + 'Motivo: ' + e.Message);         end;
      end;
   finally
      FreeAndNil(QueryEmpresas);
   end;
   Result := True;
end;

Function TEmpresasDao.AtualizaColecao(pEmpresas: TColEmpresas):Boolean;
var
   indice: Integer;
begin
   Result := True;
   for indice := 0 to pEmpresas.count -1 do
   begin
      if not Self.Atualiza(pEmpresas.Retorna(Indice)) then
      begin
         Result := False;
         Exit;
      end;
   end;
end;
end.
