unit Model.Categorias;
                                           
interface                                  
                                           
uses SysUtils, Classes;                    
                                           
type

   TCategoria = Class(TPersistent)
      private
         vId    : Integer;
         vNome  : String;
      public
         constructor Create;
      published
         property id    : Integer     read vId    write vId;
         property nome  : String      read vNome  write vNome;
   end;

implementation 

constructor TCategoria.Create;
begin
   Self.vID   := 0;
   Self.vNOME := EmptyStr;
end;

end.
