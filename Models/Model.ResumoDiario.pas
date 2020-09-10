unit Model.ResumoDiario;

interface

uses SysUtils, Classes, System.Generics.Collections, Model.Categorias;

type

   TMovimento = Class(TPersistent)
      private
         vId            : Integer;
         vCategoria     : TCategoria;
         vData          : TDate;
         vTipo          : String;
         vValor         : Double;
         vDescricao     : String;
      public
         constructor Create;
      published
         property id            : Integer     read vId            write vId;
         property categoria     : TCategoria  read vCategoria     write vCategoria;
         property data          : TDate       read vData          write vData;
         property tipo          : String      read vTipo          write vTipo;
         property valor         : Double      read vValor         write vValor;
         property descricao     : String      read vDescricao     write vDescricao;
   End;

   TResumoDiario = Class(TPersistent)
      private
         vSaldoTotal    : Double;
         vMovimentacoes : TObjectList<TMovimento>;
      public
         constructor Create;
      published
         property saldoTotal     : double   read vSaldoTotal  write vSaldoTotal;
         property movimentacoes : TObjectList<TMovimento>  read vMovimentacoes  write vMovimentacoes;
   end;

implementation

constructor TResumoDiario.Create;
begin
   Self.vSaldoTotal    := 0;
   Self.vMovimentacoes := TObjectList<TMovimento>.Create;
end;

{ TMovimento }

constructor TMovimento.Create;
begin
   Self.vID           := 0;
   Self.vCategoria    := nil;
   Self.vDATA         := 0;
   Self.vTIPO         := EmptyStr;
   Self.vVALOR        := 0;
   Self.vDESCRICAO    := EmptyStr;
end;

end.
