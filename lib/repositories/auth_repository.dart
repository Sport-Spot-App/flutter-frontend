import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/models/auth_model.dart';

abstract class IAuthRepository {
  Future<AuthModel> login(String email, String password);
}

class AuthRepository implements IAuthRepository {
  @override
  Future<AuthModel> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('http://localhost/api/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return AuthModel.fromMap(data);
    } else {
      throw Exception('Erro ao fazer login: ${response.body}');
    }
  }
}
