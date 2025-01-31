import 'package:dio/dio.dart';
import 'package:sport_spot/http/exceptions.dart';
import 'package:sport_spot/models/cep_model.dart';

abstract class ICepRepository {
  Future<CepModel> findCep(String cep);
}

class CepRepository implements ICepRepository {
  final Dio dio;

  CepRepository(this.dio);
  
  @override
  Future<CepModel> findCep(String cep) async {
    final response = await dio.get('/ceps/$cep');

    if (response.statusCode == 200) {
      final body = response.data;

      return CepModel.fromMap(body);
    } else if (response.statusCode == 404) {
      throw NotFoundException('A URL informada não é válida');
    } else {
      throw Exception('Erro ao buscar esportes');
    }
  }
}
