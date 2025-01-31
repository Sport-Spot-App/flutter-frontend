class CepModel {
  final String cep;
  final String logradouro;
  final String complemento;
  final String unidade;
  final String bairro;
  final String localidade;
  final String uf;
  final String estado;
  final String regiao;
  final String ibge;
  final String gia;
  final String ddd;
  final String siafi;

  CepModel({
    required this.cep,
    required this.logradouro,
    required this.complemento,
    required this.unidade,
    required this.bairro,
    required this.localidade,
    required this.uf,
    required this.estado,
    required this.regiao,
    required this.ibge,
    required this.gia,
    required this.ddd,
    required this.siafi,
  });

  factory CepModel.fromMap(Map<String, dynamic> map) {
    return CepModel(
      cep: map['cep'],
      logradouro: map['logradouro'],
      complemento: map['complemento'],
      unidade: map['unidade'],
      bairro: map['bairro'],
      localidade: map['localidade'],
      uf: map['uf'],
      estado: map['estado'],
      regiao: map['regiao'],
      ibge: map['ibge'],
      gia: map['gia'],
      ddd: map['ddd'],
      siafi: map['siafi'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "cep": cep,
      "logradouro": logradouro,
      "complemento": complemento,
      "unidade": unidade,
      "bairro": bairro,
      "localidade": localidade,
      "uf": uf,
      "estado": estado,
      "regiao": regiao,
      "ibge": ibge,
      "gia": gia,
      "ddd": ddd,
      "siafi": siafi,
    };
  }
}
