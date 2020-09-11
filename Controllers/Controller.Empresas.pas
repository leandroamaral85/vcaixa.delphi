unit Controller.Empresas;

interface

uses
  MVCFramework, MVCFramework.Commons, MVCFramework.Serializer.Commons;

type
  [MVCPath('/api')]
  TEmpresasController = class(TMVCController)
  protected
    procedure OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean); override;
    procedure OnAfterAction(Context: TWebContext; const AActionName: string); override;

  public
    [MVCPath('/empresas')]
    [MVCHTTPMethod([httpGET])]
    procedure GetEmpresas;

    [MVCPath('/empresas/($id)')]
    [MVCHTTPMethod([httpGET])]
    procedure GetEmpresa(id: Integer);

    [MVCPath('/empresas/($id)')]
    [MVCHTTPMethod([httpPUT])]
    procedure UpdateEmpresa(id: Integer);

    [MVCPath('/empresas/($id)')]
    [MVCHTTPMethod([httpDELETE])]
    procedure DeleteEmpresa(id: Integer);

  end;

implementation

uses
  System.SysUtils, MVCFramework.Logger, System.StrUtils, Service.Empresas,
  Model.Empresas, Model.Resposta;

procedure TEmpresasController.OnAfterAction(Context: TWebContext; const AActionName: string);
begin
   inherited;
end;

procedure TEmpresasController.OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean);
begin
   inherited;
end;

procedure TEmpresasController.GetEmpresas;
begin
   try
      Render<TEmpresa>(TEmpresasService.getInstancia.BuscaTodos, True);
   except
      On E: Exception do
         Render(400,  TResposta.MontaResposta('Não foi possível obter a lista de '+
            'empresas: ' + E.Message), True);
   end;
end;

procedure TEmpresasController.GetEmpresa(id: Integer);
begin
   try
      Render(200, TEmpresasService.getInstancia.BuscaPeloID(id), True);
   except
      On E: Exception do
         Render(400, TResposta.MontaResposta('Não foi possível obter a '+
            'empresa: ' + E.Message), True);
   end;
end;

procedure TEmpresasController.UpdateEmpresa(id: Integer);
var
   vEmpresa: TEmpresa;
begin
   try
      vEmpresa := nil;
      try
         if Trim(Context.Request.Body) = '' then
            raise Exception.Create('Não foram informados dados para a operação');

         vEmpresa := Context.Request.BodyAs<TEmpresa>;
         if TEmpresasService.getInstancia.AtualizaEmpresa(id, vEmpresa) then
            Render(200, TResposta.MontaResposta('Empresa atualizada com sucesso'),
               True);
      except
         On E: Exception do
         begin
            Render(400, TResposta.MontaResposta('Não foi possível atualizar os dados '+
               'da empresa: ' + E.Message), True);
         end;
      end;
   finally
      if Assigned(vEmpresa) then
         FreeAndNil(vEmpresa);
   end;
end;

procedure TEmpresasController.DeleteEmpresa(id: Integer);
begin
   try
      if TEmpresasService.getInstancia.ExcluiEmpresa(id) then
         Render(200, TResposta.MontaResposta('Empresa excluída com sucesso'),
            True);
   except
      On E: Exception do
         Render(400, TResposta.MontaResposta('Não foi possível excluir a '+
            'empresa: ' + E.Message), True);
   end;
end;

end.
