import 'package:flutter/material.dart';
import 'package:sport_spot/http/exceptions.dart';
import 'package:sport_spot/models/cep_model.dart';
import 'package:sport_spot/repositories/cep_repository.dart';

class CepStore {
  final ICepRepository repository;

  // Variável reativa para o loading
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  // Variável reativa para o estado
  final ValueNotifier<CepModel?> state = ValueNotifier<CepModel?>(null);

  // Variável reativa para erros
  final ValueNotifier<String> erro = ValueNotifier<String>('');

  CepStore({required this.repository});

  Future<void> findCep(String cep) async {
    isLoading.value = true;

    try {
      final result = await repository.findCep(cep);
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
