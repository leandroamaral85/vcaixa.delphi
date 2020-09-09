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
    //Sample CRUD Actions for a "Customer" entity
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
  System.SysUtils, MVCFramework.Logger, System.StrUtils;


procedure TCategoriasController.OnAfterAction(Context: TWebContext; const AActionName: string);
begin
  inherited;
end;

procedure TCategoriasController.OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean);
begin
  inherited;
end;

procedure TCategoriasController.GetCategorias;
begin
  render(200, 'Hello World!');
end;

procedure TCategoriasController.GetCategoria(id: Integer);
begin
  //todo: render the customer by id
end;

procedure TCategoriasController.CreateCategoria;

begin
  //todo: create a new customer
end;

procedure TCategoriasController.UpdateCategoria(id: Integer);
begin
  //todo: update customer by id
end;

procedure TCategoriasController.DeleteCategoria(id: Integer);
begin
  //todo: delete customer by id
end;



end.
