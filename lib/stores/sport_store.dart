import 'package:flutter/material.dart';
import 'package:sport_spot/http/exceptions.dart';
import 'package:sport_spot/models/sport_model.dart';
import 'package:sport_spot/repositories/sport_repository.dart';

class SportStore {
  final ISportRepository repository;

  // Variável reativa para o loading
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  // Variável reativa para o estado
  final ValueNotifier<List<SportModel>> state = ValueNotifier<List<SportModel>>([]);

  // Variável reativa para erros
  final ValueNotifier<String> erro = ValueNotifier<String>('');

  SportStore({required this.repository});

  /// Método para buscar quadras da API
  Future<void> getSports() async {
    isLoading.value = true;

    try {
      final result = await repository.getSports();
      state.value = result;
    } on NotFoundException catch (e) {
      erro.value = e.message;
    } catch (e) {
      erro.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
