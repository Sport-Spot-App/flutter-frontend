import 'package:flutter/material.dart';
import 'package:sport_spot/http/exceptions.dart';
import 'package:sport_spot/models/user_model.dart';
import 'package:sport_spot/repositories/user_repository.dart';

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

  Future<void> getUser(int userId) async{
    isLoading.value = true;

    try {
      final result = await repository.getUser(userId);
      state.value = [result];
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
        final users = state.value.map((user) {
          if (user.id == updatedUser.id) {
            return updatedUser;
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

  /// Método para aprovar um usuário
  Future<void> approveUser(UserModel user) async {
    isLoading.value = true;

    try {
      final response = await repository.approveUser(user);

      if (response) {
        erro.value = '';
        await getUsers();
      } else {
        erro.value = 'Falha ao aprovar o usuário';
      }
    } catch (e) {
      erro.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> changePassword(String currentPassword, String newPassword, String confirmNewPassword) async {
    isLoading.value = true;

    try {
      final response = await repository.changePassword(currentPassword, newPassword, confirmNewPassword);
      return response;
    } catch (e) {
      erro.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
