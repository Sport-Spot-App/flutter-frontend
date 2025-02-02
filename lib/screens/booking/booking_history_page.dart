import 'package:flutter/material.dart';

class BookingHistoryPage extends StatelessWidget {
  final List<Map<String, dynamic>> bookings = [
    {
      'courtName': 'Quadra Belvedere',
      'owner': 'Jackson',
      'date': '01 de nov. de 2024',
      'time': '16h às 14h',
      'status': 'Aguardando Aprovação',
      'image':
          'https://cdn.sqhk.co/2020newsportcourt/2023/8/etghh2i/MapleSelect_B-ball,Pickleball_HerberCity_2.jpg',
    },
    {
      'courtName': 'Quadra Paraná',
      'owner': 'Jonas',
      'date': '10 de out. de 2024',
      'time': '18h às 20h',
      'status': 'Confirmado',
      'image':
          'https://cdn.sqhk.co/2020newsportcourt/2023/8/etghh2i/MapleSelect_B-ball,Pickleball_HerberCity_2.jpg',
    },
    {
      'courtName': 'Quadra Marechal',
      'owner': 'Guilherme',
      'date': '03 de abr. de 2024',
      'time': '19h às 20h',
      'status': 'Concluído',
      'image':
          'https://cdn.sqhk.co/2020newsportcourt/2023/8/etghh2i/MapleSelect_B-ball,Pickleball_HerberCity_2.jpg',
    },
  ];

  BookingHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  booking['image'],
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error);
                  },
                ),
              ),
              title: Text(
                booking['courtName'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Proprietário: ${booking['owner']}'),
                  Text('${booking['date']} - ${booking['time']}'),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: getStatusColor(booking['status']),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      booking['status'],
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
              trailing: booking['status'] == 'Aguardando Aprovação'
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
        },
      ),
    );
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Aguardando Aprovação':
        return Colors.yellow;
      case 'Confirmado':
        return Colors.green;
      case 'Concluído':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }
}
