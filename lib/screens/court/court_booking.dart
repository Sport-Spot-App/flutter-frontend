import 'package:flutter/material.dart';
import 'package:booking_calendar/booking_calendar.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sport_spot/common/constants/app_colors.dart';

class CourtBookingPage extends StatefulWidget {
  @override
  _CourtBookingPageState createState() => _CourtBookingPageState();
}

class _CourtBookingPageState extends State<CourtBookingPage> {
  // Horários de funcionamento da quadra
  final DateTime now = DateTime.now();
  final List<DateTimeRange> bookedSlots = [];

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('pt_BR', null).then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Agendar Quadra")),
      body: BookingCalendar(
        bookingService: BookingService(
          serviceName: "Quadra de Esportes",
          serviceDuration: 60,
          bookingStart: DateTime(now.year, now.month, now.day, 8, 0),
          bookingEnd: DateTime(now.year, now.month, now.day, 22, 0), 
        ),
        getBookingStream: _getBookedSlots,
        uploadBooking: _addNewBooking,
        convertStreamResultToDateTimeRanges: _convertStreamResultToDateTimeRanges,
        loadingWidget: const Center(child: CircularProgressIndicator()),
        hideBreakTime: true,
        disabledDays: [DateTime.sunday],
        locale: 'pt_BR',
        bookingButtonText: 'Reservar',
        bookingButtonColor: AppColors.darkOrange,
        availableSlotText: 'Disponível',
        bookedSlotText: 'Reservado',
        selectedSlotText: 'Selecionado',
        selectedSlotColor: AppColors.darkOrange,
      ),
    );
  }

  Stream<dynamic>? _getBookedSlots({required DateTime start, required DateTime end}) {
    return Stream.value(bookedSlots);
  }

  Future<void> _addNewBooking({required BookingService newBooking}) async {
    setState(() {
      bookedSlots.add(DateTimeRange(start: newBooking.bookingStart, end: newBooking.bookingEnd));
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Reserva feita com sucesso das ${newBooking.bookingStart} às ${newBooking.bookingEnd}")),
    );
  }

  // Converte os horários reservados para exibição no calendário
  List<DateTimeRange> _convertStreamResultToDateTimeRanges({required dynamic streamResult}) {
    return streamResult as List<DateTimeRange>;
  }
}
