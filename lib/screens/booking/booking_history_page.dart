import 'package:flutter/material.dart';
import 'package:sport_spot/models/booking_model.dart';
import 'package:sport_spot/models/court_model.dart';
import 'package:sport_spot/repositories/booking_repository.dart';
import 'package:sport_spot/api/api.dart';
import 'package:sport_spot/repositories/court_repository.dart';
import 'package:sport_spot/repositories/user_repository.dart';
import 'package:sport_spot/models/user_model.dart';
import 'package:sport_spot/stores/booking_store.dart';
import 'package:intl/intl.dart';

class BookingHistoryPage extends StatefulWidget {
  BookingHistoryPage({super.key});

  @override
  _BookingHistoryPageState createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage> {
  final BookingRepository bookingRepository = BookingRepository(Api());
  final BookingStore bookingStore = BookingStore(repository: BookingRepository(Api()));
  final CourtRepository courtRepository = CourtRepository(Api());
  final UserRepository userRepository = UserRepository(Api());
  List<BookingModel> bookings = [];

  @override
  void initState() {
    super.initState();
    fetchBookings(); // Call fetchBookings to load the bookings
  }

  Future<List<BookingModel>> fetchBookings() async {
    await bookingStore.getBookings();
    setState(() {
      bookings = bookingStore.state.value;
    });
    return bookings;
  }

  Future<CourtModel> _getCourt(int courtId) async {
    try {
      final court = await courtRepository.getCourt(courtId);
      return court;
    } catch (e) {
      print("Error fetching court: $e");
      rethrow;
    }
  }

  _approveBooking(int bookingId) async {
    await bookingStore.approveBooking(bookingId);
    final newBookings = await bookingRepository.getBookings();
    setState(() {
      bookings = newBookings;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return FutureBuilder<UserModel>(
            future: userRepository.getUser(booking.user_id!),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (userSnapshot.hasError) {
                return Center(child: Text('Erro: ${userSnapshot.error}'));
              } else if (!userSnapshot.hasData) {
                return const Center(child: Text('Usuário não encontrado'));
              } else {
                final user = userSnapshot.data!;
                final DateFormat dateFormat = DateFormat('HH:mm');
                final DateFormat dateFullFormat = DateFormat('dd/MM/yyyy');
                final String formattedStart = dateFormat.format(booking.start_datetime);
                final String formattedEnd = dateFormat.format(booking.end_datetime);
                final String formattedDate = dateFullFormat.format(booking.start_datetime);
                return FutureBuilder<CourtModel>(
                  future: _getCourt(booking.court_id),
                  builder: (context, courtSnapshot) {
                    if (courtSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (courtSnapshot.hasError) {
                      return Center(child: Text('Erro: ${courtSnapshot.error}'));
                    } else if (!courtSnapshot.hasData) {
                      return const Center(child: Text('Quadra não encontrada'));
                    } else {
                      final court = courtSnapshot.data!;
                      print("Court: ${court.toMap()}"); // Debugging line
                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: const Icon(Icons.image_not_supported, size: 60),
                          ),
                          title: Text(
                            court.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Proprietário: ${user.name}'),
                              Text('$formattedDate'),
                              Text('Das $formattedStart até $formattedEnd'),
                              Container(
                                margin: const EdgeInsets.only(top: 5),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: getStatusColor(booking.status),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  booking.status! ? 'Confirmado' : 'Aguardando Aprovação',
                                  style: const TextStyle(color: Colors.white, fontSize: 10),
                                ),
                              ),
                            ],
                          ),
                          trailing: !booking.status!
                              ? ElevatedButton(
                                  onPressed: () {
                                    _approveBooking(booking.id!);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Aprovar Reserva'),
                                )
                              : null,
                        ),
                      );
                    }
                  },
                );
              }
            },
          );
        },
      ),
    );
  }

  Color getStatusColor(bool? status) {
    if (status == null) return Colors.blue;
    return status ? Colors.green : Colors.yellow;
  }
}


