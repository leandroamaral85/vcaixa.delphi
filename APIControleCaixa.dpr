program APIControleCaixa;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  MVCFramework.Logger,
  MVCFramework.Commons,
  MVCFramework.REPLCommandsHandlerU,
  FireDAC.DApt,
  Web.ReqMulti,
  Web.WebReq,
  Web.WebBroker,
  IdContext,
  IdHTTPWebBrokerBridge,
  Controller.Categorias in 'Controllers\Controller.Categorias.pas',
  UwmPrincipal in 'UwmPrincipal.pas' {WmPrincipal: TWebModule},
  UdmPrincipal in 'UdmPrincipal.pas' {dmPrincipal: TDataModule},
  Model.Categorias in 'Models\Model.Categorias.pas',
  Model.Empresas in 'Models\Model.Empresas.pas',
  Model.Movimentacoes in 'Models\Model.Movimentacoes.pas',
  Model.Usuarios in 'Models\Model.Usuarios.pas',
  Controller.Empresas in 'Controllers\Controller.Empresas.pas',
  DAO.Categorias in 'Models\DAO\DAO.Categorias.pas',
  DAO.Empresas in 'Models\DAO\DAO.Empresas.pas',
  DAO.Movimentacoes in 'Models\DAO\DAO.Movimentacoes.pas',
  DAO.Usuarios in 'Models\DAO\DAO.Usuarios.pas',
  Service.Categorias in 'Services\Service.Categorias.pas',
  Model.Resposta in 'Models\Model.Resposta.pas',
  Service.Empresas in 'Services\Service.Empresas.pas',
  Service.Movimentacoes in 'Services\Service.Movimentacoes.pas',
  Service.Usuarios in 'Services\Service.Usuarios.pas',
  Controller.Movimentacoes in 'Controllers\Controller.Movimentacoes.pas',
  Controller.Usuarios in 'Controllers\Controller.Usuarios.pas',
  Controller.ResumoDiario in 'Controllers\Controller.ResumoDiario.pas',
  Controller.Login in 'Controllers\Controller.Login.pas',
  Model.Login in 'Models\Model.Login.pas',
  Model.ResumoDiario in 'Models\Model.ResumoDiario.pas',
  Util.Token in 'Util\Util.Token.pas',
  Model.Registro in 'Models\Model.Registro.pas';

{$R *.res}


procedure RunServer(APort: Integer);
var
  LServer: TIdHTTPWebBrokerBridge;
  LCustomHandler: TMVCCustomREPLCommandsHandler;
  LCmd: string;
begin
  Writeln('** DMVCFramework Server ** build ' + DMVCFRAMEWORK_VERSION);
  LCmd := 'start';
  if ParamCount >= 1 then
    LCmd := ParamStr(1);

  LCustomHandler := function(const Value: String; const Server: TIdHTTPWebBrokerBridge; out Handled: Boolean): THandleCommandResult
  begin
    Handled := False;
    Result := THandleCommandResult.Unknown;
  end;

  LServer := TIdHTTPWebBrokerBridge.Create(nil);
  try
    dmPrincipal := TDmPrincipal.Create(nil);

    LServer.OnParseAuthentication := TMVCParseAuthentication.OnParseAuthentication;
    LServer.DefaultPort := APort;
    LServer.MaxConnections := 0;
    LServer.ListenQueue := 200;
    LServer.OnParseAuthentication := TMVCParseAuthentication.OnParseAuthentication;

    WriteLn('Write "quit" or "exit" to shutdown the server');
    repeat
      if LCmd.IsEmpty then
      begin
        Write('-> ');
        ReadLn(LCmd)
      end;
      try
        case HandleCommand(LCmd.ToLower, LServer, LCustomHandler) of
          THandleCommandResult.Continue:
          begin
             Continue;
          end;
          THandleCommandResult.Break:
          begin
             Break;
          end;
          THandleCommandResult.Unknown:
          begin
            REPLEmit('Unknown command: ' + LCmd);
          end;
        end;
      finally
        LCmd := '';
      end;
    until False;

  finally
    LServer.Free;
  end;
end;

begin
  ReportMemoryLeaksOnShutdown := True;
  IsMultiThread := True;
  try
    if WebRequestHandler <> nil then
      WebRequestHandler.WebModuleClass := WebModuleClass;
    WebRequestHandlerProc.MaxConnections := 1024;
    RunServer(8080);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
