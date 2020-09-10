unit Service.Categorias;

interface

uses System.SysUtils, Classes, Model.Categorias, DAO.Categorias, UdmPrincipal,
     System.Generics.Collections, DAO.Movimentacoes;

type
  TCategoriasService = class
  private
    vCategoriasDAO : TCategoriasDao;
    vMovimentacoesDAO: TMovimentacoesDao;
    const MSG_NAO_ENCONTRADO: String = 'Categoria não encontrada com este ID.';
    function Valida(pCategoria: TCategoria): Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    class function getInstancia: TCategoriasService;
    function CriaCategoria(pCategoria: TCategoria) : Boolean;
    function BuscaTodos: TObjectList<TCategoria>;
    function BuscaPeloID(pID: Integer): TCategoria;
    function AtualizaCategoria(pID: Integer; pCategoria: TCategoria): Boolean;
    function ExcluiCategoria(pID: Integer): Boolean;
  end;

implementation

var
   _instancia : TCategoriasService;

{ TCategoriasService }

constructor TCategoriasService.Create;
begin
   vCategoriasDAO := TCategoriasDao.Create(dmPrincipal.fdConexao);
   vMovimentacoesDAO := TMovimentacoesDao.Create(dmPrincipal.fdConexao);
end;

class function TCategoriasService.getInstancia: TCategoriasService;
begin
   if not Assigned(_instancia) then
      _instancia := TCategoriasService.Create;
   Result := _instancia;
end;

function TCategoriasService.CriaCategoria(pCategoria: TCategoria): Boolean;
begin
   if Valida(pCategoria) then
      Result := vCategoriasDAO.Insere(pCategoria);
end;

function TCategoriasService.BuscaTodos: TObjectList<TCategoria>;
begin
   Result := vCategoriasDAO.RetornaColecao;
end;

function TCategoriasService.BuscaPeloID(pID : Integer): TCategoria;
begin
   Result := vCategoriasDAO.Retorna(pID);

   if Result = nil then
      raise Exception.Create(MSG_NAO_ENCONTRADO);
end;

function TCategoriasService.AtualizaCategoria(pID: Integer;
   pCategoria: TCategoria): Boolean;
begin
   if not vCategoriasDAO.Existe(pId) then
      raise Exception.Create(MSG_NAO_ENCONTRADO);

   if Valida(pCategoria) then
   begin
      pCategoria.Id := pID;
      Result := vCategoriasDAO.Atualiza(pCategoria);
   end;
end;

function TCategoriasService.ExcluiCategoria(pID: Integer): Boolean;
begin
   if not vCategoriasDAO.Existe(pId) then
      raise Exception.Create(MSG_NAO_ENCONTRADO);

   if vMovimentacoesDAO.ExisteMovimentacaoParaCategoria(pId) then
      raise Exception.Create('Existem movimentações associadas a esta categoria.');

   Result := vCategoriasDAO.Deleta(pID);
end;

destructor TCategoriasService.Destroy;
begin
  FreeAndNil(vCategoriasDAO);
  FreeAndNil(vMovimentacoesDAO);
  inherited;
end;

function TCategoriasService.Valida(pCategoria: TCategoria): Boolean;
begin
   Result := False;

   if pCategoria = nil then
      raise Exception.Create('Categoria inválida.');

   if Trim(pCategoria.nome) = '' then
      raise Exception.Create('O nome é obrigatório.');

   if Length(pCategoria.nome) > 50 then
      raise Exception.Create('O nome deve ter no máximo 50 caracteres.');

   Result := True;
end;

end.
