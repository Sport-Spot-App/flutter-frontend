import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter_application_1/http/exceptions.dart';

abstract class IUserRepository {
  Future<List<UserModel>> getUsers();
  Future<bool> registerUser(UserModel user);
}

class UserRepository implements IUserRepository {
  @override
  Future<List<UserModel>> getUsers() async {
    final response = await http.get(Uri.parse('http://localhost/api/users'));

    if (response.statusCode == 200) {
      final List<UserModel> users = [];
      final body = jsonDecode(response.body);

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
    final response = await http.post(
      Uri.parse('http://localhost/api/users'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toMap()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else if (response.statusCode == 404) {
      throw NotFoundException('Endpoint inválido');
    } else {
      print(response.statusCode);
      print(response.body);
      throw Exception('Erro no registro');
    }
  }
}
