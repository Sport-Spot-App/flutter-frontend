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

    try {
      final response = await dio.post(
        '/login',
        data: json.encode(payload),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return AuthModel.fromMap(data);
      } else {
        throw Exception('Erro inesperado ao fazer login.');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        switch (e.response?.statusCode) {
          case 401:
            throw ('Credenciais inválidas. Verifique seu email e senha.');
          case 419:
            throw ('Erro de autenticação CSRF. Por favor, tente novamente.');
          case 500:
            throw ('Erro interno do servidor. Por favor, tente novamente mais tarde.');
          default:
            throw (
                'Erro desconhecido: ${e.response?.statusCode} - ${e.response?.data}');
        }
      } else {
        throw Exception('Erro de conexão. Verifique sua internet.');
      }
    }
  }

  @override
  Future getAuthData() async {
    try {
      final response = await dio.get('/user/auth');

      if (response.statusCode == 200) {
        var data = response.data;
        UserModel user = UserModel.fromMap(data);
        await UserMap.setUserMap(user);
        return user;
      } else {
        throw Exception('Erro inesperado ao buscar dados do usuário.');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        switch (e.response?.statusCode) {
          case 302:
            throw ('Login ou senha inválidos. Por favor, tente novamente.');
          case 401:
            throw ('Usuário não autorizado. Faça login novamente.');
          case 404:
            throw ('Dados do usuário não encontrados.');
          case 500:
            throw ('Erro interno do servidor. Por favor, tente novamente mais tarde.');
          default:
            throw (
                'Erro desconhecido: ${e.response?.statusCode} - ${e.response?.data}');
        }
      } else {
        throw ('Erro de conexão. Verifique sua internet.');
      }
    }
  }
}
