unit Controller.Login;

interface

uses
  MVCFramework, MVCFramework.Commons, MVCFramework.Serializer.Commons;

type
  [MVCPath('/api')]
  TLoginController = class(TMVCController)
  protected
    procedure OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean); override;
    procedure OnAfterAction(Context: TWebContext; const AActionName: string); override;

  public
    [MVCPath('/login')]
    [MVCHTTPMethod([httpPOST])]
    procedure DoLogin;

    [MVCPath('/registro')]
    [MVCHTTPMethod([httpPOST])]
    procedure DoRegistro;

  end;

implementation

uses
  System.SysUtils, MVCFramework.Logger, System.StrUtils, Service.Usuarios,
  Model.Resposta, Model.Login, Model.Usuarios, MVCFramework.JWT, Util.Token,
  Model.Registro, Service.Empresas, Model.Empresas;

procedure TLoginController.OnAfterAction(Context: TWebContext; const AActionName: string);
begin
  inherited;
end;

procedure TLoginController.OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean);
begin
  inherited;
end;

procedure TLoginController.DoLogin;
var
   vLogin : TLogin;
   vLoginResposta: TLoginResposta;
   vUsuario : TUsuario;
begin
   try
      vUsuario := nil;
      vLogin := nil;
      try
         if Trim(Context.Request.Body) = '' then
            raise Exception.Create('Não foram informados dados para a operação');

         vLogin := Context.Request.BodyAs<TLogin>;
         if Trim(vLogin.email) = '' then
            raise Exception.Create('O e-mail é obrigatório.');

         if Trim(vLogin.senha) = '' then
            raise Exception.Create('A senha é obrigatória.');

         vUsuario := TUsuariosService.getInstancia.BuscaPeloEmail(vLogin.email);

         if vUsuario.senha = vLogin.senha then
         begin
            vLoginResposta := TLoginResposta.Create;
            vLoginResposta.id := vUsuario.id;
            vLoginResposta.nome := vUsuario.nome;
            vLoginResposta.email := vUsuario.email;
            vLoginResposta.token := TTokenUtil.RetornaToken(vUsuario);
            Render(200, vLoginResposta, True);
         end
         else
            Render(401, TResposta.MontaResposta('Usuário ou senha inválidos.'), True);
      except
         On E: Exception do
            Render(400, TResposta.MontaResposta('Não foi possível efetuar o login: '+
               E.Message), True);
      end;
   finally
      if Assigned(vUsuario) then
         FreeAndNil(vUsuario);
      if Assigned(vLogin) then
         FreeAndNil(vLogin);
   end;
end;

procedure TLoginController.DoRegistro;
var
   vRegistro: TRegistro;
   vEmpresa: TEmpresa;
begin
   try
      vRegistro := nil;
      vEmpresa := nil;
      try
         if Trim(Context.Request.Body) = '' then
            raise Exception.Create('Não foram informados dados para a operação');

         vRegistro := Context.Request.BodyAs<TRegistro>;
         if TEmpresasService.getInstancia.CriaEmpresa(vRegistro.empresa) then
         begin
            vEmpresa := TEmpresasService.getInstancia.BuscaPeloCNPJ(vRegistro.empresa.cnpj);
            if TUsuariosService.getInstancia.CriaUsuario(vEmpresa.id,vRegistro.usuario) then
               Render(201, TResposta.MontaResposta('Registro efetuado com sucesso. '+
                  'Por favor, faça o login.'), True);
         end;
      except
         On E: Exception do
            Render(400, TResposta.MontaResposta('Não foi possível efetuar o registro: '+
               E.Message), True);
      end;
   finally
      if Assigned(vRegistro) then
         FreeAndNil(vRegistro);
      if Assigned(vEmpresa) then
         FreeAndNil(vEmpresa);
   end;
end;

end.
