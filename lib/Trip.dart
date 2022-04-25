class Trip {
  late String _servico, _codigolinha, _partidaprev, _chegadaprev, _placaveiculo, _nome;

  Trip(this._servico, this._codigolinha, this._partidaprev, this._chegadaprev, this._placaveiculo, this._nome);

  factory Trip.fromXML(Map<String,dynamic> xml) {
    return Trip(xml["servico"], xml["codigolinha"], xml["partidaprev"], xml["chegadaprev"], xml["placaveiculo"], xml["nome"]);
  }

  get servico => _servico;
  get codigolinha => _codigolinha;
  get partidaprev => _partidaprev;
  get chegadaprev => _chegadaprev;
  get placaveiculo => _placaveiculo;
  get nome => _nome;

}