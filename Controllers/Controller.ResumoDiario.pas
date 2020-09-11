unit Controller.ResumoDiario;

interface

uses
  MVCFramework, MVCFramework.Commons, MVCFramework.Serializer.Commons;

type
  [MVCPath('/api')]
  TResumoDiarioController = class(TMVCController)
  protected
    procedure OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean); override;
    procedure OnAfterAction(Context: TWebContext; const AActionName: string); override;

  public
    [MVCPath('/resumo-diario')]
    [MVCHTTPMethod([httpGET])]
    procedure GetResumoDiario;

  end;

implementation

uses
  System.SysUtils, MVCFramework.Logger, System.StrUtils, Service.Movimentacoes,
  Model.Resposta, Model.ResumoDiario, Util.Token;

procedure TResumoDiarioController.OnAfterAction(Context: TWebContext; const AActionName: string);
begin
   inherited;
end;

procedure TResumoDiarioController.OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean);
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

procedure TResumoDiarioController.GetResumoDiario;
begin
   try
      Render(TMovimentacoesService.getInstancia.RetornaResumoDiario(
         TTokenUtil.RetornaDadosToken(Context.Request.Headers['Authorization']).vIdEmpresa), True);
   except
      On E: Exception do
         Render(400,  TResposta.MontaResposta('Não foi possível obter o resumo '+
            'diário: ' + E.Message), True);
   end;
end;
end.
