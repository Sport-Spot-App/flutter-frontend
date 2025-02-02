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
import 'package:sport_spot/screens/booking/booking_history_page.dart';

class AppNavigation extends StatefulWidget {
  const AppNavigation({super.key});

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  int _selectedIndex = 0;
  UserModel? user;
  final CourtStore courtStore = CourtStore(repository: CourtRepository(Api()));

  static final List<Widget> _adminOptions = <Widget>[
    HomePage(),
    AllCourtsMapPage(),
    FavoritesPage(),
    ProfilePage(),
    AdmUsersScreen(),
  ];

  static final List<Widget> _ownerAthleteOptions = <Widget>[
    HomePage(),
    AllCourtsMapPage(),
    FavoritesPage(),
    ProfilePage(),
    BookingHistoryPage(),
  ];

  static final List<Widget> _defaultOptions = <Widget>[
    HomePage(),
    AllCourtsMapPage(),
    FavoritesPage(),
    ProfilePage(),
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
        if (user != null && user!.role == 1) {
          return 'Gerenciar Usuários';
        } else if (user != null && (user!.role == 2 || user!.role == 3)) {
          return 'Histórico de Reservas';
        }
        return 'Sport Spot';
      default:
        return 'Sport Spot';
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions;
    List<BottomNavigationBarItem> _bottomNavItems = [
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
    ];

    if (user != null) {
      if (user!.role == 1) {
        _widgetOptions = _adminOptions;
        _bottomNavItems.add(
          const BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_3_fill),
            label: 'Usuários',
          ),
        );
      } else if (user!.role == 2 || user!.role == 3) {
        _widgetOptions = _ownerAthleteOptions;
        _bottomNavItems.add(
          const BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Histórico',
          ),
        );
      } else {
        _widgetOptions = _defaultOptions;
      }
    } else {
      _widgetOptions = _defaultOptions;
    }

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
        items: _bottomNavItems,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.darkOrange,
        onTap: _onItemTapped,
      ),
    );
  }
}
