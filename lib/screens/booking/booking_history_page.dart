import 'package:flutter/material.dart';
import 'package:sport_spot/models/booking_model.dart';
import 'package:sport_spot/repositories/booking_repository.dart';
import 'package:sport_spot/api/api.dart';
import 'package:sport_spot/repositories/user_repository.dart';
import 'package:sport_spot/models/user_model.dart';

class BookingHistoryPage extends StatefulWidget {
  BookingHistoryPage({super.key});

  @override
  _BookingHistoryPageState createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage> {
  final BookingRepository bookingRepository = BookingRepository(Api());
  final UserRepository userRepository = UserRepository(Api());
  late Future<List<BookingModel>> futureBookings;

  @override
  void initState() {
    super.initState();
    futureBookings = bookingRepository.getBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<BookingModel>>(
        future: futureBookings,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma reserva encontrada'));
          } else {
            final bookings = snapshot.data!;
            return ListView.builder(
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
                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              'https://cdn.sqhk.co/2020newsportcourt/2023/8/etghh2i/MapleSelect_B-ball,Pickleball_HerberCity_2.jpg',
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.error);
                              },
                            ),
                          ),
                          title: Text(
                            'Quadra ${booking.court_id}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Proprietário: ${user.name}'),
                              Text(
                                  '${booking.start_datetime} - ${booking.end_datetime}'),
                              Container(
                                margin: const EdgeInsets.only(top: 5),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: getStatusColor(booking.status),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  booking.status!
                                      ? 'Confirmado'
                                      : 'Aguardando Aprovação',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                          trailing: !booking.status!
                              ? ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Cancelar'),
                                )
                              : null,
                        ),
                      );
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  Color getStatusColor(bool? status) {
    if (status == null) return Colors.blue;
    return status ? Colors.green : Colors.yellow;
  }
}
