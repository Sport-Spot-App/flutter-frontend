import 'package:flutter/material.dart';
import 'package:sport_spot/http/exceptions.dart';
import 'package:sport_spot/models/court_model.dart';
import 'package:sport_spot/repositories/court_repository.dart';

class CourtStore {
  final ICourtRepository repository;

  // Variável reativa para o loading
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  // Variável reativa para o estado
  final ValueNotifier<List<CourtModel>> state = ValueNotifier<List<CourtModel>>([]);

  // Variável reativa para erros
  final ValueNotifier<String> erro = ValueNotifier<String>('');

  // Variável reativa para IDs de quadras favoritas
  final ValueNotifier<List<int>> favoriteCourtIds = ValueNotifier<List<int>>([]);

  CourtStore({required this.repository});

  /// Método para buscar quadras da API
  Future<void> getCourts() async {
    isLoading.value = true;

    try {
      final result = await repository.getCourts();
      state.value = result;
    } on NotFoundException catch (e) {
      erro.value = e.message;
    } catch (e) {
      erro.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// Método para realizar o registro de uma quadra na API
  Future<void> registerCourt(CourtModel court) async {
    isLoading.value = true;

    try {
      final response = await repository.registerCourt(court);

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

  /// Método para excluir uma quadra
  Future<void> deleteCourt(int id) async {
    isLoading.value = true;

    try {
      await repository.deleteCourt(id);
      await getCourts(); 
    } catch (e) {
      erro.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// Método para atualizar uma quadra
  Future<void> updateCourt(CourtModel updatedCourt) async {
    isLoading.value = true;

    try {
      final response = await repository.updateCourt(updatedCourt);

      if (response) {
        erro.value = '';
        // Atualiza a quadra na lista de estado
        final courts = state.value.map((court) {
          if (court.id == updatedCourt.id) {
            return updatedCourt; // Substitui pela quadra atualizada
          }
          return court;
        }).toList();

        state.value = courts;
      } else {
        erro.value = 'Falha ao atualizar a quadra';
      }
    } catch (e) {
      erro.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
  
  void filterCourts(String query) {
    final results = state.value.where((court) {
      final courtName = court.name.toLowerCase();
      final input = query.toLowerCase();
      return courtName.contains(input);
    }).toList();

    state.value = results;
  }

  void resetFilter() {
    getCourts();
  }

  // Método para pegar as quadras por usuário
  Future<void> getUserCourts() async {
    isLoading.value = true;

    try {
      final result = await repository.getUserCourts();
      state.value = result;
    } on NotFoundException catch (e) {
      erro.value = e.message;
    } catch (e) {
      erro.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Método para favoritar/desfavoritar uma quadra
  Future<void> favoriteCourt(int courtId) async {
    isLoading.value = true;

    try {
      await repository.favoriteCourt(courtId);
      await getFavoriteCourts();
    } catch (e) {
      erro.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Método para pegar as quadras favoritas
  Future<void> getFavoriteCourts() async {
    isLoading.value = true;

    try {
      final result = await repository.getFavoriteCourts(); 
      state.value = result;
      favoriteCourtIds.value = result.map((court) => court.id).toList();
    } on NotFoundException catch (e) {
      erro.value = e.message;
    } catch (e) {
      erro.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
