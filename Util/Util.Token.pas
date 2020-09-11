unit Util.Token;

interface

uses SysUtils, Classes, MVCFramework.JWT, System.DateUtils, Model.Usuarios;

type
   TDadosToken = record
      vIdUsuario : Integer;
      vIdEmpresa : Integer;
   end;

   TTokenUtil = class
     private
        const KEY_VALUE = '12345APICAIXA';
     public
        class function ValidaToken(pToken : String): Boolean;
        class function RetornaToken(pUsuario: TUsuario): String;
        class function RetornaDadosToken(pToken: String): TDadosToken;
   end;

implementation

{ TTokenUtil }

class function TTokenUtil.ValidaToken(pToken: String): Boolean;
var
   vJWT : TJWT;
   vErro: string;
begin
   Result := False;

   if pToken.IsEmpty then
     Exit;

   vJWT := TJWT.Create(KEY_VALUE, 0);
   try
      if pToken.StartsWith('bearer', True) then
         pToken := pToken.Remove(0, 'bearer'.Length).Trim;

      if not vJWT.LoadToken(pToken, vErro) then
         Exit;

      if vJWT.CustomClaims['username'].IsEmpty then
         Exit;

   finally
      vJWT.Free;
   end;
   Result := True;
end;

class function TTokenUtil.RetornaToken(pUsuario: TUsuario): string;
var
   vJWT : TJWT;
begin
   vJWT := TJWT.Create(KEY_VALUE);
   try
     vJWT.Claims.Issuer := 'API de Controle de Caixa';
     vJWT.Claims.ExpirationTime := Now + OneMinute * 60;
     vJWT.Claims.NotBefore := Now - OneMinute * 5;
     vJWT.Claims.IssuedAt := Now - OneMinute * 5;
     vJWT.CustomClaims['username'] := pUsuario.email;
     vJWT.CustomClaims['id'] := pUsuario.id.ToString;
     vJWT.CustomClaims['empresa_id'] := pUsuario.empresa_id.ToString;
     Result := vJWT.GetToken;
   finally
     vJWT.Free;
   end;
end;

class function TTokenUtil.RetornaDadosToken(pToken: String) : TDadosToken;
var
   vJWT : TJWT;
   vErro: string;
begin
   vJWT := TJWT.Create(KEY_VALUE, 0);
   try
      if pToken.StartsWith('bearer', True) then
         pToken := pToken.Remove(0, 'bearer'.Length).Trim;

      if not vJWT.LoadToken(pToken, vErro) then
         Exit;

      Result.vIdUsuario := StrToInt(vJWT.CustomClaims['id']);
      Result.vIdEmpresa := StrToInt(vJWT.CustomClaims['empresa_id']);
   finally
      vJWT.Free;
   end;

end;

end.
