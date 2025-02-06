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
import 'package:flutter/cupertino.dart';

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
  String selectedSport = '';

  @override
  void initState() {
    super.initState();
    _fetchCourts();
    _fetchFavoriteCourts();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchCourts();
    _fetchFavoriteCourts();
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
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

  void _filterBySport(String? sportName) {
    final results = sportName == null
        ? courtStore.state.value
        : courtStore.state.value.where((court) {
            return court.sports.any((sport) => sport.name == sportName);
          }).toList();

    setState(() {
      filteredCourts = results;
      selectedSport = sportName ?? '';
    });
  }

  Future<void> _toggleFavorite(int courtId) async {
    await courtStore.favoriteCourt(courtId);
    _fetchFavoriteCourts();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _fetchCourts();
        _fetchFavoriteCourts();
        return true;
      },
      child: Column(
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 5.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: IconWithLabel(
                          icon: Icons.sports,
                          label: 'Todos',
                          isSelected: selectedSport == '',
                          onTap: () => _filterBySport(null),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: IconWithLabel(
                          icon: Icons.sports_volleyball,
                          label: 'Vôlei',
                          isSelected: selectedSport == 'Vôlei',
                          onTap: () => _filterBySport('Vôlei'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: IconWithLabel(
                          icon: Icons.sports_tennis,
                          label: 'Tênis',
                          isSelected: selectedSport == 'Tênis',
                          onTap: () => _filterBySport('Tênis'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: IconWithLabel(
                          icon: Icons.sports_soccer,
                          label: 'Futebol',
                          isSelected: selectedSport == 'Futebol',
                          onTap: () => _filterBySport('Futebol'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: IconWithLabel(
                          icon: Icons.sports_basketball,
                          label: 'Basquete',
                          isSelected: selectedSport == 'Basquete',
                          onTap: () => _filterBySport('Basquete'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: IconWithLabel(
                          icon: Icons.sports_handball,
                          label: 'Handebol',
                          isSelected: selectedSport == 'Handebol',
                          onTap: () => _filterBySport('Handebol'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: IconWithLabel(
                          icon: CupertinoIcons.sportscourt,
                          label: 'Futsal',
                          isSelected: selectedSport == 'Futsal',
                          onTap: () => _filterBySport('Futsal'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: IconWithLabel(
                          icon: Icons.beach_access_outlined,
                          label: 'Beach Tênis',
                          isSelected: selectedSport == 'Beach Tênis',
                          onTap: () => _filterBySport('Beach Tênis'),
                        ),
                      ),
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
                    child:
                        CircularProgressIndicator(color: AppColors.darkOrange))
                : ListView.builder(
                    itemCount: filteredCourts.length,
                    itemBuilder: (context, index) {
                      final court = filteredCourts[index];
                      var isFavorite = favoriteCourtIds.contains(court.id);
                      return InkWell(
                        onTap: () async {
                          await Navigator.of(context)
                              .pushNamed(viewCourt, arguments: court);
                          _fetchCourts();
                          _fetchFavoriteCourts();
                        },
                        child: CourtCard(
                          imageUrlList: court.photos?.map((file) {
                                final path = file.path;
                                final url =
                                    'https://sportspott.tech/storage/$path';
                                return url;
                              }).toList() ??
                              [],
                          name: court.name,
                          type: court.sports
                              .map((sport) => sport.name)
                              .join(', '),
                          price: court.price_per_hour
                              .toString()
                              .replaceAll('.', ','),
                          favoriteIcon: IconButton(
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
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
      ),
    );
  }
}
