unit Service.Usuarios;

interface

uses System.SysUtils, Classes, Model.Usuarios, DAO.Usuarios, UdmPrincipal,
     System.Generics.Collections;

type
  TUsuariosService = class
  private
    vUsuariosDAO : TUsuariosDao;
    const MSG_NAO_ENCONTRADO: String = 'Usuario n�o encontrado com este ID.';
    function Valida(pUsuario: TUsuario): Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    class function getInstancia: TUsuariosService;
    function CriaUsuario(pUsuario: TUsuario) : Boolean;
    function BuscaTodos: TObjectList<TUsuario>;
    function BuscaPeloID(pID: Integer): TUsuario;
    function BuscaPeloEmail(pEmail: String): TUsuario;
    function AtualizaUsuario(pID: Integer; pUsuario: TUsuario): Boolean;
    function ExcluiUsuario(pID: Integer): Boolean;
  end;

implementation

var
   _instancia : TUsuariosService;

{ TUsuariosService }

constructor TUsuariosService.Create;
begin
   vUsuariosDAO := TUsuariosDao.Create(dmPrincipal.fdConexao);
end;

class function TUsuariosService.getInstancia: TUsuariosService;
begin
   if not Assigned(_instancia) then
      _instancia := TUsuariosService.Create;
   Result := _instancia;
end;

function TUsuariosService.CriaUsuario(pUsuario: TUsuario): Boolean;
begin
   if Valida(pUsuario) then
      Result := vUsuariosDAO.Insere(pUsuario);
end;

function TUsuariosService.BuscaTodos: TObjectList<TUsuario>;
begin
   Result := vUsuariosDAO.RetornaColecao;
end;

function TUsuariosService.BuscaPeloID(pID : Integer): TUsuario;
begin
   Result := vUsuariosDAO.Retorna(pID);

   if Result = nil then
      raise Exception.Create(MSG_NAO_ENCONTRADO);
end;

function TUsuariosService.BuscaPeloEmail(pEmail : String): TUsuario;
begin
   Result := vUsuariosDAO.RetornaPeloEmail(pEmail);

   if Result = nil then
      raise Exception.Create('Usu�rio n�o encontrado.');
end;

function TUsuariosService.AtualizaUsuario(pID: Integer;
   pUsuario: TUsuario): Boolean;
begin
   if not vUsuariosDAO.Existe(pId) then
      raise Exception.Create(MSG_NAO_ENCONTRADO);

   if Valida(pUsuario) then
   begin
      pUsuario.Id := pID;
      Result := vUsuariosDAO.Atualiza(pUsuario);
   end;
end;

function TUsuariosService.ExcluiUsuario(pID: Integer): Boolean;
begin
   if not vUsuariosDAO.Existe(pId) then
      raise Exception.Create(MSG_NAO_ENCONTRADO);

   Result := vUsuariosDAO.Deleta(pID);
end;

destructor TUsuariosService.Destroy;
begin
   FreeAndNil(vUsuariosDAO);
   inherited;
end;

function TUsuariosService.Valida(pUsuario: TUsuario): Boolean;
begin
   Result := False;

   if pUsuario = nil then
      raise Exception.Create('Usu�rio inv�lido.');

   if Trim(pUsuario.nome) = '' then
      raise Exception.Create('O nome � obrigat�rio.');

   if Trim(pUsuario.Email) = '' then
      raise Exception.Create('O e-mail � obrigat�rio.');

   if Trim(pUsuario.Senha) = '' then
      raise Exception.Create('A senha � obrigat�ria.');

   if pUsuario.Empresa_id = 0 then
      raise Exception.Create('O ID da empresa � obrigat�rio.');

   if Length(pUsuario.nome) > 50 then
      raise Exception.Create('O nome deve ter no m�ximo 50 caracteres.');

   if Length(pUsuario.email) > 100 then
      raise Exception.Create('O e-mail deve ter no m�ximo 100 caracteres.');

   if Length(pUsuario.senha) > 20 then
      raise Exception.Create('A senha deve ter no m�ximo 20 caracteres.');

   Result := True;
end;

end.
