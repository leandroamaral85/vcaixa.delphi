unit Service.Empresas;

interface

uses System.SysUtils, Classes, Model.Empresas, DAO.Empresas, UdmPrincipal,
     System.Generics.Collections, DAO.Movimentacoes;

type
  TEmpresasService = class
  private
    vEmpresasDAO : TEmpresasDao;
    vMovimentacoesDAO: TMovimentacoesDao;
    const MSG_NAO_ENCONTRADO: String = 'Empresa não encontrada com este ID.';
    function Valida(pEmpresa: TEmpresa): Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    class function getInstancia: TEmpresasService;
    function CriaEmpresa(pEmpresa: TEmpresa) : Boolean;
    function BuscaTodos: TObjectList<TEmpresa>;
    function BuscaPeloID(pID: Integer): TEmpresa;
    function AtualizaEmpresa(pID: Integer; pEmpresa: TEmpresa): Boolean;
    function ExcluiEmpresa(pID: Integer): Boolean;
  end;

implementation

var
   _instancia : TEmpresasService;

{ TEmpresasService }

constructor TEmpresasService.Create;
begin
   vEmpresasDAO := TEmpresasDao.Create(dmPrincipal.fdConexao);
   vMovimentacoesDAO := TMovimentacoesDao.Create(dmPrincipal.fdConexao);
end;

class function TEmpresasService.getInstancia: TEmpresasService;
begin
   if not Assigned(_instancia) then
      _instancia := TEmpresasService.Create;
   Result := _instancia;
end;

function TEmpresasService.CriaEmpresa(pEmpresa: TEmpresa): Boolean;
begin
   if Valida(pEmpresa) then
      Result := vEmpresasDAO.Insere(pEmpresa);
end;

function TEmpresasService.BuscaTodos: TObjectList<TEmpresa>;
begin
   Result := vEmpresasDAO.RetornaColecao;
end;

function TEmpresasService.BuscaPeloID(pID : Integer): TEmpresa;
begin
   Result := vEmpresasDAO.Retorna(pID);

   if Result = nil then
      raise Exception.Create(MSG_NAO_ENCONTRADO);
end;

function TEmpresasService.AtualizaEmpresa(pID: Integer;
   pEmpresa: TEmpresa): Boolean;
begin
   if not vEmpresasDAO.Existe(pId) then
      raise Exception.Create(MSG_NAO_ENCONTRADO);

   if Valida(pEmpresa) then
   begin
      pEmpresa.Id := pID;
      Result := vEmpresasDAO.Atualiza(pEmpresa);
   end;
end;

function TEmpresasService.ExcluiEmpresa(pID: Integer): Boolean;
begin
   if not vEmpresasDAO.Existe(pId) then
      raise Exception.Create(MSG_NAO_ENCONTRADO);

   if vMovimentacoesDAO.ExisteMovimentacaoParaEmpresa(pId) then
      raise Exception.Create('Existem movimentações associadas a esta empresa.');

   Result := vEmpresasDAO.Deleta(pID);
end;

destructor TEmpresasService.Destroy;
begin
   FreeAndNil(vEmpresasDAO);
   FreeAndNil(vMovimentacoesDAO);
   inherited;
end;

function TEmpresasService.Valida(pEmpresa: TEmpresa): Boolean;
begin
   Result := False;

   if pEmpresa = nil then
      raise Exception.Create('Empresa inválida.');

   if Trim(pEmpresa.nome) = '' then
      raise Exception.Create('O nome é obrigatório.');

   if Trim(pEmpresa.Cnpj) = '' then
      raise Exception.Create('O CNPJ é obrigatório.');

   if Length(pEmpresa.nome) > 100 then
      raise Exception.Create('O nome deve ter no máximo 100 caracteres.');

   if Length(pEmpresa.Cnpj) > 14 then
      raise Exception.Create('O CNPJ deve ter no máximo 14 caracteres.');

   Result := True;
end;

end.
