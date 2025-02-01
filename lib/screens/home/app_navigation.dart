import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sport_spot/api/api.dart';
import 'package:sport_spot/common/constants/app_colors.dart';
import 'package:sport_spot/common/utils/user_map.dart';
import 'package:sport_spot/models/user_model.dart';
import 'package:sport_spot/repositories/court_repository.dart';
import 'package:sport_spot/screens/court/all_courts_map_page.dart';
import 'package:sport_spot/screens/court/favorites_page.dart';
import 'package:sport_spot/screens/home/home_page.dart';
import 'package:sport_spot/screens/profile/profile_page.dart';
import 'package:sport_spot/screens/user/adm_users.dart';
import 'package:sport_spot/stores/court_store.dart';

class AppNavigation extends StatefulWidget {
  const AppNavigation({super.key});

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  int _selectedIndex = 0;
  UserModel? user;
  final CourtStore courtStore = CourtStore(repository: CourtRepository(Api()));

  static final List<Widget> _widgetOptions = <Widget>[
    HomePage(),
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
          return 'Perfil';
      case 4:
        return 'Gerenciar Usuários';
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