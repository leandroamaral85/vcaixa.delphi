unit UEmpresas;
                                           
interface                                  
                                           
uses SysUtils, Classes;                    
                                           
type

   TEmpresas = Class(TPersistent) 
      private
         vId    : Integer;
         vNome  : String;
         vCnpj  : String;
      public
         constructor Create;
      published
         property Id    : Integer     read vId    write vId;
         property Nome  : String      read vNome  write vNome;
         property Cnpj  : String      read vCnpj  write vCnpj;
   end;

   TColEmpresas = Class(TList) 
      public
         function  Retorna(pIndex: Integer): TEmpresas;
         procedure Adiciona(pEmpresas : TEmpresas);
   end; 

implementation 

constructor TEmpresas.Create;
begin
   Self.vID   := 0;
   Self.vNOME := EmptyStr;
   Self.vCNPJ := EmptyStr;
end;

function TColEmpresas.Retorna(pIndex: Integer): TEmpresas;
begin
   Result := TEmpresas(Self[pIndex]);
end;

procedure TColEmpresas.Adiciona(pEmpresas: TEmpresas);
begin
   Self.Add(TEmpresas(pEmpresas));
end;
end.
