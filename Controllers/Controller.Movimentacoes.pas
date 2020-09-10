unit Controller.Movimentacoes;

interface

uses
  MVCFramework, MVCFramework.Commons, MVCFramework.Serializer.Commons;

type
  [MVCPath('/api')]
  TMovimentacoesController = class(TMVCController)
  protected
    procedure OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean); override;
    procedure OnAfterAction(Context: TWebContext; const AActionName: string); override;

  public
    [MVCPath('/movimentacoes')]
    [MVCHTTPMethod([httpGET])]
    procedure GetMovimentacoes;

    [MVCPath('/movimentacoes/($id)')]
    [MVCHTTPMethod([httpGET])]
    procedure GetMovimentacao(id: Integer);

    [MVCPath('/movimentacoes')]
    [MVCHTTPMethod([httpPOST])]
    procedure CreateMovimentacao;

    [MVCPath('/movimentacoes/($id)')]
    [MVCHTTPMethod([httpPUT])]
    procedure UpdateMovimentacao(id: Integer);

    [MVCPath('/Movimentacoes/($id)')]
    [MVCHTTPMethod([httpDELETE])]
    procedure DeleteMovimentacao(id: Integer);

  end;

implementation

uses
  System.SysUtils, MVCFramework.Logger, System.StrUtils, Service.Movimentacoes,
  Model.Movimentacoes, Model.Resposta, Util.Funcoes;

procedure TMovimentacoesController.OnAfterAction(Context: TWebContext; const AActionName: string);
begin
   inherited;
end;

procedure TMovimentacoesController.OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean);
begin
   if not TFuncoesUtil.ValidaToken(Context.Request.Headers['Authorization']) then
   begin
      Render(401, TResposta.MontaResposta('Token inválido ou usuário não autenticado.'),
         True);
      Handled := True;
      Exit;
   end;

  inherited;
end;

procedure TMovimentacoesController.GetMovimentacoes;
begin
   try
      Render<TMovimentacao>(TMovimentacoesService.getInstancia.BuscaTodos, True);
   except
      On E: Exception do
         Render(400,  TResposta.MontaResposta('Não foi possível obter a lista de '+
            'movimentações: ' + E.Message), True);
   end;
end;

procedure TMovimentacoesController.GetMovimentacao(id: Integer);
begin
   try
      Render(200, TMovimentacoesService.getInstancia.BuscaPeloID(id), True);
   except
      On E: Exception do
         Render(400, TResposta.MontaResposta('Não foi possível obter a '+
            'movimentação: ' + E.Message), True);
   end;
end;

procedure TMovimentacoesController.CreateMovimentacao;
var
   vMovimentacao: TMovimentacao;
begin
   try
      vMovimentacao := nil;
      try
         if Trim(Context.Request.Body) = '' then
            raise Exception.Create('Não foram informados dados para a operação');

         vMovimentacao := Context.Request.BodyAs<TMovimentacao>;
         if TMovimentacoesService.getInstancia.CriaMovimentacoes(
               TFuncoesUtil.RetornaDadosToken(Context.Request.Headers['Authorization']).vIdEmpresa,
               vMovimentacao) then
            Render(201, TResposta.MontaResposta('Movimentação cadastrada com sucesso'),
               True);
      except
         On E: Exception do
         begin
            Render(400, TResposta.MontaResposta('Não foi possível cadastrar a '+
               'movimentação: ' + E.Message), True);
         end;
      end;
   finally
      if Assigned(vMovimentacao) then
         FreeAndNil(vMovimentacao);
   end;
end;

procedure TMovimentacoesController.UpdateMovimentacao(id: Integer);
var
   vMovimentacao: TMovimentacao;
begin
   try
      vMovimentacao := nil;
      try
         if Trim(Context.Request.Body) = '' then
            raise Exception.Create('Não foram informados dados para a operação');

         vMovimentacao := Context.Request.BodyAs<TMovimentacao>;
         if TMovimentacoesService.getInstancia.AtualizaMovimentacoes(id,
              TFuncoesUtil.RetornaDadosToken(Context.Request.Headers['Authorization']).vIdEmpresa,
              vMovimentacao) then
            Render(200, TResposta.MontaResposta('Movimentação atualizada com sucesso'),
               True);
      except
         On E: Exception do
         begin
            Render(400, TResposta.MontaResposta('Não foi possível atualizar os dados '+
               'da movimentação: ' + E.Message), True);
         end;
      end;
   finally
      if Assigned(vMovimentacao) then
         FreeAndNil(vMovimentacao);
   end;
end;

procedure TMovimentacoesController.DeleteMovimentacao(id: Integer);
begin
   try
      if TMovimentacoesService.getInstancia.ExcluiMovimentacoes(id,
         TFuncoesUtil.RetornaDadosToken(Context.Request.Headers['Authorization']).vIdEmpresa) then
         Render(200, TResposta.MontaResposta('Movimentação excluída com sucesso'),
            True);
   except
      On E: Exception do
         Render(400, TResposta.MontaResposta('Não foi possível excluir a '+
            'movimentação: ' + E.Message), True);
   end;
end;

end.
