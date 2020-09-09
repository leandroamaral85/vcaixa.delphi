unit Service.Categorias;

interface

uses System.SysUtils, Classes, UCategorias, DAO.Categorias, UdmPrincipal;

type
  TCategoriasService = class
  private
    vCategoriasDAO : TCategoriasDao;
  public
    function CreateCategoria(pCategoria: TCategorias) : Boolean;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TCategoriasService }

constructor TCategoriasService.Create;
begin
   vCategoriasDAO := TCategoriasDao.Create(dmPrincipal.fdConexao);
end;

function TCategoriasService.CreateCategoria(pCategoria: TCategorias): Boolean;
begin
   Result := vCategoriasDAO.Insere(pCategoria);
end;

destructor TCategoriasService.Destroy;
begin
  FreeAndNil(vCategoriasDAO);
  inherited;
end;

end.
