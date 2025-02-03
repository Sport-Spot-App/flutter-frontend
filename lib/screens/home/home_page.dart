import 'package:flutter/material.dart';
import 'package:sport_spot/api/api.dart';
import 'package:sport_spot/common/constants/app_colors.dart';
import 'package:sport_spot/common/widgets/court_card.dart';
import 'package:sport_spot/common/widgets/icon_label.dart';
import 'package:sport_spot/common/widgets/search_field.dart';
import 'package:sport_spot/routes/routing_constants.dart';
import 'package:sport_spot/models/court_model.dart';
import 'package:sport_spot/repositories/court_repository.dart';
import 'package:sport_spot/stores/court_store.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CourtStore courtStore = CourtStore(repository: CourtRepository(Api()));
  List<CourtModel> filteredCourts = [];
  List<int> favoriteCourtIds = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCourts();
    _fetchFavoriteCourts();
  }

  Future<void> _fetchCourts() async {
    await courtStore.getCourts();
    setState(() {
      filteredCourts = courtStore.state.value;
      isLoading = false;
    });
  }

  Future<void> _fetchFavoriteCourts() async {
    await courtStore.getFavoriteCourts();
    setState(() {
      favoriteCourtIds = courtStore.favoriteCourtIds.value;
    });
  }

  void _filterCourts(String query) {
    final results = courtStore.state.value.where((court) {
      final courtName = court.name.toLowerCase();
      final input = query.toLowerCase();
      return courtName.contains(input);
    }).toList();

    setState(() {
      filteredCourts = results;
    });
  }

  Future<void> _toggleFavorite(int courtId) async {
    await courtStore.favoriteCourt(courtId);
    _fetchFavoriteCourts();
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
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.darkOrange))
              : ListView.builder(
                  itemCount: filteredCourts.length,
                  itemBuilder: (context, index) {
                    final court = filteredCourts[index];
                    var isFavorite = favoriteCourtIds.contains(court.id);
                    return InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(viewCourt, arguments: court);
                      },
                      child: CourtCard(
                        imageUrlList:
                            court.photos?.map((file) => file.path).toList() ??
                                [],
                        name: court.name,
                        type: court.sports.join(', '),
                        price: court.price_per_hour,
                        favoriteIcon: IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              isFavorite = !isFavorite;
                            });
                            _toggleFavorite(court.id!);
                          },
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
