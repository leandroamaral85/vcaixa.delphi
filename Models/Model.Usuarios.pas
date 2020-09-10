unit Model.Usuarios;
                                           
interface                                  
                                           
uses SysUtils, Classes;                    
                                           
type

   TUsuario = Class(TPersistent)
      private
         vId          : Integer;
         vNome        : String;
         vEmail       : String;
         vSenha       : String;
         vEmpresa_id  : Integer;
      public
         constructor Create;
      published
         property id          : Integer     read vId          write vId;
         property nome        : String      read vNome        write vNome;
         property email       : String      read vEmail       write vEmail;
         property senha       : String      read vSenha       write vSenha;
         property empresa_id  : Integer     read vEmpresa_id  write vEmpresa_id;
   end;

implementation 

constructor TUsuario.Create;
begin
   Self.vID         := 0;
   Self.vNOME       := EmptyStr;
   Self.vEMAIL      := EmptyStr;
   Self.vSENHA      := EmptyStr;
   Self.vEMPRESA_ID := 0;
end;
end.
