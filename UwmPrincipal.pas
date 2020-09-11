unit UwmPrincipal;

interface

uses 
  System.SysUtils,
  System.Classes,
  Web.HTTPApp,
  MVCFramework;

type
  TWmPrincipal = class(TWebModule)
    procedure WebModuleCreate(Sender: TObject);
    procedure WebModuleDestroy(Sender: TObject);
  private
    FMVC: TMVCEngine;
  public
    { Public declarations }
  end;

var
  WebModuleClass: TComponentClass = TWmPrincipal;

implementation

{$R *.dfm}

uses
  Controller.Categorias,
  Controller.Empresas,
  Controller.Movimentacoes,
  Controller.Usuarios,
  Controller.ResumoDiario,
  Controller.Login,
  System.IOUtils, 
  MVCFramework.Commons, 
  MVCFramework.Middleware.StaticFiles, 
  MVCFramework.Middleware.Compression;

procedure TWmPrincipal.WebModuleCreate(Sender: TObject);
begin
  FMVC := TMVCEngine.Create(Self,
    procedure(Config: TMVCConfig)
    begin
      Config[TMVCConfigKey.SessionTimeout] := '0';
      Config[TMVCConfigKey.DefaultContentType] := TMVCConstants.DEFAULT_CONTENT_TYPE;
      Config[TMVCConfigKey.DefaultContentCharset] := TMVCConstants.DEFAULT_CONTENT_CHARSET;
      Config[TMVCConfigKey.AllowUnhandledAction] := 'false';
      Config[TMVCConfigKey.LoadSystemControllers] := 'true';
      Config[TMVCConfigKey.DefaultViewFileExtension] := 'html';
      Config[TMVCConfigKey.ViewPath] := 'templates';
      Config[TMVCConfigKey.MaxEntitiesRecordCount] := '20';
      Config[TMVCConfigKey.ExposeServerSignature] := 'true';
      Config[TMVCConfigKey.ExposeXPoweredBy] := 'true';
      Config[TMVCConfigKey.MaxRequestSize] := IntToStr(TMVCConstants.DEFAULT_MAX_REQUEST_SIZE);
    end);
  FMVC.AddController(TCategoriasController);
  FMVC.AddController(TEmpresasController);
  FMVC.AddController(TMovimentacoesController);
  FMVC.AddController(TUsuariosController);
  FMVC.AddController(TResumoDiarioController);
  FMVC.AddController(TLoginController);

  FMVC.AddMiddleware(TMVCStaticFilesMiddleware.Create(
      '/static',
      TPath.Combine(ExtractFilePath(GetModuleName(HInstance)), 'www'))
    );

  FMVC.AddMiddleware(TMVCCompressionMiddleware.Create);
end;

procedure TWmPrincipal.WebModuleDestroy(Sender: TObject);
begin
  FMVC.Free;
end;

end.
