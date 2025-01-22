import 'package:flutter/material.dart';
import 'package:sport_spot/api/token/token_storage.dart';
import 'package:sport_spot/repositories/auth_repository.dart';

class AuthStore {
  final IAuthRepository repository;

  // Variável reativa para o loading
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  // Variável reativa para o erro
  final ValueNotifier<String> error = ValueNotifier<String>('');

  AuthStore({required this.repository});

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    error.value = '';

    try {
      await repository.login(email, password);

    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    final tokenStorage = TokenStorage();
    await tokenStorage.delete();
  }
}
