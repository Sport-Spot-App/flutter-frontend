import 'package:flutter/material.dart';
import 'package:booking_calendar/booking_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sport_spot/api/api.dart';
import 'package:sport_spot/common/constants/app_colors.dart';
import 'package:sport_spot/common/utils/user_map.dart';
import 'package:sport_spot/models/booking_model.dart';
import 'package:sport_spot/models/court_model.dart';
import 'package:sport_spot/models/user_model.dart';
import 'package:sport_spot/repositories/booking_repository.dart';
import 'package:sport_spot/repositories/user_repository.dart';
import 'package:sport_spot/stores/booking_store.dart';
import 'package:sport_spot/stores/user_store.dart';

class CourtBookingPage extends StatefulWidget {
  final CourtModel court;

  CourtBookingPage({required this.court});

  @override
  _CourtBookingPageState createState() => _CourtBookingPageState();
}

class _CourtBookingPageState extends State<CourtBookingPage> {
  final DateTime now = DateTime.now();
  final List<DateTimeRange> bookedSlots = [];
  final List<DateTimeRange> blockedSlots = [];
  final BookingRepository bookingRepository = BookingRepository(Api());
  final BookingStore bookingStore =
      BookingStore(repository: BookingRepository(Api()));
  final UserStore userStore = UserStore(repository: UserRepository(Api()));
  UserModel? authUser;

  @override
  void initState() {
    super.initState();
    _loadUser();
    initializeDateFormatting('pt_BR', null).then((_) {
      setState(() {});
    });
  }

  Future<void> _loadUser() async {
    final loadedUser = await UserMap.getUserMap();
    setState(() {
      authUser = loadedUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    final initialHour = widget.court.initial_hour != null
        ? TimeOfDay(
            hour: int.parse(widget.court.initial_hour!.split(":")[0]),
            minute: int.parse(widget.court.initial_hour!.split(":")[1]),
          )
        : TimeOfDay(hour: 8, minute: 0);

    final finalHour = widget.court.final_hour != null
        ? TimeOfDay(
            hour: int.parse(widget.court.final_hour!.split(":")[0]),
            minute: int.parse(widget.court.final_hour!.split(":")[1]),
          )
        : TimeOfDay(hour: 22, minute: 0);

    final workDays = widget.court.work_days != null
        ? widget.court.work_days!.map((day) => _dayStringToInt(day)).toList()
        : [];

    final blockedDays = List.generate(7, (index) => index + 1)
        .where((day) => !workDays.contains(day))
        .toList();

    bool isCourtOwner = authUser?.id == widget.court.user_id;

    return Scaffold(
      appBar: AppBar(title: const Text("Agendar Quadra")),
      body: FutureBuilder<List<DateTimeRange>>(
        future: _getBlockedSlots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar dados'));
          }
          final blockedSlots = snapshot.data ?? [];
          return BookingCalendar(
            bookingService: BookingService(
              serviceName: "Quadra de Esportes",
              serviceDuration: 60,
              bookingStart: DateTime(now.year, now.month, now.day, initialHour.hour,
                  initialHour.minute),
              bookingEnd: DateTime(
                  now.year, now.month, now.day, finalHour.hour, finalHour.minute),
            ),
            getBookingStream: _getBookedSlots,
            uploadBooking: _registerBooking,
            pauseSlots: blockedSlots,
            convertStreamResultToDateTimeRanges:
                _convertStreamResultToDateTimeRanges,
            loadingWidget: const Center(child: CircularProgressIndicator()),
            hideBreakTime: false,
            disabledDays: blockedDays,
            locale: 'pt_BR',
            bookingButtonText: isCourtOwner ? 'Bloquear horário' : 'Reservar',
            bookingButtonColor: AppColors.darkOrange,
            availableSlotText: 'Disponível',
            availableSlotColor: const Color.fromARGB(255, 102, 191, 145),
            bookedSlotText: 'Reservado',
            selectedSlotText: 'Selecionado',
            selectedSlotColor: AppColors.darkOrange,
          );
        },
      ),
    );
  }

  int _dayStringToInt(String day) {
    switch (day.toLowerCase()) {
      case 'monday':
        return DateTime.monday;
      case 'tuesday':
        return DateTime.tuesday;
      case 'wednesday':
        return DateTime.wednesday;
      case 'thursday':
        return DateTime.thursday;
      case 'friday':
        return DateTime.friday;
      case 'saturday':
        return DateTime.saturday;
      case 'sunday':
      default:
        return DateTime.sunday;
    }
  }

  Stream<List<DateTimeRange>> _getBookedSlots(
      {required DateTime start, required DateTime end}) async* {
    try {
      final bookings = await bookingRepository
          .getBookingByCourtId(widget.court.id!.toString());
      final bookedRanges = bookings
          .map((booking) => DateTimeRange(
                start: booking.start_datetime,
                end: booking.end_datetime,
              ))
          .toList();
      yield bookedRanges;
    } catch (e) {
      yield [];
    }
  }

  Future<List<DateTimeRange>> _getBlockedSlots() async {
    try {
      final blockedbookings = await bookingStore.getBlockedBookings(
          widget.court.id!.toString(), widget.court.user_id.toString());
          print('Blocked bookings: $blockedbookings');
      return blockedbookings
          .map((booking) => DateTimeRange(
                start: booking.start_datetime,
                end: booking.end_datetime,
              ))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> _registerBooking({required BookingService newBooking}) async {
    final List<BookingModel> bookings = [
      BookingModel(
        court_id: widget.court.id!,
        start_datetime: newBooking.bookingStart,
        end_datetime: newBooking.bookingEnd,
      )
    ];

    try {
      final success = await bookingStore.registerBooking(
          bookings, widget.court.id.toString());
      if (success) {
        setState(() {
          bookedSlots.add(DateTimeRange(
            start: newBooking.bookingStart,
            end: newBooking.bookingEnd,
          ));
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(authUser?.id == widget.court.user_id
                  ? 'Horário Bloqueado com sucesso'
                  : 'Reserva feita com sucesso!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao fazer reserva')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao fazer reserva: $e')),
      );
    }
  }

  List<DateTimeRange> _convertStreamResultToDateTimeRanges(
      {required dynamic streamResult}) {
    return streamResult as List<DateTimeRange>;
  }
}
