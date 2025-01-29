import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sport_spot/api/api.dart';
import 'package:sport_spot/common/constants/app_colors.dart';
import 'package:sport_spot/common/widgets/court_card.dart';
import 'package:sport_spot/common/widgets/search_field.dart';
import 'package:sport_spot/routes/routing_constants.dart';
import 'package:sport_spot/screens/court/all_courts_map_page.dart';
import 'package:sport_spot/screens/court/favorites_page.dart';
import 'package:sport_spot/screens/profile/profile_page.dart';
import 'package:sport_spot/screens/user/adm_users.dart';
import 'package:sport_spot/common/utils/user_map.dart';
import 'package:sport_spot/models/user_model.dart';
import 'package:sport_spot/models/court_model.dart';
import 'package:sport_spot/repositories/court_repository.dart';
import 'package:sport_spot/stores/court_store.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  UserModel? user;

  static final List<Widget> _widgetOptions = <Widget>[
    HomePageContent(),
    AllCourtsMapPage(),
    FavoritesPage(),
    ProfilePage(),
    AdmUsersScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final loadedUser = await UserMap.getUserMap();
    setState(() {
      user = loadedUser;
    });
  }

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
        return 'Mapa';
      case 2:
        return 'Favoritos';
      case 3:
        if (user != null && user!.role == 1){
          return 'Gerenciar Usuários';
        }else{
          return 'Histórico';
        }
      case 4:
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
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: 'Mapa',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
          if (user != null && user!.role == 1)
            const BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person_3_fill),
              label: 'Usuários',
            ),
        ],
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.darkOrange,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomePageContent extends StatefulWidget {
  const HomePageContent({super.key});

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  final CourtStore courtStore = CourtStore(repository: CourtRepository(Api()));
  List<CourtModel> filteredCourts = [];

  @override
  void initState() {
    super.initState();
    _fetchCourts();
  }

  Future<void> _fetchCourts() async {
    await courtStore.getCourts();
    setState(() {
      filteredCourts = courtStore.state.value;
    });
    print('Fetched courts: ${courtStore.state.value}');
    print('Filtered courts after fetch: $filteredCourts');
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
    print('Filtered results: $filteredCourts');
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
                  imageUrlList: court.photos,
                  name: court.name,
                  type: court.sports.join(', '),
                  price: court.price_per_hour.toString(),
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
