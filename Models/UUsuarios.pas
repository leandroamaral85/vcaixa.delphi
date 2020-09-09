unit UUsuarios;
                                           
interface                                  
                                           
uses SysUtils, Classes;                    
                                           
type

   TUsuarios = Class(TPersistent) 
      private
         vId          : Integer;
         vNome        : String;
         vEmail       : String;
         vSenha       : String;
         vEmpresa_id  : Integer;
      public
         constructor Create;
      published
         property Id          : Integer     read vId          write vId;
         property Nome        : String      read vNome        write vNome;
         property Email       : String      read vEmail       write vEmail;
         property Senha       : String      read vSenha       write vSenha;
         property Empresa_id  : Integer     read vEmpresa_id  write vEmpresa_id;
   end;

   TColUsuarios = Class(TList) 
      public
         function  Retorna(pIndex: Integer): TUsuarios;
         procedure Adiciona(pUsuarios : TUsuarios);
   end; 

implementation 

constructor TUsuarios.Create;
begin
   Self.vID         := 0;
   Self.vNOME       := EmptyStr;
   Self.vEMAIL      := EmptyStr;
   Self.vSENHA      := EmptyStr;
   Self.vEMPRESA_ID := 0;
end;

function TColUsuarios.Retorna(pIndex: Integer): TUsuarios;
begin
   Result := TUsuarios(Self[pIndex]);
end;

procedure TColUsuarios.Adiciona(pUsuarios: TUsuarios);
begin
   Self.Add(TUsuarios(pUsuarios));
end;
end.
