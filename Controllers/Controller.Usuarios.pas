unit Controller.Usuarios;

interface

uses
  MVCFramework, MVCFramework.Commons, MVCFramework.Serializer.Commons;

type
  [MVCPath('/api')]
  TUsuariosController = class(TMVCController)
  protected
    procedure OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean); override;
    procedure OnAfterAction(Context: TWebContext; const AActionName: string); override;

  public
    [MVCPath('/usuarios')]
    [MVCHTTPMethod([httpGET])]
    procedure GetUsuarios;

    [MVCPath('/usuarios/($id)')]
    [MVCHTTPMethod([httpGET])]
    procedure GetUsuario(id: Integer);

    [MVCPath('/usuarios')]
    [MVCHTTPMethod([httpPOST])]
    procedure CreateUsuario;

    [MVCPath('/usuarios/($id)')]
    [MVCHTTPMethod([httpPUT])]
    procedure UpdateUsuario(id: Integer);

    [MVCPath('/usuarios/($id)')]
    [MVCHTTPMethod([httpDELETE])]
    procedure DeleteUsuario(id: Integer);

  end;

implementation

uses
  System.SysUtils, MVCFramework.Logger, System.StrUtils, Service.Usuarios,
  Model.Usuarios, Model.Resposta, Util.Token;

procedure TUsuariosController.OnAfterAction(Context: TWebContext; const AActionName: string);
begin
   inherited;
end;

procedure TUsuariosController.OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean);
begin
   if not TTokenUtil.ValidaToken(Context.Request.Headers['Authorization']) then
   begin
      Render(401, TResposta.MontaResposta('Token inválido ou usuário não autenticado.'),
         True);
      Handled := True;
      Exit;
   end;

   inherited;
end;

procedure TUsuariosController.GetUsuarios;
begin
   try
      Render<TUsuario>(TUsuariosService.getInstancia.BuscaTodos, True);
   except
      On E: Exception do
         Render(400,  TResposta.MontaResposta('Não foi possível obter a lista de '+
            'usuários: ' + E.Message), True);
   end;
end;

procedure TUsuariosController.GetUsuario(id: Integer);
begin
   try
      Render(200, TUsuariosService.getInstancia.BuscaPeloID(id), True);
   except
      On E: Exception do
         Render(400, TResposta.MontaResposta('Não foi possível obter o '+
            'usuário: ' + E.Message), True);
   end;
end;

procedure TUsuariosController.CreateUsuario;
var
   vUsuario: TUsuario;
begin
   try
      vUsuario := nil;
      try
         if Trim(Context.Request.Body) = '' then
            raise Exception.Create('Não foram informados dados para a operação');

         vUsuario := Context.Request.BodyAs<TUsuario>;
         if TUsuariosService.getInstancia.CriaUsuario(
               TTokenUtil.RetornaDadosToken(Context.Request.Headers['Authorization']).vIdEmpresa,
               vUsuario) then
            Render(201, TResposta.MontaResposta('Usuário cadastrado com sucesso'),
               True);
      except
         On E: Exception do
         begin
            Render(400, TResposta.MontaResposta('Não foi possível cadastrar o '+
               'usuário: ' + E.Message), True);
         end;
      end;
   finally
      if Assigned(vUsuario) then
         FreeAndNil(vUsuario);
   end;
end;

procedure TUsuariosController.UpdateUsuario(id: Integer);
var
   vUsuario: TUsuario;
begin
   try
      vUsuario := nil;
      try
         if Trim(Context.Request.Body) = '' then
            raise Exception.Create('Não foram informados dados para a operação');

         vUsuario := Context.Request.BodyAs<TUsuario>;
         if TUsuariosService.getInstancia.AtualizaUsuario(id,
               TTokenUtil.RetornaDadosToken(Context.Request.Headers['Authorization']).vIdEmpresa,
               vUsuario) then
            Render(200, TResposta.MontaResposta('Usuário atualizado com sucesso'),
               True);
      except
         On E: Exception do
         begin
            Render(400, TResposta.MontaResposta('Não foi possível atualizar os dados '+
               'do usuário: ' + E.Message), True);
         end;
      end;
   finally
      if Assigned(vUsuario) then
         FreeAndNil(vUsuario);
   end;
end;

procedure TUsuariosController.DeleteUsuario(id: Integer);
begin
   try
      if TUsuariosService.getInstancia.ExcluiUsuario(id,
            TTokenUtil.RetornaDadosToken(Context.Request.Headers['Authorization']).vIdEmpresa) then
         Render(200, TResposta.MontaResposta('Usuário excluído com sucesso'),
            True);
   except
      On E: Exception do
         Render(400, TResposta.MontaResposta('Não foi possível excluir o '+
            'usuário: ' + E.Message), True);
   end;
end;

end.
