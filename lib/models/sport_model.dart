class SportModel {
  final int id;
  final String name;

  SportModel({
    required this.id,
    required this.name,
  });

  factory SportModel.fromMap(Map<String, dynamic> map) {
    return SportModel(
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
