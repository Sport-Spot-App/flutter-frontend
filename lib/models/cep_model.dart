class CepModel {
  final int id;
  final String name;

  CepModel({
    required this.id,
    required this.name,
  });

  factory CepModel.fromMap(Map<String, dynamic> map) {
    return CepModel(
      id: map['id'],
      name: map['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
