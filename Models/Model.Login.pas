unit Model.Login;

interface

uses SysUtils, Classes;

type

   TLogin = Class(TPersistent)
      private
         vEmail       : String;
         vSenha       : String;
      public
         constructor Create;
      published
         property email       : String      read vEmail       write vEmail;
         property senha       : String      read vSenha       write vSenha;
   end;

   TLoginResposta = Class(TPersistent)
      private
         vID          : Integer;
         vNome        : String;
         vEmail       : String;
         vToken       : String;
      public
         constructor Create;
      published
         property id          : Integer     read vId          write vId;
         property nome        : String      read vNome        write vNome;
         property email       : String      read vEmail       write vEmail;
         property token       : String      read vToken       write vToken;
   end;

implementation

constructor TLogin.Create;
begin
   Self.vEmail      := EmptyStr;
   Self.vSenha      := EmptyStr;
end;
{ TLoginResposta }

constructor TLoginResposta.Create;
begin
   Self.vID         := 0;
   Self.vEmail      := EmptyStr;
   Self.vNome       := EmptyStr;
   Self.vToken      := EmptyStr;
end;

end.
