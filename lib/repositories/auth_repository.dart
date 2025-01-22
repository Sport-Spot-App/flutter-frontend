import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:sport_spot/models/auth_model.dart';

abstract class IAuthRepository {
  Future<AuthModel> login(String email, String password);
}

class AuthRepository implements IAuthRepository {
  final Dio dio;

  AuthRepository(this.dio);

  @override
  Future<AuthModel> login(String email, String password) async {
    var payload = {
      'email': email,
      'password': password,
    };

    final response = await dio.post('/login', data: json.encode(payload));

    if (response.statusCode == 200) {
      final data = response.data;
      return AuthModel.fromMap(data);
    } else {
      throw Exception('Erro ao fazer login: ${response.data}');
    }
  }
}
