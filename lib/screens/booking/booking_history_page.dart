import 'package:flutter/material.dart';
import 'package:sport_spot/common/constants/app_colors.dart';
import 'package:sport_spot/common/utils/user_map.dart';
import 'package:sport_spot/models/booking_model.dart';
import 'package:sport_spot/repositories/booking_repository.dart';
import 'package:sport_spot/api/api.dart';
import 'package:sport_spot/models/user_model.dart';
import 'package:sport_spot/stores/booking_store.dart';
import 'package:intl/intl.dart';

class BookingHistoryPage extends StatefulWidget {
  BookingHistoryPage({super.key});

  @override
  _BookingHistoryPageState createState() => _BookingHistoryPageState();
}

class StatusInfo {
  final Color color;
  final String text;

  StatusInfo({required this.color, required this.text});
}

class _BookingHistoryPageState extends State<BookingHistoryPage> {
  final BookingStore bookingStore = BookingStore(repository: BookingRepository(Api()));
  UserModel? authUser;
  List<BookingModel> bookings = [];
  bool isLoading = true;
  int? approvingBookingId;

  @override
  void initState() {
    super.initState();
    _loadUser();
    fetchBookings(); 
  }

  Future<void> fetchBookings() async {
    await bookingStore.getBookings();
    setState(() {
      bookings = bookingStore.state.value;
      print(bookings);
      isLoading = false; // Defina isLoading como false após carregar as reservas
    });
  }

      Future<void> _loadUser() async {
      final loadedUser = await UserMap.getUserMap();
      setState(() {
        authUser = loadedUser;
      });
    }

    Future<void> _approveBooking(int bookingId, int value) async {
      setState(() {
        approvingBookingId = bookingId;
      });
      await bookingStore.approveBooking(bookingId, value);
      await fetchBookings();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              value == 1 ? 'Reserva aprovada com sucesso!' : 'Reserva rejeitada com sucesso!',
            ),
            backgroundColor: value == 1 ? Colors.green : Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
        setState(() {
          approvingBookingId = null;
        });
      }
    }



  StatusInfo getStatus(int status) {
    if (status == 0) {
      return StatusInfo(color: const Color.fromARGB(202, 67, 136, 131), text: "Pendente");
    } else if (status == 1) {
      return StatusInfo(color: Colors.green, text: "Aprovado");
    } else if (status == 3) {
      return StatusInfo(color: Colors.red, text: "Rejeitado");
    } else {
      return StatusInfo(color: const Color.fromARGB(0, 255, 255, 255), text: "");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                final DateFormat dateFormat = DateFormat('HH:mm');
                final DateFormat dateFullFormat = DateFormat('dd/MM/yyyy');
                final String formattedStart = dateFormat.format(booking.start_datetime);
                final String formattedEnd = dateFormat.format(booking.end_datetime);
                final String formattedDate = dateFullFormat.format(booking.start_datetime);
                final statusInfo = getStatus(booking.status!);
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: const Icon(Icons.image_not_supported, size: 60),
                    ),
                    title: Text(
                      booking.court?.name ?? 'Quadra desconhecida',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Atleta: ${booking.user?.name ?? 'Desconhecido'}'),
                        Text('$formattedDate'),
                        Text('Das $formattedStart até $formattedEnd'),
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusInfo.color,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            statusInfo.text,
                            style: const TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                  
                    trailing: booking.status == 0 && authUser?.id == booking.court?.user_id
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              approvingBookingId == booking.id
                                  ? CircularProgressIndicator()
                                  : ElevatedButton(
                                      onPressed: () {
                                        _approveBooking(booking.id!, 1);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.green,
                                        foregroundColor: Colors.white,
                                      ),
                                      child: const Text('Aprovar'),
                                    ),
                              SizedBox(width: 8),
                              approvingBookingId == booking.id
                                  ? SizedBox.shrink()
                                  : ElevatedButton(
                                      onPressed: () {
                                        _approveBooking(booking.id!, 3);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.darkOrange,
                                        foregroundColor: Colors.white,
                                      ),
                                      child: const Text('Reprovar'),
                                    ),
                            ],
                          )
                        : null,
                  ),
                );
              },
            ),
    );
  }
}
