class CourtModel {
  final int id;
  final String name;
  final String description;
  final String zip_code;
  final double price_per_hour;
  final String street;
  final String number;
  final double? coordinate_x;
  final double? coordinate_y;
  final int user_id;
  final DateTime created_at;
  final DateTime updated_at;
  final DateTime? deleted_at;

  CourtModel({
    required this.id,
    required this.name,
    required this.description,
    required this.zip_code,
    required this.price_per_hour,
    required this.street,
    required this.number,
    this.coordinate_x,
    this.coordinate_y,
    required this.user_id,
    required this.created_at,
    required this.updated_at,
    this.deleted_at,
  });

  factory CourtModel.fromMap(Map<String, dynamic> map) {
    return CourtModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      zip_code: map['zip_code'],
      price_per_hour: map['price_per_hour'],
      street: map['street'],
      number: map['number'],
      coordinate_x: map['coordinate_x'],
      coordinate_y: map['coordinate_y'],
      user_id: map['user_id'],
      created_at: DateTime.parse(map['created_at']),
      updated_at: DateTime.parse(map['updated_at']),
      deleted_at:
          map['deleted_at'] != null ? DateTime.parse(map['deleted_at']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'zip_code': zip_code,
      'price_per_hour': price_per_hour,
      'street': street,
      'number': number,
      'coordinate_x': coordinate_x,
      'coordinate_y': coordinate_y,
      'user_id': user_id,
      'created_at': created_at.toIso8601String(),
      'updated_at': updated_at.toIso8601String(),
      'deleted_at': deleted_at?.toIso8601String(),
    };
  }
}
