import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:sport_spot/api/api.dart';
import 'package:sport_spot/models/user_model.dart';
import 'package:sport_spot/http/exceptions.dart';
import 'package:sport_spot/repositories/auth_repository.dart';

abstract class IUserRepository {
  get dio => null;

  Future<List<UserModel>> getUsers();
  Future<UserModel> getUser(int userId);
  Future<bool> registerUser(UserModel user);
  Future<void> deleteUser(int userId);
  Future<bool> updateUser(UserModel user);
  Future<bool> approveUser(UserModel user);
  Future<bool> changePassword(String currentPassword, String newPassword, String confirmNewPassword);
}

class UserRepository implements IUserRepository {
  final Dio dio;
  final AuthRepository repository = AuthRepository(Api());

  UserRepository(this.dio);

  @override
  Future<List<UserModel>> getUsers() async {
    final response = await dio.get('/users');

    if (response.statusCode == 200) {
      final List<UserModel> users = [];
      final body = response.data;

      body.forEach((item) {
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
    final response = await dio.post('/users', data: jsonEncode(user.toMap()));

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else if (response.statusCode == 404) {
      throw NotFoundException('Endpoint inválido');
    } else {
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
    final response =
        await dio.put('/users/${user.id}', data: jsonEncode(user.toMap()));

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 404) {
      throw NotFoundException('Usuário não encontrado.');
    } else {
      throw Exception('Erro ao atualizar o usuário.');
    }
  }

  @override
  Future<bool> approveUser(UserModel user) async {
    final response = await dio.put('/users/${user.id}/approve');

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 404) {
      throw NotFoundException('Usuário não encontrado.');
    } else {
      throw Exception('Erro ao aprovar o usuário.');
    }
  }

  @override
  Future<bool> changePassword(String currentPassword, String newPassword, String confirmNewPassword) async {

    final requestData = {
      'current_password': currentPassword,
      'password': newPassword,
      'password_confirmation': confirmNewPassword,
    };

    final response = await dio.patch('/reset-password', data: requestData);

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 400) {
      throw Exception('Senha atual incorreta.');
    } else {
      throw Exception('Erro ao alterar senha.');
    }
  }

  Future<UserModel> getUser(int userId) async {
    final response = await dio.get('/users/$userId');
    return UserModel.fromMap(response.data);
  }
}
