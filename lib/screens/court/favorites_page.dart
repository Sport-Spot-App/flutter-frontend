import 'package:flutter/material.dart';
import 'package:sport_spot/api/api.dart';
import 'package:sport_spot/common/constants/app_colors.dart';
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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFavoriteCourts();
  }

  Future<void> _fetchFavoriteCourts() async {
    await courtStore.getFavoriteCourts();
    if (mounted) {
      setState(() {
        favoriteCourts = courtStore.state.value;
        isLoading = false;
      });
    }
  }

  Future<void> _toggleFavorite(int courtId) async {
    await courtStore.favoriteCourt(courtId);
    _fetchFavoriteCourts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.darkOrange))
          : ListView.builder(
              itemCount: favoriteCourts.length,
              itemBuilder: (context, index) {
                final court = favoriteCourts[index];
                return InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(viewCourt, arguments: court);
                  },
                  child: CourtCard(
                    imageUrlList: court.photos?.map((file) {
                          final path = file.path;
                          final url = 'https://sportspott.tech/storage/$path';
                          return url;
                        }).toList() ??
                        [],
                    name: court.name,
                    type: court.sports.join(', '),
                    price: court.price_per_hour.toString(),
                    favoriteIcon: IconButton(
                      icon: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                      onPressed: () => _toggleFavorite(court.id!),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
