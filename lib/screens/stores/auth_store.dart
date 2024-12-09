import 'package:flutter/material.dart';
import 'package:flutter_application_1/repositories/auth_repository.dart';
import 'package:flutter_application_1/models/auth_model.dart';

class AuthStore {
  final IAuthRepository repository;

  // Variável reativa para o loading
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  // Variável reativa para o erro
  final ValueNotifier<String> error = ValueNotifier<String>('');

  // Variável para armazenar o token
  AuthModel? auth;

  AuthStore({required this.repository});

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    error.value = '';

    try {
      auth = await repository.login(email, password);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
