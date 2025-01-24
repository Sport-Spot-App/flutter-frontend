import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:sport_spot/models/user_model.dart';
import 'package:sport_spot/http/exceptions.dart';

abstract class IUserRepository {
  Future<List<UserModel>> getUsers();
  Future<bool> registerUser(UserModel user);
  Future<void> deleteUser(int userId);
  Future<bool> updateUser(UserModel user);
}

class UserRepository implements IUserRepository {
  final Dio dio;

  UserRepository(this.dio);

  @override
  Future<List<UserModel>> getUsers() async {
    final response = await dio.get('/users');

    if (response.statusCode == 200) {
      final List<UserModel> users = [];
      final body = response.data;

      body.forEach((item) {
        print(item);
        users.add(UserModel.fromMap(item));
      });

      return users;
    } else if (response.statusCode == 404) {
      throw NotFoundException('A URL informada não é válida');
    } else {
      throw Exception('Erro ao buscar usuários');
    }
  }

  @override
  Future<bool> registerUser(UserModel user) async {
    final response = await dio.post('/users',  data: jsonEncode(user.toMap()));

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else if (response.statusCode == 404) {
      throw NotFoundException('Endpoint inválido');
    } else {
      print(response.statusCode);
      print(response.data);
      throw Exception('Erro no registro');
    }
  }

  @override
  Future<void> deleteUser(int userId) async {
    final response = await dio.delete('/users/$userId');

    if (response.statusCode != 200) {
      throw Exception("Erro ao excluir usuário");
    }
  }

  @override
  Future<bool> updateUser(UserModel user) async {
    final response = await dio.put('/users/${user.id}', data: jsonEncode(user.toMap()));

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 404) {
      throw NotFoundException('Usuário não encontrado.');
    } else {
      print(response.statusCode);
      print(response.data);
      throw Exception('Erro ao atualizar o usuário.');
    }
  }
}
