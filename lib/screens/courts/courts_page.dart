import 'package:flutter/material.dart';
import 'package:sport_spot/common/constants/app_colors.dart';
import 'package:sport_spot/common/widgets/court_card.dart';
import 'package:sport_spot/screens/court/create_court_page.dart';

class CourtsPage extends StatefulWidget {
  const CourtsPage({super.key});

  @override
  State<CourtsPage> createState() => _CourtPageState();
}

class _CourtPageState extends State<CourtsPage> {
  final List<Map<String, dynamic>> myCourts = [
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
      appBar: AppBar(
        backgroundColor: AppColors.darkOrange,
        title: Text("Minhas quadras", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: AppColors.lightOrange,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Builder(
            builder: (_) {
              if (myCourts.isNotEmpty) {
                return Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: myCourts.length,
                      itemBuilder: (context, index) {
                        final court = myCourts[index];
                        return CourtCard(
                          imageUrlList: court['image']!,
                          name: court['name']!,
                          type: court['type']!,
                          price: court['price']!,
                        );
                      },
                    ),
                    SizedBox(height: 55),
                  ],
                );
              }
              
              return Center(
                child: Text("Nenhuma quadra cadastrada!"),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          
        },
        backgroundColor: AppColors.darkOrange,
        child: Icon(Icons.add, size: 30, color: Colors.white),
      ),
    );
  }
}