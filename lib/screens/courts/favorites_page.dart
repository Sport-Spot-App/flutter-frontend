import 'package:flutter/material.dart';
import 'package:sport_spot/common/constants/app_colors.dart';
import 'package:sport_spot/common/constants/app_text_styles.dart';

class FavoritesPage extends StatelessWidget {
  FavoritesPage({super.key});

  final List<Map<String, String>> courts = [
    {
      'image': 'assets/images/tennis-player-big-hall.jpg',
      'name': 'Jardim Belvedere',
      'type': 'Poliesportiva',
      'price': '60'
    },
    {
      'image': 'assets/images/basketball_court.png',
      'name': 'Centro',
      'type': 'Poliesportiva',
      'price': '60'
    },
    {
      'image': 'assets/images/basketball_court.png',
      'name': 'Jardim São Paulo',
      'type': 'Poliesportiva',
      'price': '60'
    },
    {
      'image': 'assets/images/basketball_court.png',
      'name': 'Jardim Belvedere',
      'type': 'Poliesportiva',
      'price': '60'
    },
    {
      'image': 'assets/images/basketball_court.png',
      'name': 'Centro',
      'type': 'Poliesportiva',
      'price': '60'
    },
    {
      'image': 'assets/images/basketball_court.png',
      'name': 'Jardim São Paulo',
      'type': 'Poliesportiva',
      'price': '60'
    },
    {
      'image': 'assets/images/basketball_court.png',
      'name': 'Jardim Belvedere',
      'type': 'Poliesportiva',
      'price': '60'
    },
    {
      'image': 'assets/images/basketball_court.png',
      'name': 'Centro',
      'type': 'Poliesportiva',
      'price': '60'
    },
    {
      'image': 'assets/images/basketball_court.png',
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
        title: const Text('Favoritos')
      ),
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
                return _buildCourtCard(
                  imageUrl: court['image']!,
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

  Widget _buildCourtCard({
    required String imageUrl,
    required String name,
    required String type,
    required String price,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Court Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            child: Image.asset(
              imageUrl,
              height: 350,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // Court Info
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.mediumText.copyWith(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  height: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  type,
                  style: AppTextStyles.smallText.copyWith(
                  color: const Color.fromARGB(255, 100, 100, 100),
                  height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'R\$$price/hora',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
