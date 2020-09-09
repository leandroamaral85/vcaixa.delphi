unit UCategorias;
                                           
interface                                  
                                           
uses SysUtils, Classes;                    
                                           
type

   TCategorias = Class(TPersistent) 
      private
         vId    : Integer;
         vNome  : String;
      public
         constructor Create;
      published
         property Id    : Integer     read vId    write vId;
         property Nome  : String      read vNome  write vNome;
   end;

   TColCategorias = Class(TList) 
      public
         function  Retorna(pIndex: Integer): TCategorias;
         procedure Adiciona(pCategorias : TCategorias);
   end; 

implementation 

constructor TCategorias.Create;
begin
   Self.vID   := 0;
   Self.vNOME := EmptyStr;
end;

function TColCategorias.Retorna(pIndex: Integer): TCategorias;
begin
   Result := TCategorias(Self[pIndex]);
end;

procedure TColCategorias.Adiciona(pCategorias: TCategorias);
begin
   Self.Add(TCategorias(pCategorias));
end;
end.
