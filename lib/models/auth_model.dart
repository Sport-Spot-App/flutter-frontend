class AuthModel {
  final String token;

  AuthModel({required this.token});

  factory AuthModel.fromMap(Map<String, dynamic> map) {
    return AuthModel(token: map['token']);
  }

  Map<String, dynamic> toMap() {
    return {'token': token};
  }
}
