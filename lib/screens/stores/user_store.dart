import 'package:flutter/material.dart';
import 'package:flutter_application_1/http/exceptions.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter_application_1/repositories/user_repository.dart';

class UserStore {
  final IUserRepository repository;

  // Variável reativa para o loading
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  // Variável reativa para o estado
  final ValueNotifier<List<UserModel>> state =
      ValueNotifier<List<UserModel>>([]);

  // Variável reativa para erros
  final ValueNotifier<String> erro = ValueNotifier<String>('');

  UserStore({required this.repository});

  /// Método para buscar usuários da API
  Future<void> getUsers() async {
    isLoading.value = true;

    try {
      final result = await repository.getUsers();
      state.value = result;
    } on NotFoundException catch (e) {
      erro.value = e.message;
    } catch (e) {
      erro.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// Método para realizar o registro de um usuário na API
  Future<void> registerUser(UserModel user) async {
    isLoading.value = true;

    try {
      final response = await repository.registerUser(user);

      if (response) {
        // Caso o registro seja bem-sucedido
        erro.value = '';
      } else {
        erro.value = 'Falha no registro';
      }
    } on NotFoundException catch (e) {
      erro.value = e.message;
    } catch (e) {
      erro.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
