import 'package:flutter/material.dart';
import 'package:sport_spot/http/exceptions.dart';
import 'package:sport_spot/models/user_model.dart';
import 'package:sport_spot/repositories/user_repository.dart';

class UserStore {
  final IUserRepository repository;

  // Variável reativa para o loading
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  // Variável reativa para o estado
  final ValueNotifier<List<UserModel>> state = ValueNotifier<List<UserModel>>([]);

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

  /// Método para excluir um usuário
  Future<void> deleteUser(int id) async {
    isLoading.value = true;

    try {
      await repository.deleteUser(id);
      await getUsers(); // Atualiza a lista de usuários
    } catch (e) {
      erro.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// Método para atualizar um usuário
  Future<void> updateUser(UserModel updatedUser) async {
    isLoading.value = true;

    try {
      final response = await repository.updateUser(updatedUser);

      if (response) {
        erro.value = '';
        // Atualiza o usuário na lista de estado
        final users = state.value.map((user) {
          if (user.id == updatedUser.id) {
            return updatedUser; // Substitui pelo usuário atualizado
          }
          return user;
        }).toList();

        state.value = users;
      } else {
        erro.value = 'Falha ao atualizar o usuário';
      }
    } catch (e) {
      erro.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getUserData() async {
    isLoading.value = true;
    erro.value = '';

    try {
      await repository.getUserData();
    } catch (e) {
      erro.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
