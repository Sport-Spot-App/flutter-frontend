import 'package:dio/dio.dart';
import 'package:sport_spot/http/exceptions.dart';
import 'package:sport_spot/models/booking_model.dart';

abstract class IBookingRepository {
  Future<List<BookingModel>> getBookings();
  Future<bool> registerBooking(List<BookingModel> bookings, String courtId);
  Future<void> approveBooking(int bookingId, int value);
  Future<List<BookingModel>> getBookingByCourtId(String courtId);
  Future<List<BookingModel>> getBlockedBookings(String courtId, String ownerId);
}

class BookingRepository implements IBookingRepository {
  final Dio dio;

  BookingRepository(this.dio);

// // PEGA AS RESERVAS DE UM USUÁRIO / HISTÓRICO DE RESERVAS
@override
Future<List<BookingModel>> getBookings() async {
  final response = await dio.get('/bookings');
  print('Response data: ${response.data}');  // Verificar estrutura

  if (response.statusCode == 200) {
    final List<BookingModel> bookings = [];

    if (response.data is Map<String, dynamic> && response.data.containsKey('bookings')) {
      final body = response.data['bookings'] as List<dynamic>;

      for (var item in body) {
        if (item is Map<String, dynamic>) {
          bookings.add(BookingModel.fromMap(item));
        }
      }
    }

    print('bookings: $bookings');
    return bookings;
  } else if (response.statusCode == 404) {
    throw NotFoundException('A URL informada não é válida');
  } else {
    throw Exception('Erro ao buscar reservas');
  }
}




    @override
  Future<List<BookingModel>> getBookingByCourtId(String courtId) async {
    final response = await dio.get('/bookings/court/$courtId');

    if (response.statusCode == 200) {
      final List<BookingModel> bookings = [];
      
      // Ajuste para pegar o segundo item da lista
      if (response.data is List && response.data.length > 1) {
        final body = response.data[1] as List<dynamic>; // Pegando os dados corretos

        for (var item in body) {
          if (item is Map<String, dynamic>) {
            bookings.add(BookingModel.fromMap(item));
          }
        }
      }
      
      return bookings;
    } else if (response.statusCode == 404) {
      throw NotFoundException('A URL informada não é válida');
    } else {
      throw Exception('Erro ao buscar reservas');
    }
  }


  //PEGA OS HORÁRIOS BLOQUEADOS PELO PROPRIETÁRIOS
  @override
  Future<List<BookingModel>> getBlockedBookings(
      String courtId, String ownerId) async {
    final response = await dio.get('/court/$courtId/booking/$ownerId');

    if (response.statusCode == 200) {
      final List<BookingModel> bookings = [];
      final body = response.data['bookings'] as List<dynamic>?;
      if (body != null) {
        for (var item in body) {
          if (item is Map<String, dynamic>) {
            bookings.add(BookingModel.fromMap(item));
          }
        }
      }
      return bookings;
    } else if (response.statusCode == 404) {
      throw NotFoundException('A URL informada não é válida');
    } else {
      throw Exception('Erro ao buscar reservas');
    }
  }

  @override
  Future<bool> registerBooking(
      List<BookingModel> bookings, String courtId) async {
    final data = {
      'bookings': bookings.map((booking) => booking.toMap()).toList()
    };

    final response = await dio.post('/court/book/$courtId', data: data);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<void> approveBooking(int bookingId, int value) async {
    final response = await dio.put('/approveBook/$bookingId/$value');

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Erro ao aprovar reserva');
    }
  }
}
