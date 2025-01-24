import 'package:flutter/material.dart';
import 'package:sport_spot/common/widgets/court_card.dart';

class FavoritesPage extends StatelessWidget {
  FavoritesPage({super.key});

  final List<Map<String, dynamic>> courts = [
    {
      'image': [
        'https://media.istockphoto.com/id/183064576/pt/foto/voleibol-em-um-gin%C3%A1sio-vazio.jpg?s=2048x2048&w=is&k=20&c=JE_mua11rdrRk1WWgOpc6yHMdNPw9Iq6gK1PnWSJBXI=',
        'https://media.istockphoto.com/id/179072181/pt/foto/stadium.jpg?s=2048x2048&w=is&k=20&c=GWcYRBfQ15rizVR7NQJt7VGzVlO8qHJfgDHVyKQBBE8=',
        'https://media.istockphoto.com/id/183256716/pt/foto/bola-e-o-campo-de-basquetebol.jpg?s=2048x2048&w=is&k=20&c=pakFF7RO2wUGpJyDukM94kbBaJ4xxhcWyUuoXqu3slI='
      ],
      'name': 'Jardim Belvedere',
      'type': 'Poliesportiva',
      'price': '60'
    },
    {
      'image': [
        'https://media.istockphoto.com/id/183064576/pt/foto/voleibol-em-um-gin%C3%A1sio-vazio.jpg?s=2048x2048&w=is&k=20&c=JE_mua11rdrRk1WWgOpc6yHMdNPw9Iq6gK1PnWSJBXI=',
        'https://media.istockphoto.com/id/179072181/pt/foto/stadium.jpg?s=2048x2048&w=is&k=20&c=GWcYRBfQ15rizVR7NQJt7VGzVlO8qHJfgDHVyKQBBE8=',
        'https://media.istockphoto.com/id/183256716/pt/foto/bola-e-o-campo-de-basquetebol.jpg?s=2048x2048&w=is&k=20&c=pakFF7RO2wUGpJyDukM94kbBaJ4xxhcWyUuoXqu3slI='
      ],
      'name': 'Centro',
      'type': 'Poliesportiva',
      'price': '60'
    },
    {
      'image': [
        'https://media.istockphoto.com/id/183064576/pt/foto/voleibol-em-um-gin%C3%A1sio-vazio.jpg?s=2048x2048&w=is&k=20&c=JE_mua11rdrRk1WWgOpc6yHMdNPw9Iq6gK1PnWSJBXI=',
        'https://media.istockphoto.com/id/179072181/pt/foto/stadium.jpg?s=2048x2048&w=is&k=20&c=GWcYRBfQ15rizVR7NQJt7VGzVlO8qHJfgDHVyKQBBE8=',
        'https://media.istockphoto.com/id/183256716/pt/foto/bola-e-o-campo-de-basquetebol.jpg?s=2048x2048&w=is&k=20&c=pakFF7RO2wUGpJyDukM94kbBaJ4xxhcWyUuoXqu3slI='
      ],
      'name': 'Jardim São Paulo',
      'type': 'Poliesportiva',
      'price': '60'
    },
    {
      'image': [
        'https://media.istockphoto.com/id/183064576/pt/foto/voleibol-em-um-gin%C3%A1sio-vazio.jpg?s=2048x2048&w=is&k=20&c=JE_mua11rdrRk1WWgOpc6yHMdNPw9Iq6gK1PnWSJBXI=',
        'https://media.istockphoto.com/id/179072181/pt/foto/stadium.jpg?s=2048x2048&w=is&k=20&c=GWcYRBfQ15rizVR7NQJt7VGzVlO8qHJfgDHVyKQBBE8=',
        'https://media.istockphoto.com/id/183256716/pt/foto/bola-e-o-campo-de-basquetebol.jpg?s=2048x2048&w=is&k=20&c=pakFF7RO2wUGpJyDukM94kbBaJ4xxhcWyUuoXqu3slI='
      ],
      'name': 'Jardim Belvedere',
      'type': 'Poliesportiva',
      'price': '60'
    },
    {
      'image': [
        'https://media.istockphoto.com/id/183064576/pt/foto/voleibol-em-um-gin%C3%A1sio-vazio.jpg?s=2048x2048&w=is&k=20&c=JE_mua11rdrRk1WWgOpc6yHMdNPw9Iq6gK1PnWSJBXI=',
        'https://media.istockphoto.com/id/179072181/pt/foto/stadium.jpg?s=2048x2048&w=is&k=20&c=GWcYRBfQ15rizVR7NQJt7VGzVlO8qHJfgDHVyKQBBE8=',
        'https://media.istockphoto.com/id/183256716/pt/foto/bola-e-o-campo-de-basquetebol.jpg?s=2048x2048&w=is&k=20&c=pakFF7RO2wUGpJyDukM94kbBaJ4xxhcWyUuoXqu3slI='
      ],
      'name': 'Centro',
      'type': 'Poliesportiva',
      'price': '60'
    },
    {
      'image': [
        'https://media.istockphoto.com/id/183064576/pt/foto/voleibol-em-um-gin%C3%A1sio-vazio.jpg?s=2048x2048&w=is&k=20&c=JE_mua11rdrRk1WWgOpc6yHMdNPw9Iq6gK1PnWSJBXI=',
        'https://media.istockphoto.com/id/179072181/pt/foto/stadium.jpg?s=2048x2048&w=is&k=20&c=GWcYRBfQ15rizVR7NQJt7VGzVlO8qHJfgDHVyKQBBE8=',
        'https://media.istockphoto.com/id/183256716/pt/foto/bola-e-o-campo-de-basquetebol.jpg?s=2048x2048&w=is&k=20&c=pakFF7RO2wUGpJyDukM94kbBaJ4xxhcWyUuoXqu3slI='
      ],
      'name': 'Jardim São Paulo',
      'type': 'Poliesportiva',
      'price': '60'
    },
    {
      'image': [
        'https://media.istockphoto.com/id/183064576/pt/foto/voleibol-em-um-gin%C3%A1sio-vazio.jpg?s=2048x2048&w=is&k=20&c=JE_mua11rdrRk1WWgOpc6yHMdNPw9Iq6gK1PnWSJBXI=',
        'https://media.istockphoto.com/id/179072181/pt/foto/stadium.jpg?s=2048x2048&w=is&k=20&c=GWcYRBfQ15rizVR7NQJt7VGzVlO8qHJfgDHVyKQBBE8=',
        'https://media.istockphoto.com/id/183256716/pt/foto/bola-e-o-campo-de-basquetebol.jpg?s=2048x2048&w=is&k=20&c=pakFF7RO2wUGpJyDukM94kbBaJ4xxhcWyUuoXqu3slI='
      ],
      'name': 'Jardim Belvedere',
      'type': 'Poliesportiva',
      'price': '60'
    },
    {
      'image': [
        'https://media.istockphoto.com/id/183064576/pt/foto/voleibol-em-um-gin%C3%A1sio-vazio.jpg?s=2048x2048&w=is&k=20&c=JE_mua11rdrRk1WWgOpc6yHMdNPw9Iq6gK1PnWSJBXI=',
        'https://media.istockphoto.com/id/179072181/pt/foto/stadium.jpg?s=2048x2048&w=is&k=20&c=GWcYRBfQ15rizVR7NQJt7VGzVlO8qHJfgDHVyKQBBE8=',
        'https://media.istockphoto.com/id/183256716/pt/foto/bola-e-o-campo-de-basquetebol.jpg?s=2048x2048&w=is&k=20&c=pakFF7RO2wUGpJyDukM94kbBaJ4xxhcWyUuoXqu3slI='
      ],
      'name': 'Centro',
      'type': 'Poliesportiva',
      'price': '60'
    },
    {
      'image': [
        'https://media.istockphoto.com/id/183064576/pt/foto/voleibol-em-um-gin%C3%A1sio-vazio.jpg?s=2048x2048&w=is&k=20&c=JE_mua11rdrRk1WWgOpc6yHMdNPw9Iq6gK1PnWSJBXI=',
        'https://media.istockphoto.com/id/179072181/pt/foto/stadium.jpg?s=2048x2048&w=is&k=20&c=GWcYRBfQ15rizVR7NQJt7VGzVlO8qHJfgDHVyKQBBE8=',
        'https://media.istockphoto.com/id/183256716/pt/foto/bola-e-o-campo-de-basquetebol.jpg?s=2048x2048&w=is&k=20&c=pakFF7RO2wUGpJyDukM94kbBaJ4xxhcWyUuoXqu3slI='
      ],
      'name': 'Jardim São Paulo',
      'type': 'Poliesportiva',
      'price': '60'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: AppColors.darkOrange,
      //   title: const Text('Favoritos')
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Search Field
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Pesquisar quadras',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            // Court Card List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: courts.length,
              itemBuilder: (context, index) {
                final court = courts[index];
                return CourtCard(
                  imageUrlList: court['image'],
                  name: court['name']!,
                  type: court['type']!,
                  price: court['price']!,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
