unit Controller.Empresas;

interface

uses
  MVCFramework, MVCFramework.Commons, MVCFramework.Serializer.Commons;

type

  [MVCPath('/api')]
  EmpresasController = class(TMVCController) 
  protected
    procedure OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean); override;
    procedure OnAfterAction(Context: TWebContext; const AActionName: string); override;

  public
    //Sample CRUD Actions for a "Empresa" entity
    [MVCPath('/Empresas')]
    [MVCHTTPMethod([httpGET])]
    procedure GetEmpresas;

    [MVCPath('/Empresas/($id)')]
    [MVCHTTPMethod([httpGET])]
    procedure GetEmpresa(id: Integer);

    [MVCPath('/Empresas')]
    [MVCHTTPMethod([httpPOST])]
    procedure CreateEmpresa;

    [MVCPath('/Empresas/($id)')]
    [MVCHTTPMethod([httpPUT])]
    procedure UpdateEmpresa(id: Integer);

    [MVCPath('/Empresas/($id)')]
    [MVCHTTPMethod([httpDELETE])]
    procedure DeleteEmpresa(id: Integer);

  end;

implementation

uses
  System.SysUtils, MVCFramework.Logger, System.StrUtils;

procedure EmpresasController.OnAfterAction(Context: TWebContext; const AActionName: string);
begin
  { Executed after each action }
  inherited;
end;

procedure EmpresasController.OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean);
begin
  { Executed before each action
    if handled is true (or an exception is raised) the actual
    action will not be called }
  inherited;
end;

//Sample CRUD Actions for a "Empresa" entity
procedure EmpresasController.GetEmpresas;
begin
  //todo: render a list of Empresas
end;

procedure EmpresasController.GetEmpresa(id: Integer);
begin
  //todo: render the Empresa by id
end;

procedure EmpresasController.CreateEmpresa;

begin
  //todo: create a new Empresa
end;

procedure EmpresasController.UpdateEmpresa(id: Integer);
begin
  //todo: update Empresa by id
end;

procedure EmpresasController.DeleteEmpresa(id: Integer);
begin
  //todo: delete Empresa by id
end;



end.
