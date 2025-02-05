import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:sport_spot/models/court_model.dart';
import 'package:sport_spot/http/exceptions.dart';
import 'package:sport_spot/models/sport_model.dart';

abstract class ICourtRepository {
  Future<List<CourtModel>> getCourts();
  Future<bool> registerCourt(CourtModel court);
  Future<void> deleteCourt(int courtId);
  Future<bool> updateCourt(CourtModel court);
  Future<List<CourtModel>> getUserCourts();
  Future<void> favoriteCourt(int courtId);
  Future<List<CourtModel>> getFavoriteCourts();
  Future<List<SportModel>> getSports();
  Future<void> findCep(String cep);
}

class CourtRepository implements ICourtRepository {
  final Dio dio;

  CourtRepository(this.dio);

  @override
  Future<List<CourtModel>> getCourts() async {
    final response = await dio.get('/courts');

    if (response.statusCode == 200) {
      final List<CourtModel> courts = [];
      final body = response.data as List<dynamic>;
      for (var item in body) {
        courts.add(CourtModel.fromMap(item as Map<String, dynamic>));
      }
      return courts;
    } else if (response.statusCode == 404) {
      throw NotFoundException('A URL informada não é válida');
    } else {
      throw Exception('Erro ao buscar quadras');
    }
  }

  @override
  Future<bool> registerCourt(CourtModel court) async {
    final formData = FormData();
    formData.fields.add(MapEntry('name', court.name));
    formData.fields.add(MapEntry('price_per_hour', court.price_per_hour));
    formData.fields.add(MapEntry('description', court.description));
    formData.fields.add(MapEntry('zip_code', court.zip_code));
    formData.fields.add(MapEntry('street', court.street));
    formData.fields.add(MapEntry('number', court.number));
    formData.fields.add(MapEntry('initial_hour', court.initial_hour!));
    formData.fields.add(MapEntry('final_hour', court.final_hour!));
    formData.fields.add(MapEntry('logradouro', court.logradouro));
    formData.fields.add(MapEntry('complemento', court.complemento));
    formData.fields.add(MapEntry('bairro', court.bairro));
    formData.fields.add(MapEntry('localidade', court.localidade));
    for (var day in court.work_days!) {
      formData.fields.add(MapEntry('work_days[]', day.toString()));
    }
    for (var sport in court.sports) {
      formData.fields.add(MapEntry('sports[]', sport.id.toString()));
    }
    formData.fields.add(MapEntry('cep', jsonEncode(court.cep?.toMap())));

    if (court.photos != null) {
      for (var i = 0; i < court.photos!.length; i++) {
        formData.files.add(MapEntry(
          'photos[$i]',
          await MultipartFile.fromFile(court.photos![i].path,
              filename: "image_$i.png"),
        ));
      }
    }

    final response = await dio.post(
      '/courts',
      data: formData,
      options: Options(
        followRedirects: false,
        validateStatus: (status) {
          return status != null && status < 500;
        },
        headers: {
          'Content-Type': 'multipart/form-data',
          'Accept': 'application/json',
        },
      ),
    );

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

  @override
  Future<List<CourtModel>> getUserCourts() async {
    final response = await dio.get('/owner/courts');

    final List<CourtModel> courts = [];
    final body = response.data;

    body.forEach((item) {
      courts.add(CourtModel.fromMap(item));
    });

    return courts;
  }

  @override
  Future<void> favoriteCourt(int courtId) async {
    final response = await dio.post('/courts/favorite/$courtId');

    if (response.statusCode != 200) {
      throw Exception('Erro ao favoritar quadra');
    }
  }

  @override
  Future<List<CourtModel>> getFavoriteCourts() async {
    final response = await dio.get('/favorites');
    if (response.statusCode == 200) {
      final List<CourtModel> courts = [];
      final body = response.data;

      body.forEach((item) {
        courts.add(CourtModel.fromMap(item));
      });

      return courts;
    } else {
      throw Exception('Erro ao buscar quadras favoritas');
    }
  }

  @override
  Future<List<SportModel>> getSports() async {
    final response = await dio.get('/sports');

    if (response.statusCode == 200) {
      final List<SportModel> sports = [];
      final body = response.data;

      body.forEach((item) {
        sports.add(SportModel.fromMap(item));
      });

      return sports;
    } else if (response.statusCode == 404) {
      throw NotFoundException('A URL informada não é válida');
    } else {
      throw Exception('Erro ao buscar esportes');
    }
  }

  @override
  Future<void> findCep(String cep) async {
    final response = await dio.get('/cep/$cep');

    if (response.statusCode == 200) {
      final body = response.data;
    } else {
      throw Exception('Erro ao buscar quadras');
    }
  }
}
