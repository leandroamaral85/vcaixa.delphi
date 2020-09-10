unit Model.Resposta;

interface

type
  TResposta = Class
    private
      vMessage: String;
    public
      property message: string read vMessage write vMessage;
      class function MontaResposta(pMensagem: String) : TResposta;
  End;

implementation

class function TResposta.MontaResposta(pMensagem: String) : TResposta;
begin
   Result := TResposta.Create;
   Result.Message := pMensagem;
end;

end.
