import 'package:flutter/material.dart';
import 'package:sport_spot/api/api.dart';
import 'package:sport_spot/common/constants/app_colors.dart';
import 'package:sport_spot/common/widgets/court_owner_card.dart';
import 'package:sport_spot/repositories/auth_repository.dart';
import 'package:sport_spot/repositories/court_repository.dart';
import 'package:sport_spot/repositories/user_repository.dart';
import 'package:sport_spot/screens/court/create_court_page.dart';
import 'package:sport_spot/stores/court_store.dart';
import 'package:sport_spot/stores/user_store.dart';
import 'package:flutter/cupertino.dart';

class CourtsPage extends StatefulWidget {
  const CourtsPage({super.key});

  @override
  State<CourtsPage> createState() => _CourtPageState();
}

class _CourtPageState extends State<CourtsPage> {
  final UserStore store = UserStore(repository: UserRepository(Api()));
  final CourtStore storeCourt = CourtStore(repository: CourtRepository(Api()));
  final AuthRepository authRepository = AuthRepository(Api());
  List<Map<String, dynamic>> myCourts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserCourts();
  }

  Future<void> _fetchUserCourts() async {
    try {
      final courts = await storeCourt.repository.getUserCourts();
      setState(() {
        myCourts = courts.map((court) => court.toMap()).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao buscar quadras: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkOrange,
        title: const Text("Minhas quadras", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.grey[200],
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Builder(
                  builder: (_) {
                    if (myCourts.isNotEmpty) {
                      return Column(
                        children: [
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            separatorBuilder: (context, index) => const SizedBox(height: 10),
                            itemCount: myCourts.length,
                            itemBuilder: (context, index) {
                              final court = myCourts[index];
                              return CourtOwnerCard(court);
                            },
                          ),
                          const SizedBox(height: 55),
                        ],
                      );
                    }
                    return SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Icon(CupertinoIcons.doc_text_search, size: 50, color: Colors.grey),
                          SizedBox(height: 10),
                          Text(
                            "Você não tem nenhuma quadra cadastrada, cadastre uma agora!",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    );
                  },
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CreateCourtPage()));
        },
        backgroundColor: AppColors.darkOrange,
        child: const Icon(Icons.add, size: 30, color: Colors.white),
      ),
    );
  }
}