import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:sport_spot/models/court_model.dart';
import 'package:sport_spot/http/exceptions.dart';

abstract class ICourtRepository {
  Future<List<CourtModel>> getCourts();
  Future<bool> registerCourt(CourtModel court);
  Future<void> deleteCourt(int courtId);
  Future<bool> updateCourt(CourtModel court);
}

class CourtRepository implements ICourtRepository {
  final Dio dio;

  CourtRepository(this.dio);

  @override
  Future<List<CourtModel>> getCourts() async {
    final response = await dio.get('/courts');

    if (response.statusCode == 200) {
      final List<CourtModel> courts = [];
      final body = response.data;
      
       body.forEach((item) {
          courts.add(CourtModel.fromMap(item));
        });

      return courts;
    } else if (response.statusCode == 404) {
      throw NotFoundException('A URL informada não é válida');
    } else {
      throw Exception('Erro ao buscar quadras');
    }
  }

  @override
  Future<bool> registerCourt(CourtModel court) async {
    final response = await dio.post('/courts', data: jsonEncode(court.toMap()));

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else if (response.statusCode == 404) {
      throw NotFoundException('Endpoint inválido');
    } else {
      throw Exception('Erro no registro');
    }
  }

  @override
  Future<void> deleteCourt(int courtId) async {
    final response = await dio.delete('/courts/$courtId');

    if (response.statusCode != 200) {
      throw Exception("Erro ao excluir quadra");
    }
  }

  @override
  Future<bool> updateCourt(CourtModel court) async {
    final response =
        await dio.put('/courts/${court.id}', data: jsonEncode(court.toMap()));

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 404) {
      throw NotFoundException('Quadra não encontrada.');
    } else {
      throw Exception('Erro ao atualizar a quadra.');
    }
  }
}
