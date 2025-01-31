import 'package:dio/dio.dart';
import 'package:sport_spot/http/exceptions.dart';
import 'package:sport_spot/models/sport_model.dart';

abstract class ISportRepository {
  Future<List<SportModel>> getSports();
}

class SportRepository implements ISportRepository {
  final Dio dio;

  SportRepository(this.dio);
  
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
}
