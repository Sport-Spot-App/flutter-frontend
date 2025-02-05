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
        print("Error fetching details for booking: $e");
      }
    }

    if (mounted) {
      setState(() {
        bookings = bookingsWithDetails;
        isLoading = false;
      });
    }
  }

  _approveBooking(int bookingId) async {
    await bookingStore.approveBooking(bookingId);
    final newBookings = await bookingRepository.getBookings();

    List<BookingWithDetails> updatedBookingsWithDetails = [];
    for (var booking in newBookings) {
      try {
        final court = await courtRepository.getCourt(booking.court_id);
        final owner = await userRepository.getUser(court.user_id!);
        final user = await userRepository.getUser(booking.user_id!);
        updatedBookingsWithDetails.add(BookingWithDetails(
          booking: booking,
          court: court,
          owner: owner,
          user: user,
        ));
      } catch (e) {
        print("Error fetching details for booking: $e");
      }
    }

    if (mounted) {
      setState(() {
        bookings = updatedBookingsWithDetails;
      });
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
                              backgroundColor: AppColors.darkOrange,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Aprovar Reserva'),
                          )
                        : null,
                  ),
                );
              },
            ),
    );
  }

  Color getStatusColor(bool? status) {
    if (status == null) return Colors.blue;
    return status ? Colors.green : const Color.fromARGB(202, 67, 136, 131);
  }
}


