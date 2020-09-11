unit Model.Registro;

interface

uses SysUtils, Classes, Model.Empresas, Model.Usuarios;

type

   TRegistro = Class(TPersistent)
      private
         vEmpresa : TEmpresa;
         vUsuario : TUsuario;
      public
         constructor Create;
      published
         property empresa : TEmpresa  read vEmpresa  write vEmpresa;
         property usuario : TUsuario  read vUsuario  write vUsuario;
   end;

implementation

constructor TRegistro.Create;
begin
   Self.vEmpresa := TEmpresa.Create;
   Self.vUsuario := TUsuario.Create;
end;
end.
