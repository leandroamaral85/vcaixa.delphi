unit UMovimentacoes;
                                           
interface                                  
                                           
uses SysUtils, Classes;                    
                                           
type

   TMovimentacoes = Class(TPersistent) 
      private
         vId            : Integer;
         vCategoria_id  : Integer;
         vEmpresa_id    : Integer;
         vData          : TDateTime;
         vTipo          : String;
         vValor         : Double;
         vDescricao     : String;
      public
         constructor Create;
      published
         property Id            : Integer     read vId            write vId;
         property Categoria_id  : Integer     read vCategoria_id  write vCategoria_id;
         property Empresa_id    : Integer     read vEmpresa_id    write vEmpresa_id;
         property Data          : TDateTime   read vData          write vData;
         property Tipo          : String      read vTipo          write vTipo;
         property Valor         : Double      read vValor         write vValor;
         property Descricao     : String      read vDescricao     write vDescricao;
   end;

   TColMovimentacoes = Class(TList) 
      public
         function  Retorna(pIndex: Integer): TMovimentacoes;
         procedure Adiciona(pMovimentacoes : TMovimentacoes);
   end; 

implementation 

constructor TMovimentacoes.Create;
begin
   Self.vID           := 0;
   Self.vCATEGORIA_ID := 0;
   Self.vEMPRESA_ID   := 0;
   Self.vDATA         := 0;
   Self.vTIPO         := EmptyStr;
   Self.vVALOR        := 0;
   Self.vDESCRICAO    := EmptyStr;
end;

function TColMovimentacoes.Retorna(pIndex: Integer): TMovimentacoes;
begin
   Result := TMovimentacoes(Self[pIndex]);
end;

procedure TColMovimentacoes.Adiciona(pMovimentacoes: TMovimentacoes);
begin
   Self.Add(TMovimentacoes(pMovimentacoes));
end;
end.
