import 'package:flutter/material.dart';
import 'package:sport_spot/common/constants/app_colors.dart';
import 'package:sport_spot/common/widgets/court_card.dart';
import 'package:sport_spot/common/widgets/search_field.dart';
import 'package:sport_spot/routes/routing_constants.dart';
import 'package:sport_spot/screens/court/favorites_page.dart';
import 'package:sport_spot/screens/profile/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    HomePageContent(),
    FavoritesPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return 'Sport Spot';
      case 1:
        return 'Favoritos';
      case 2:
        return 'Perfil';
      default:
        return 'Sport Spot';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkOrange,
        elevation: 0,
        centerTitle: true,
        title: Text(
          _getAppBarTitle(_selectedIndex),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.darkOrange,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomePageContent extends StatefulWidget {
  HomePageContent({super.key});

  @override
  _HomePageContentState createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  final List<Map<String, dynamic>> courts = [
    {
      'image': [
        'https://media.istockphoto.com/id/179072181/pt/foto/stadium.jpg?s=2048x2048&w=is&k=20&c=GWcYRBfQ15rizVR7NQJt7VGzVlO8qHJfgDHVyKQBBE8=',
        'https://media.istockphoto.com/id/183064576/pt/foto/voleibol-em-um-gin%C3%A1sio-vazio.jpg?s=2048x2048&w=is&k=20&c=JE_mua11rdrRk1WWgOpc6yHMdNPw9Iq6gK1PnWSJBXI=',
        'https://media.istockphoto.com/id/183256716/pt/foto/bola-e-o-campo-de-basquetebol.jpg?s=2048x2048&w=is&k=20&c=pakFF7RO2wUGpJyDukM94kbBaJ4xxhcWyUuoXqu3slI='
      ],
      'name': 'Jardim Belvedere',
      'description':
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book",
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
      'description':
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book",
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
      'description':
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book",
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
      'description':
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book",
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
      'description':
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book",
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
      'description':
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book",
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
      'description':
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book",
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
      'description':
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book",
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
      'description':
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book",
      'type': 'Poliesportiva',
      'price': '60'
    },
  ];

  List<Map<String, dynamic>> filteredCourts = [];

  @override
  void initState() {
    super.initState();
    filteredCourts = courts;
  }

  void _filterCourts(String query) {
    final results = courts.where((court) {
      final courtName = court['name']!.toLowerCase();
      final input = query.toLowerCase();
      return courtName.contains(input);
    }).toList();

    setState(() {
      filteredCourts = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 243, 243, 243),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 3),
                blurRadius: 6,
              ),
            ],
          ),
          child: Column(
            children: [
              // Search Field
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SearchField(
                  hintText: 'Pesquisar quadras',
                  onChanged: _filterCourts,
                ),
              ),
              // Sports Icons Bar
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: const [
                    IconWithLabel(
                        icon: Icons.sports_volleyball, label: 'Vôlei'),
                    IconWithLabel(icon: Icons.sports_tennis, label: 'Tênis'),
                    IconWithLabel(icon: Icons.sports_soccer, label: 'Futebol'),
                    IconWithLabel(
                        icon: Icons.sports_basketball, label: 'Basquete'),
                    IconWithLabel(
                        icon: Icons.sports_handball, label: 'Handebol'),
                    IconWithLabel(
                        icon: Icons.sports_rugby, label: 'Futebol Americano'),
                    IconWithLabel(
                        icon: Icons.beach_access_outlined,
                        label: 'Beach Tennis'),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Court Card List
        Expanded(
          child: ListView.builder(
            itemCount: filteredCourts.length,
            itemBuilder: (context, index) {
              final court = filteredCourts[index];
              return InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(viewCourt, arguments: court);
                },
                child: CourtCard(
                  imageUrlList: court['image'],
                  name: court['name']!,
                  type: court['type']!,
                  price: court['price']!,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class IconWithLabel extends StatelessWidget {
  final IconData icon;
  final String label;

  const IconWithLabel({required this.icon, required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
