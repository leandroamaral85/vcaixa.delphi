unit DAO.MOvimentacoes;

interface 

uses SqlExpr, SimpleDS, Classes, SysUtils, DateUtils,
     StdCtrls, UMovimentacoes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.PG,
     FireDAC.Phys.PGDef, FireDAC.ConsoleUI.Wait, Data.DB, FireDAC.Comp.Client;

type
   TMovimentacoesDao = Class
      Private
         vConexao : TFDConnection;
         Function RetornaSql : String;
         Function RetornaSqlComChave : String;
         Function RetornaSqlInsert : String;
         Function RetornaSqlUpdate : String;
         Function RetornaSqlDeleta : String;
      Public
         Constructor Create(pConexao : TFDConnection);
         Function RetornaColecao : TColMovimentacoes;
         Function Retorna(pId : Integer) : TMovimentacoes;
         Function Insere(pMovimentacoes: TMovimentacoes) : Boolean;
         Function InsereColecao(pMovimentacoes: TColMovimentacoes) : Boolean;
         Function Atualiza(pMovimentacoes: TMovimentacoes) : Boolean;
         Function Deleta(pId : Integer) : Boolean;
         Function AtualizaColecao(pMovimentacoes: TColMovimentacoes):Boolean;
      end;
implementation 

Function TMovimentacoesDao.RetornaSql : String;
begin
   Result :=
      'Select *            '+
      'From Movimentacoes  ';
End;

Function TMovimentacoesDao.RetornaSqlComChave : String;
begin
   Result := 
      'Select *             '+
      'From Movimentacoes   '+
      'Where                '+
      ' ID = :ID            ';
End;

Function TMovimentacoesDao.RetornaSqlInsert : String;
begin
   Result := 
      'INSERT INTO Movimentacoes   '+
      '(                           '+
      'Movimentacoes.Categoria_id, '+
      'Movimentacoes.Empresa_id,   '+
      'Movimentacoes.Data,         '+
      'Movimentacoes.Tipo,         '+
      'Movimentacoes.Valor,        '+
      'Movimentacoes.Descricao     '+
      ')                           '+
      'VALUES                      '+
      '(                           '+
      ':Categoria_id,              '+
      ':Empresa_id,                '+
      ':Data,                      '+
      ':Tipo,                      '+
      ':Valor,                     '+
      ':Descricao                  '+
      ')                           ';
End;

Function TMovimentacoesDao.RetornaSqlUpdate : String;
begin
   Result := 
      'UPDATE Movimentacoes SET                      '+
      'Movimentacoes.Categoria_id  = :Categoria_id,  '+
      'Movimentacoes.Empresa_id    = :Empresa_id,    '+
      'Movimentacoes.Data          = :Data,          '+
      'Movimentacoes.Tipo          = :Tipo,          '+
      'Movimentacoes.Valor         = :Valor,         '+
      'Movimentacoes.Descricao     = :Descricao      '+
      'Where                                         '+
      ' ID = :ID                                     ';
End;

Function TMovimentacoesDao.RetornaSqlDeleta : String;
begin
   Result :=
      'Delete From Movimentacoes  '+
      'Where                      '+
      ' ID = :ID                  ';
end;

function TMovimentacoesDao.RetornaColecao : TColMovimentacoes;
var
   QueryMovimentacoes : TFDQuery;
   ObjMovimentacoes : TMovimentacoes;
begin
   Result := nil;
   QueryMovimentacoes := TFDQuery.Create(Nil);
   try
      QueryMovimentacoes.Connection := Self.vConexao;
      QueryMovimentacoes.Sql.Text := RetornaSql;
      QueryMovimentacoes.Open;
      if QueryMovimentacoes.IsEmpty then
         Exit;
      Result := TColMovimentacoes.Create;
      while Not(QueryMovimentacoes).Eof do
      begin
         ObjMovimentacoes := TMovimentacoes.Create;
         ObjMovimentacoes.Id            := QueryMovimentacoes.FieldByName('Id'           ).AsInteger;
         ObjMovimentacoes.Categoria_id  := QueryMovimentacoes.FieldByName('Categoria_id' ).AsInteger;
         ObjMovimentacoes.Empresa_id    := QueryMovimentacoes.FieldByName('Empresa_id'   ).AsInteger;
         ObjMovimentacoes.Data          := QueryMovimentacoes.FieldByName('Data'         ).AsDateTime;
         ObjMovimentacoes.Tipo          := QueryMovimentacoes.FieldByName('Tipo'         ).AsString;
         ObjMovimentacoes.Valor         := QueryMovimentacoes.FieldByName('Valor'        ).AsFloat;
         ObjMovimentacoes.Descricao     := QueryMovimentacoes.FieldByName('Descricao'    ).AsString;
         Result.Adiciona(ObjMovimentacoes);
         QueryMovimentacoes.Next;
      end;
   finally
      FreeAndNil(QueryMovimentacoes);
   end;
end;

constructor TMovimentacoesDao.Create(pConexao: TFDConnection);
begin
   Self.vConexao := pConexao;
end;

function TMovimentacoesDao.Retorna(pId : Integer) : TMovimentacoes;
var
   QueryMovimentacoes : TFDQuery;
begin
   Result := Nil;
   QueryMovimentacoes := TFDQuery.Create(Nil);
   try
      QueryMovimentacoes.Connection := Self.vConexao;
      QueryMovimentacoes.Sql.Text := RetornaSqlComChave;
      QueryMovimentacoes.ParamByName('ID'           ).AsInteger   := pID;
      QueryMovimentacoes.Open;
      if QueryMovimentacoes.IsEmpty then
         Exit;
      Result := TMovimentacoes.Create;
      Result.Id            := QueryMovimentacoes.FieldByName('Id'           ).AsInteger;
      Result.Categoria_id  := QueryMovimentacoes.FieldByName('Categoria_id' ).AsInteger;
      Result.Empresa_id    := QueryMovimentacoes.FieldByName('Empresa_id'   ).AsInteger;
      Result.Data          := QueryMovimentacoes.FieldByName('Data'         ).AsDateTime;
      Result.Tipo          := QueryMovimentacoes.FieldByName('Tipo'         ).AsString;
      Result.Valor         := QueryMovimentacoes.FieldByName('Valor'        ).AsFloat;
      Result.Descricao     := QueryMovimentacoes.FieldByName('Descricao'    ).AsString;
   finally
      FreeAndNil(QueryMovimentacoes);
   end;
end;

Function TMovimentacoesDao.Insere(pMovimentacoes: TMovimentacoes) : Boolean;
var
   QueryMovimentacoes : TFDQuery;
begin
   Result := False;
   QueryMovimentacoes := TFDQuery.Create(Nil);
   try
      QueryMovimentacoes.Connection := Self.vConexao;
      QueryMovimentacoes.Sql.Text := RetornaSqlInsert;
      QueryMovimentacoes.ParamByName('Categoria_id' ).AsInteger := pMovimentacoes.Categoria_id;
      QueryMovimentacoes.ParamByName('Empresa_id'   ).AsInteger := pMovimentacoes.Empresa_id;
      QueryMovimentacoes.ParamByName('Data'         ).AsDate    := pMovimentacoes.Data;
      QueryMovimentacoes.ParamByName('Tipo'         ).AsString  := pMovimentacoes.Tipo;
      QueryMovimentacoes.ParamByName('Valor'        ).AsFloat   := pMovimentacoes.Valor;
      QueryMovimentacoes.ParamByName('Descricao'    ).AsString  := pMovimentacoes.Descricao;
      try
         QueryMovimentacoes.ExecSql;
      except
         on E: Exception do
         begin
            raise Exception.Create('Ocorreu um erro ao tentar inserir os dados '+
               'da tabela MOVIMENTACOES.' + #13 + 'Motivo: ' + e.Message);
         end;
      end;
   finally
      FreeAndNil(QueryMovimentacoes);
   end;
   Result := True;
end;

Function TMovimentacoesDao.InsereColecao(pMovimentacoes: TColMovimentacoes) : Boolean;
var
   indice: Integer;
begin
   Result := False;
   for indice := 0 to pMovimentacoes.count -1 do
   begin
      if not Self.Insere(pMovimentacoes.Retorna(Indice)) then
         Exit;
   end;
   Result := True;
end;

Function TMovimentacoesDao.Atualiza(pMovimentacoes: TMovimentacoes) : Boolean;
var
   QueryMovimentacoes : TFDQuery;
begin
   Result := False;
   QueryMovimentacoes := TFDQuery.Create(Nil);
   try
      QueryMovimentacoes.Connection := Self.vConexao;
      QueryMovimentacoes.Sql.Text := RetornaSqlUpdate;
      QueryMovimentacoes.ParamByName('Id'           ).AsInteger := pMovimentacoes.Id;
      QueryMovimentacoes.ParamByName('Categoria_id' ).AsInteger := pMovimentacoes.Categoria_id;
      QueryMovimentacoes.ParamByName('Empresa_id'   ).AsInteger := pMovimentacoes.Empresa_id;
      QueryMovimentacoes.ParamByName('Data'         ).AsDate    := pMovimentacoes.Data;
      QueryMovimentacoes.ParamByName('Tipo'         ).AsString  := pMovimentacoes.Tipo;
      QueryMovimentacoes.ParamByName('Valor'        ).AsFloat   := pMovimentacoes.Valor;
      QueryMovimentacoes.ParamByName('Descricao'    ).AsString  := pMovimentacoes.Descricao;
      try
         QueryMovimentacoes.ExecSql;
      except
         on E: Exception do
         begin
            raise Exception.Create('Ocorreu um erro ao tentar atualizar os dados '+
               'da tabela MOVIMENTACOES.' + #13 + 'Motivo: ' + e.Message);
         end;
      end;
   finally
      FreeAndNil(QueryMovimentacoes);
   end;
   Result := True;
end;

Function TMovimentacoesDao.Deleta(pId : Integer) : Boolean;
var
   QueryMovimentacoes : TFDQuery;
begin
   Result := False;
   QueryMovimentacoes := TFDQuery.Create(Nil);
   try
      QueryMovimentacoes.Connection := Self.vConexao;
      QueryMovimentacoes.Sql.Text := RetornaSqlDeleta;
      QueryMovimentacoes.ParamByName('ID').AsInteger := pId;
      try
         QueryMovimentacoes.ExecSql;
      except
         on E: Exception do
         begin
            raise Exception.Create('Ocorreu um erro ao tentar apagar os dados '+               'da tabela MOVIMENTACOES.' + #13 + 'Motivo: ' + e.Message);         end;
      end;
   finally
      FreeAndNil(QueryMovimentacoes);
   end;
   Result := True;
end;

Function TMovimentacoesDao.AtualizaColecao(pMovimentacoes: TColMovimentacoes):Boolean;
var
   indice: Integer;
begin
   Result := True;
   for indice := 0 to pMovimentacoes.count -1 do
   begin
      if not Self.Atualiza(pMovimentacoes.Retorna(Indice)) then
      begin
         Result := False;
         Exit;
      end;
   end;
end;
end.
