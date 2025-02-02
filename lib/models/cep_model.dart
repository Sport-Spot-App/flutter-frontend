class CepModel {
  final String cep;
  final String logradouro;
  final String complemento;
  final String bairro;
  final String localidade;
  final String uf;
  final String estado;

  CepModel({
    required this.cep,
    required this.logradouro,
    required this.complemento,
    required this.bairro,
    required this.localidade,
    required this.uf,
    required this.estado,
  });

  factory CepModel.fromMap(Map<String, dynamic> map) {
    return CepModel(
      cep: map['cep'],
      logradouro: map['logradouro'],
      complemento: map['complemento'],
      bairro: map['bairro'],
      localidade: map['localidade'],
      uf: map['uf'],
      estado: map['estado'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "cep": cep,
      "logradouro": logradouro,
      "complemento": complemento,
      "bairro": bairro,
      "localidade": localidade,
      "uf": uf,
      "estado": estado,
    };
  }
}
