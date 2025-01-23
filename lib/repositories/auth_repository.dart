import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:sport_spot/common/utils/user_map.dart';
import 'package:sport_spot/models/auth_model.dart';
import 'package:sport_spot/models/user_model.dart';

abstract class IAuthRepository {
  Future<AuthModel> login(String email, String password);
  Future<void> getAuthData();
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

  @override
  Future<void> getAuthData() async {
    final response = await dio.get('/user/auth');

    if (response.statusCode == 200) {
      var data = response.data;
      UserModel user = UserModel.fromMap(data);
      await UserMap.setUserMap(user);
    } else {
      throw Exception('Erro ao buscar usuário: ${response.data}');
    }
  }
}
