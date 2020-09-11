unit DAO.Movimentacoes;

interface 

uses SqlExpr, SimpleDS, Classes, SysUtils, DateUtils,
     StdCtrls, Model.Movimentacoes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.PG,
     FireDAC.Phys.PGDef, FireDAC.ConsoleUI.Wait, Data.DB, FireDAC.Comp.Client,
     System.Generics.Collections, Model.ResumoDiario, DAO.Categorias;

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
         Function RetornaColecao(pIdEmpresa : Integer) : TObjectList<TMovimentacao>;
         Function Retorna(pId : Integer) : TMovimentacao;
         Function Insere(pMovimentacoes: TMovimentacao) : Boolean;
         Function InsereColecao(pMovimentacoes: TObjectList<TMovimentacao>) : Boolean;
         Function Atualiza(pMovimentacoes: TMovimentacao) : Boolean;
         Function Deleta(pId : Integer) : Boolean;
         Function AtualizaColecao(pMovimentacoes: TObjectList<TMovimentacao>):Boolean;
         Function Existe(pId: Integer): Boolean;
         Function ExisteMovimentacaoParaCategoria(pId_Categoria: Integer): Boolean;
         Function ExisteMovimentacaoParaEmpresa(pId_Empresa: Integer): Boolean;
         Function RetornaResumoDiario(pIDEmpresa: Integer): TResumoDiario;
      end;
implementation

Function TMovimentacoesDao.RetornaSql : String;
begin
   Result :=
      'SELECT *            '+
      'FROM MOVIMENTACOES  '+
      'ORDER BY ID         ';
End;

Function TMovimentacoesDao.RetornaSqlComChave : String;
begin
   Result := 
      'SELECT *           '+
      'FROM MOVIMENTACOES '+
      'WHERE ID = :ID     ';
End;

Function TMovimentacoesDao.RetornaSqlInsert : String;
begin
   Result := 
      'INSERT INTO MOVIMENTACOES (CATEGORIA_ID, EMPRESA_ID, DATA, TIPO, VALOR, DESCRICAO) '+
      'VALUES (:CATEGORIA_ID, :EMPRESA_ID, :DATA, :TIPO, :VALOR, :DESCRICAO)              ';
End;

Function TMovimentacoesDao.RetornaSqlUpdate : String;
begin
   Result := 
      'UPDATE MOVIMENTACOES              '+
      'SET CATEGORIA_ID = :CATEGORIA_ID, '+
      '    EMPRESA_ID = :EMPRESA_ID,     '+
      '    DATA = :DATA,                 '+
      '    TIPO = :TIPO,                 '+
      '    VALOR = :VALOR,               '+
      '    DESCRICAO = :DESCRICAO        '+
      'WHERE ID = :ID                    ';
End;

Function TMovimentacoesDao.RetornaSqlDeleta : String;
begin
   Result :=
      'DELETE FROM MOVIMENTACOES  '+
      'WHERE ID = :ID             ';
end;

function TMovimentacoesDao.RetornaColecao(pIdEmpresa : Integer) : TObjectList<TMovimentacao>;
var
   QueryMovimentacoes : TFDQuery;
   ObjMovimentacoes : TMovimentacao;
begin
   Result := nil;
   QueryMovimentacoes := TFDQuery.Create(Nil);
   Result := TObjectList<TMovimentacao>.Create;
   try
      QueryMovimentacoes.Connection := Self.vConexao;
      QueryMovimentacoes.Sql.Text :=
        'SELECT *                      '+
        'FROM MOVIMENTACOES            '+
        'WHERE EMPRESA_ID = EMPRESA_ID ';
      QueryMovimentacoes.ParamByName('EMPRESA_ID').AsInteger := pIdEmpresa;
      QueryMovimentacoes.Open;
      if QueryMovimentacoes.IsEmpty then
         Exit;
      while Not(QueryMovimentacoes).Eof do
      begin
         ObjMovimentacoes := TMovimentacao.Create;
         ObjMovimentacoes.Id            := QueryMovimentacoes.FieldByName('Id'           ).AsInteger;
         ObjMovimentacoes.Categoria_id  := QueryMovimentacoes.FieldByName('Categoria_id' ).AsInteger;
         ObjMovimentacoes.Empresa_id    := QueryMovimentacoes.FieldByName('Empresa_id'   ).AsInteger;
         ObjMovimentacoes.Data          := QueryMovimentacoes.FieldByName('Data'         ).AsDateTime;
         ObjMovimentacoes.Tipo          := QueryMovimentacoes.FieldByName('Tipo'         ).AsString;
         ObjMovimentacoes.Valor         := QueryMovimentacoes.FieldByName('Valor'        ).AsFloat;
         ObjMovimentacoes.Descricao     := QueryMovimentacoes.FieldByName('Descricao'    ).AsString;
         Result.Add(ObjMovimentacoes);
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

function TMovimentacoesDao.Retorna(pId : Integer) : TMovimentacao;
var
   QueryMovimentacoes : TFDQuery;
begin
   Result := Nil;
   QueryMovimentacoes := TFDQuery.Create(Nil);
   try
      QueryMovimentacoes.Connection := Self.vConexao;
      QueryMovimentacoes.Sql.Text := RetornaSqlComChave;
      QueryMovimentacoes.ParamByName('ID').AsInteger := pID;
      QueryMovimentacoes.Open;
      if QueryMovimentacoes.IsEmpty then
         Exit;
      Result := TMovimentacao.Create;
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

Function TMovimentacoesDao.Insere(pMovimentacoes: TMovimentacao) : Boolean;
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

Function TMovimentacoesDao.InsereColecao(pMovimentacoes: TObjectList<TMovimentacao>) : Boolean;
var
   indice: Integer;
begin
   Result := False;
   for indice := 0 to pMovimentacoes.count -1 do
   begin
      if not Self.Insere(pMovimentacoes[Indice]) then
         Exit;
   end;
   Result := True;
end;

Function TMovimentacoesDao.Atualiza(pMovimentacoes: TMovimentacao) : Boolean;
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

Function TMovimentacoesDao.AtualizaColecao(pMovimentacoes: TObjectList<TMovimentacao>):Boolean;
var
   indice: Integer;
begin
   Result := True;
   for indice := 0 to pMovimentacoes.count -1 do
   begin
      if not Self.Atualiza(pMovimentacoes[Indice]) then
      begin
         Result := False;
         Exit;
      end;
   end;
end;

function TMovimentacoesDao.Existe(pId : Integer) : Boolean;
var
   QueryMovimentacoes : TFDQuery;
begin
   Result := False;
   QueryMovimentacoes := TFDQuery.Create(Nil);
   try
      QueryMovimentacoes.Connection := Self.vConexao;
      QueryMovimentacoes.Sql.Text := RetornaSqlComChave;
      QueryMovimentacoes.ParamByName('ID').AsInteger := pID;
      QueryMovimentacoes.Open;
      Result := not QueryMovimentacoes.IsEmpty;
   finally
      FreeAndNil(QueryMovimentacoes);
   end;
end;

function TMovimentacoesDao.ExisteMovimentacaoParaEmpresa(pId_Empresa : Integer) : Boolean;
var
   QueryMovimentacoes : TFDQuery;
begin
   Result := False;
   QueryMovimentacoes := TFDQuery.Create(Nil);
   try
      QueryMovimentacoes.Connection := Self.vConexao;
      QueryMovimentacoes.Sql.Text :=
         'SELECT FIRST 1 ID      '+
         'FROM MOVIMENTACOES     '+
         'WHERE EMPRESA_ID = :ID ';
      QueryMovimentacoes.ParamByName('ID').AsInteger := pId_Empresa;
      QueryMovimentacoes.Open;
      Result := not QueryMovimentacoes.IsEmpty;
   finally
      FreeAndNil(QueryMovimentacoes);
   end;
end;

function TMovimentacoesDao.ExisteMovimentacaoParaCategoria(pId_Categoria : Integer) : Boolean;
var
   QueryMovimentacoes : TFDQuery;
begin
   Result := False;
   QueryMovimentacoes := TFDQuery.Create(Nil);
   try
      QueryMovimentacoes.Connection := Self.vConexao;
      QueryMovimentacoes.Sql.Text :=
         'SELECT FIRST 1 ID      '+
         'FROM MOVIMENTACOES     '+
         'WHERE CATEGORIA_ID = :ID ';
      QueryMovimentacoes.ParamByName('ID').AsInteger := pId_Categoria;
      QueryMovimentacoes.Open;
      Result := not QueryMovimentacoes.IsEmpty;
   finally
      FreeAndNil(QueryMovimentacoes);
   end;
end;

function TMovimentacoesDao.RetornaResumoDiario(pIDEmpresa : Integer): TResumoDiario;
var
   QueryMovimentacoes : TFDQuery;
   vMovimento : TMovimento;
   vSaldoTotal: Double;
   vCategoriasDAO : TCategoriasDao;
begin
   Result := TResumoDiario.Create;
   vCategoriasDAO := TCategoriasDao.Create(Self.vConexao);
   QueryMovimentacoes := TFDQuery.Create(Nil);
   vSaldoTotal := 0;
   try
      QueryMovimentacoes.Connection := Self.vConexao;
      QueryMovimentacoes.Sql.Text :=
        'SELECT *                       '+
        'FROM MOVIMENTACOES             '+
        'WHERE EMPRESA_ID = :EMPRESA_ID '+
        '  AND DATA = :DATA             ';
      QueryMovimentacoes.ParamByName('Empresa_ID').AsInteger := pIDEmpresa;
      QueryMovimentacoes.ParamByName('Data').AsDate := Date;
      QueryMovimentacoes.Open;
      if QueryMovimentacoes.IsEmpty then
         Exit;
      while Not(QueryMovimentacoes).Eof do
      begin
         vMovimento := TMovimento.Create;
         vMovimento.Id        := QueryMovimentacoes.FieldByName('Id').AsInteger;
         vMovimento.Categoria := vCategoriasDAO.Retorna(QueryMovimentacoes.FieldByName('Categoria_id').AsInteger);
         vMovimento.Data      := QueryMovimentacoes.FieldByName('Data').AsDateTime;
         vMovimento.Tipo      := QueryMovimentacoes.FieldByName('Tipo').AsString;
         vMovimento.Valor     := QueryMovimentacoes.FieldByName('Valor').AsFloat;
         vMovimento.Descricao := QueryMovimentacoes.FieldByName('Descricao').AsString;
         if vMovimento.Tipo = 'ENTRADA' then
            vSaldoTotal := vSaldoTotal + vMovimento.Valor
         else
            vSaldoTotal := vSaldoTotal - vMovimento.Valor;
         Result.movimentacoes.Add(vMovimento);
         QueryMovimentacoes.Next;
      end;

      Result.saldoTotal := vSaldoTotal;
   finally
      FreeAndNil(QueryMovimentacoes);
      FreeAndNil(vCategoriasDAO);
   end;
end;

end.
