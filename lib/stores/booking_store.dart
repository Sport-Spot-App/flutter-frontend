import 'package:flutter/material.dart';
import 'package:sport_spot/models/booking_model.dart';
import 'package:sport_spot/repositories/booking_repository.dart';
import 'package:dio/dio.dart';

class BookingStore {
  final IBookingRepository repository;

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  final ValueNotifier<List<BookingModel>> state =
      ValueNotifier<List<BookingModel>>([]);

  final ValueNotifier<String> erro = ValueNotifier<String>('');

  BookingStore({required this.repository});

  Future<List<BookingModel>> getBookings() async {
    isLoading.value = true;

    try {
      final result = await repository.getBookings();
      state.value = result;
      return result;
    } catch (e) {
      erro.value = e.toString();
    } finally {
      isLoading.value = false;
    }
    return [];
  }

  Future<bool> registerBooking(List<BookingModel> bookings, String courtId) async {
    isLoading.value = true;

    try {
      final result = await repository.registerBooking(bookings, courtId);
      if (result) {
        return true;
      }
    } catch (e) {
      erro.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
    return false;
  }

  Future<void> approveBooking(int bookingId, int value) async {
    isLoading.value = true;

    try {
      await repository.approveBooking(bookingId, value);
    } on DioException catch (e) {
      erro.value = 'Erro: ${e.response?.statusCode} - ${e.response?.statusMessage}\n${e.response?.data}';
    } catch (e) {
      erro.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<BookingModel>> getBookingsByCourtId(String courtId) async {
    isLoading.value = true;
    try {
      final result = await repository.getBookingByCourtId(courtId);
      return result;
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        erro.value = 'Acesso negado: ${e.response?.statusMessage}';
      } else {
        erro.value =
            'Erro: ${e.response?.statusCode} - ${e.response?.statusMessage}\n${e.response?.data}';
      }
      return [];
    } catch (e) {
      erro.value = e.toString();
      return [];
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<BookingModel>> getBlockedBookings(String courtId, String ownerId) async {
    isLoading.value = true;

    try {
      final result = await repository.getBlockedBookings(courtId, ownerId);
      return result;
    } catch (e) {
      erro.value = e.toString();
      return [];
    } finally {
      isLoading.value = false;
    }
  }

}
