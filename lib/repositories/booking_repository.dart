import 'package:dio/dio.dart';
import 'package:sport_spot/http/exceptions.dart';
import 'package:sport_spot/models/booking_model.dart';

abstract class IBookingRepository {
  Future<List<BookingModel>> getBookings();
  Future<bool> registerBooking(List<BookingModel> bookings, String courtId);
  Future<void> approveBooking(int bookingId);
}

class BookingRepository implements IBookingRepository {
  final Dio dio;

  BookingRepository(this.dio);

  Future<List<BookingModel>> getBookings() async {
    final response = await dio.get('/bookings');

    if (response.statusCode == 200) {
      final List<BookingModel> bookings = [];
      final body = response.data as Map<String, dynamic>?;
      if (body != null && body['bookings'] != null) {
        for (var item in body['bookings']) {
          bookings.add(BookingModel.fromMap(item as Map<String, dynamic>));
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

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<void> approveBooking(int bookingId) async {
    final response = await dio.post('/approveBook/$bookingId');

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Erro ao aprovar reserva');
    }
  }
}
