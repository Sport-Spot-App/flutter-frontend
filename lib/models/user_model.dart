class UserModel {
  final int id;
  final String name;
  final String? photo;
  final String email;
  final String? password;
  final String document;
  final String cellphone;
  final int role;
  final bool status;
  final bool is_approved;
  final DateTime created_at;
  final DateTime updated_at;
  final DateTime? deleted_at;

  UserModel({
    required this.id,
    required this.name,
    this.photo,
    required this.email,
    this.password,
    required this.document,
    required this.cellphone,
    required this.role,
    required this.status,
    required this.is_approved,
    required this.created_at,
    required this.updated_at,
    this.deleted_at,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: int.tryParse(map['id'].toString()) ?? 0,
      name: map['name'],
      photo: map['photo'] != null ? map['photo'] as String : null,
      email: map['email'],
      document: map['document'],
      cellphone: map['cellphone'],
      role: map['role'],
      status: map['status'] == 1 ? true : false,
      is_approved: map['is_approved'] == 1 ? true : false,
      created_at: DateTime.parse(map['created_at']),
      updated_at: DateTime.parse(map['updated_at']),
      deleted_at:
          map['deleted_at'] != null ? DateTime.parse(map['deleted_at']) : null,
    );
  }

  // Método toMap para converter o objeto para JSON
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'photo': photo,
      'email': email,
      'password': password,
      'document': document,
      'cellphone': cellphone,
      'role': role,
      'status': status,
      'is_approved': is_approved,
      'created_at': created_at.toIso8601String(),
      'updated_at': updated_at.toIso8601String(),
      'deleted_at': deleted_at?.toIso8601String(),
    };
  }

   UserModel copyWith({
    int? id,
    String? name,
    String? email,
    int? role,
    String? photo,
    String? cellphone,
    String? document,
    bool? status,
    bool? isApproved,
    DateTime? emailVerifiedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      photo: photo ?? this.photo,
      cellphone: cellphone ?? this.cellphone,
      document: document ?? this.document,
      status: status ?? this.status,
      is_approved: is_approved,
      created_at: created_at,
      updated_at: updated_at,
    );
  }
}
