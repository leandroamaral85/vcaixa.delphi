unit Service.Movimentacoes;

interface

uses System.SysUtils, Classes, Model.Movimentacoes, DAO.Movimentacoes, UdmPrincipal,
     System.Generics.Collections, DAO.Empresas, DAO.Categorias, Model.ResumoDiario;

type
  TMovimentacoesService = class
  private
    vMovimentacoesDAO : TMovimentacoesDao;
    vEmpresasDAO : TEmpresasDao;
    vCategoriasDAO: TCategoriasDao;
    const MSG_NAO_ENCONTRADO: String = 'Movimentação não encontrada com este ID.';
    function Valida(pMovimentacao: TMovimentacao): Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    class function getInstancia: TMovimentacoesService;
    function CriaMovimentacoes(pIDEmpresa: Integer; pMovimentacao: TMovimentacao) : Boolean;
    function BuscaTodos(pIdEmpresa: Integer): TObjectList<TMovimentacao>;
    function BuscaPeloID(pID: Integer): TMovimentacao;
    function AtualizaMovimentacoes(pID, pIdEmpresa: Integer; pMovimentacao: TMovimentacao): Boolean;
    function ExcluiMovimentacoes(pID, pIdEmpresa: Integer): Boolean;
    function RetornaResumoDiario(pIDEmpresa: Integer): TResumoDiario;
  end;

implementation

var
   _instancia : TMovimentacoesService;

{ TMovimentacoesService }

constructor TMovimentacoesService.Create;
begin
   vMovimentacoesDAO := TMovimentacoesDao.Create(dmPrincipal.fdConexao);
   vEmpresasDAO := TEmpresasDao.Create(dmPrincipal.fdConexao);
   vCategoriasDAO := TCategoriasDao.Create(dmPrincipal.fdConexao);
end;

class function TMovimentacoesService.getInstancia: TMovimentacoesService;
begin
   if not Assigned(_instancia) then
      _instancia := TMovimentacoesService.Create;
   Result := _instancia;
end;

function TMovimentacoesService.CriaMovimentacoes(pIDEmpresa: Integer; pMovimentacao: TMovimentacao): Boolean;
begin
   pMovimentacao.empresa_id := pIDEmpresa;
   if Valida(pMovimentacao) then
      Result := vMovimentacoesDAO.Insere(pMovimentacao);
end;

function TMovimentacoesService.BuscaTodos(pIdEmpresa: Integer): TObjectList<TMovimentacao>;
begin
   Result := vMovimentacoesDAO.RetornaColecao(pIdEmpresa);
end;

function TMovimentacoesService.BuscaPeloID(pID : Integer): TMovimentacao;
begin
   Result := vMovimentacoesDAO.Retorna(pID);

   if Result = nil then
      raise Exception.Create(MSG_NAO_ENCONTRADO);
end;

function TMovimentacoesService.AtualizaMovimentacoes(pID, pIdEmpresa: Integer;
   pMovimentacao: TMovimentacao): Boolean;
var
   vMovimentacao : TMovimentacao;
begin
   try
      vMovimentacao := vMovimentacoesDAO.Retorna(pID);
      if vMovimentacao = nil then
         raise Exception.Create(MSG_NAO_ENCONTRADO);

      if vMovimentacao.empresa_id <> pIdEmpresa then
         raise Exception.Create('Esta movimentação pertence a outra empresa.');

      pMovimentacao.empresa_id := pIDEmpresa;

      if Valida(pMovimentacao) then
      begin
         pMovimentacao.Id := pID;
         Result := vMovimentacoesDAO.Atualiza(pMovimentacao);
      end;
   finally
      if Assigned(vMovimentacao) then
         FreeAndNil(vMovimentacao);
   end;
end;

function TMovimentacoesService.ExcluiMovimentacoes(pID, pIdEmpresa: Integer): Boolean;
var
   vMovimentacao : TMovimentacao;
begin
   try
      vMovimentacao := vMovimentacoesDAO.Retorna(pID);
      if vMovimentacao = nil then
         raise Exception.Create(MSG_NAO_ENCONTRADO);

      if vMovimentacao.empresa_id <> pIdEmpresa then
         raise Exception.Create('Esta movimentação pertence a outra empresa.');

      Result := vMovimentacoesDAO.Deleta(pID);
   finally
      if Assigned(vMovimentacao) then
         FreeAndNil(vMovimentacao);
   end;
end;

function TMovimentacoesService.RetornaResumoDiario(pIDEmpresa : Integer): TResumoDiario;
begin
   Result := vMovimentacoesDAO.RetornaResumoDiario(pIDEmpresa);

   if Result = nil then
      raise Exception.Create('Não há resumo para exibição');
end;

destructor TMovimentacoesService.Destroy;
begin
   FreeAndNil(vMovimentacoesDAO);
   FreeAndNil(vEmpresasDAO);
   FreeAndNil(vCategoriasDAO);
   inherited;
end;

function TMovimentacoesService.Valida(pMovimentacao: TMovimentacao): Boolean;
begin
   Result := False;

   if pMovimentacao = nil then
      raise Exception.Create('Movimentação inválida.');

   if pMovimentacao.Categoria_id = 0 then
      raise Exception.Create('O ID da categoria é obrigatório.');

   if pMovimentacao.Empresa_id = 0 then
      raise Exception.Create('O ID da empresa é obrigatório.');

   if pMovimentacao.Data = 0 then
      raise Exception.Create('A data da movimentação é obrigatória.');

   if (pMovimentacao.Tipo <> 'ENTRADA') and
      (pMovimentacao.Tipo <> 'SAIDA') then
      raise Exception.Create('O tipo da movimentação deve ser obrigatoriamente '+
         '"ENTRADA" ou "SAIDA".');

   if pMovimentacao.Valor <= 0.00 then
      raise Exception.Create('O valor da movimentação deve ser maior do que zero.');

   if Trim(pMovimentacao.Descricao) = '' then
      raise Exception.Create('A descrição movimentação é obrigatória.');

   if Length(pMovimentacao.Descricao) > 500 then
      raise Exception.Create('A descrição deve ter no máximo 500 caracteres.');

   if not vCategoriasDAO.Existe(pMovimentacao.Categoria_id) then
     raise Exception.Create('O ID da categoria é inválido.');

   if not vEmpresasDAO.Existe(pMovimentacao.empresa_id) then
     raise Exception.Create('O ID da empresa é inválido.');

   Result := True;
end;

end.
