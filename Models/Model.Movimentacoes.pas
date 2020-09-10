unit Model.Movimentacoes;
                                           
interface                                  
                                           
uses SysUtils, Classes;                    
                                           
type

   TMovimentacao = Class(TPersistent)
      private
         vId            : Integer;
         vCategoria_id  : Integer;
         vEmpresa_id    : Integer;
         vData          : TDate;
         vTipo          : String;
         vValor         : Double;
         vDescricao     : String;
      public
         constructor Create;
      published
         property id            : Integer     read vId            write vId;
         property categoria_id  : Integer     read vCategoria_id  write vCategoria_id;
         property empresa_id    : Integer     read vEmpresa_id    write vEmpresa_id;
         property data          : TDate       read vData          write vData;
         property tipo          : String      read vTipo          write vTipo;
         property valor         : Double      read vValor         write vValor;
         property descricao     : String      read vDescricao     write vDescricao;
   end;

implementation 

constructor TMovimentacao.Create;
begin
   Self.vID           := 0;
   Self.vCATEGORIA_ID := 0;
   Self.vEMPRESA_ID   := 0;
   Self.vDATA         := 0;
   Self.vTIPO         := EmptyStr;
   Self.vVALOR        := 0;
   Self.vDESCRICAO    := EmptyStr;
end;
end.
