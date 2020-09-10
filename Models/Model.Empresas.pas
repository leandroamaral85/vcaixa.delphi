unit Model.Empresas;
                                           
interface                                  
                                           
uses SysUtils, Classes;                    
                                           
type

   TEmpresa = Class(TPersistent)
      private
         vId    : Integer;
         vNome  : String;
         vCnpj  : String;
      public
         constructor Create;
      published
         property id    : Integer     read vId    write vId;
         property nome  : String      read vNome  write vNome;
         property cnpj  : String      read vCnpj  write vCnpj;
   end;

implementation 

constructor TEmpresa.Create;
begin
   Self.vID   := 0;
   Self.vNOME := EmptyStr;
   Self.vCNPJ := EmptyStr;
end;
end.
