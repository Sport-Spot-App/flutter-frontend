import 'package:flutter/material.dart';
import 'package:sport_spot/models/booking_model.dart';
import 'package:sport_spot/repositories/booking_repository.dart';

class BookingStore {
  final IBookingRepository repository;

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  final ValueNotifier<List<BookingModel>> state =
      ValueNotifier<List<BookingModel>>([]);

  final ValueNotifier<String> erro = ValueNotifier<String>('');

  BookingStore({required this.repository});

  Future<void> getCourts() async {
    isLoading.value = true;

    try {
      final result = await repository.getBookings();
      state.value = result;
    } catch (e) {
      erro.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> registerBooking(List<BookingModel> bookings, String courtId) async {
    isLoading.value = true;

    try {
      final result = await repository.registerBooking(bookings, courtId);
      if (result) {
        await getCourts();
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

  Future<void> approveBooking(int bookingId) async {
    isLoading.value = true;

    try {
      await repository.approveBooking(bookingId);
      await getCourts();
    } catch (e) {
      erro.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
