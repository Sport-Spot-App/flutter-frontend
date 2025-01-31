import 'package:flutter/material.dart';
import 'package:sport_spot/api/api.dart';
import 'package:sport_spot/common/widgets/court_card.dart';
import 'package:sport_spot/models/court_model.dart';
import 'package:sport_spot/repositories/court_repository.dart';
import 'package:sport_spot/routes/routing_constants.dart';
import 'package:sport_spot/stores/court_store.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final CourtStore courtStore = CourtStore(repository: CourtRepository(Api()));
  List<CourtModel> favoriteCourts = [];

  @override
  void initState() {
    super.initState();
    _fetchFavoriteCourts();
  }

  Future<void> _fetchFavoriteCourts() async {
    await courtStore.getFavoriteCourts();
    setState(() {
      favoriteCourts = courtStore.state.value;
    });
  }

  Future<void> _toggleFavorite(int courtId) async {
    await courtStore.favoriteCourt(courtId);
    _fetchFavoriteCourts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: favoriteCourts.length,
        itemBuilder: (context, index) {
          final court = favoriteCourts[index];
          return InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(viewCourt, arguments: court);
            },
            child: CourtCard(
              imageUrlList: court.photos,
              name: court.name,
              type: court.sports.join(', '),
              price: court.price_per_hour.toString(),
              favoriteIcon: IconButton(
                icon: Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
                onPressed: () => _toggleFavorite(court.id),
              ),
            ),
          );
        },
      ),
    );
  }
}
