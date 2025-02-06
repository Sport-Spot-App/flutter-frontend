import 'package:flutter/material.dart';
import 'package:sport_spot/common/constants/app_colors.dart';
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

class BookingWithDetails {
  final BookingModel booking;
  final CourtModel court;
  final UserModel user;
  final UserModel owner;

  BookingWithDetails({
    required this.booking,
    required this.court,
    required this.user,
    required this.owner,
  });
}

class StatusInfo {
  final Color color;
  final String text;

  StatusInfo({required this.color, required this.text});
}

class _BookingHistoryPageState extends State<BookingHistoryPage> {
  final BookingRepository bookingRepository = BookingRepository(Api());
  final BookingStore bookingStore = BookingStore(repository: BookingRepository(Api()));
  final CourtRepository courtRepository = CourtRepository(Api());
  final UserRepository userRepository = UserRepository(Api());
  List<BookingWithDetails> bookings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBookings(); // Call fetchBookings to load the bookings
  }

  Future<void> fetchBookings() async {
    await bookingStore.getBookings();
    List<BookingModel> fetchedBookings = bookingStore.state.value;
    print('Fetched bookings: $fetchedBookings');
    List<BookingWithDetails> bookingsWithDetails = [];
    for (var booking in fetchedBookings) {
      try {
        final court = await courtRepository.getCourt(booking.court_id);
        final user = await userRepository.getUser(booking.user_id!);
        final owner = await userRepository.getUser(court.user_id!);
        bookingsWithDetails.add(BookingWithDetails(
          booking: booking,
          court: court,
          user: user,
          owner: owner,
        ));
      } catch (e) {
        Exception('Erro ao buscar reservas: $e');
      }
    }

    if (mounted) {
      setState(() {
        bookings = bookingsWithDetails;
        isLoading = false;
      });
    }
  }

  Future<void> _approveBooking(int bookingId, int value) async {
    await bookingStore.approveBooking(bookingId, value);
    await fetchBookings();
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
                final bookingWithDetails = bookings[index];
                final booking = bookingWithDetails.booking;
                final court = bookingWithDetails.court;
                final user = bookingWithDetails.user;
                final owner = bookingWithDetails.owner;
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
                      court.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Atleta: ${user.name}'),
                        Text('Proprietário: ${owner.name}'),
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
                    trailing: booking.status == 0
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton(
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
                              ElevatedButton(
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


