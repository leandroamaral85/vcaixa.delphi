unit Controller.Categorias;

interface

uses
  MVCFramework, MVCFramework.Commons, MVCFramework.Serializer.Commons;

type
  [MVCPath('/api')]
  TCategoriasController = class(TMVCController)
  protected
    procedure OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean); override;
    procedure OnAfterAction(Context: TWebContext; const AActionName: string); override;

  public
    [MVCPath('/categorias')]
    [MVCHTTPMethod([httpGET])]
    procedure GetCategorias;

    [MVCPath('/categorias/($id)')]
    [MVCHTTPMethod([httpGET])]
    procedure GetCategoria(id: Integer);

    [MVCPath('/categorias')]
    [MVCHTTPMethod([httpPOST])]
    procedure CreateCategoria;

    [MVCPath('/categorias/($id)')]
    [MVCHTTPMethod([httpPUT])]
    procedure UpdateCategoria(id: Integer);

    [MVCPath('/categorias/($id)')]
    [MVCHTTPMethod([httpDELETE])]
    procedure DeleteCategoria(id: Integer);

  end;

implementation

uses
  System.SysUtils, MVCFramework.Logger, System.StrUtils, Service.Categorias,
  Model.Categorias, Model.Resposta, System.Generics.Collections, Util.Token;


procedure TCategoriasController.OnAfterAction(Context: TWebContext; const AActionName: string);
begin
   inherited;
end;

procedure TCategoriasController.OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean);
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

procedure TCategoriasController.GetCategorias;
begin
   try
      Render<TCategoria>(TCategoriasService.getInstancia.BuscaTodos, True);
   except
      On E: Exception do
         Render(400, TResposta.MontaResposta('Não foi possível obter a lista de '+
            'categorias: ' + E.Message), True);
   end;
end;

procedure TCategoriasController.GetCategoria(id: Integer);
begin
   try
      Render(200, TCategoriasService.getInstancia.BuscaPeloID(id), True);
   except
      On E: Exception do
         Render(400, TResposta.MontaResposta('Não foi possível obter a '+
            'categoria: ' + E.Message), True);
   end;
end;

procedure TCategoriasController.CreateCategoria;
var
   vCategoria: TCategoria;
begin
   try
      vCategoria := nil;
      try
         if Trim(Context.Request.Body) = '' then
            raise Exception.Create('Não foram informados dados para a operação');

         vCategoria := Context.Request.BodyAs<TCategoria>;
         if TCategoriasService.getInstancia.CriaCategoria(vCategoria) then
            Render(201, TResposta.MontaResposta('Categoria cadastrada com sucesso'),
               True);
      except
         On E: Exception do
         begin
            Render(400, TResposta.MontaResposta('Não foi possível cadastrar a '+
               'categoria: ' + E.Message), True);
         end;
      end;
   finally
      if Assigned(vCategoria) then
         FreeAndNil(vCategoria);
   end;
end;

procedure TCategoriasController.UpdateCategoria(id: Integer);
var
   vCategoria: TCategoria;
begin
   try
      vCategoria := nil;
      try
         if Trim(Context.Request.Body) = '' then
            raise Exception.Create('Não foram informados dados para a operação');

         vCategoria := Context.Request.BodyAs<TCategoria>;
         if TCategoriasService.getInstancia.AtualizaCategoria(id, vCategoria) then
            Render(200, TResposta.MontaResposta('Categoria atualizada com sucesso'),
               True);
      except
         On E: Exception do
         begin
            Render(400, TResposta.MontaResposta('Não foi possível atualizar os dados '+
               'da categoria: ' + E.Message), True);
         end;
      end;
   finally
      if Assigned(vCategoria) then
         FreeAndNil(vCategoria);
   end;
end;

procedure TCategoriasController.DeleteCategoria(id: Integer);
begin
   try
      if TCategoriasService.getInstancia.ExcluiCategoria(id) then
         Render(200, TResposta.MontaResposta('Categoria excluída com sucesso'),
            True);
   except
      On E: Exception do
         Render(400, TResposta.MontaResposta('Não foi possível excluir a '+
            'categoria: ' + E.Message), True);
   end;
end;

end.
