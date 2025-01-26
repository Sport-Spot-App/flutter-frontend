import 'package:flutter/material.dart';
import 'package:sport_spot/api/api.dart';
import 'package:sport_spot/common/constants/app_colors.dart';
import 'package:sport_spot/common/widgets/search_field.dart';
import 'package:sport_spot/models/user_model.dart';
import 'package:sport_spot/repositories/user_repository.dart';
import 'package:sport_spot/screens/profile/edit_profile_page.dart';
import 'package:sport_spot/stores/user_store.dart';

class CourtOwnerApprovalPage extends StatefulWidget {
  const CourtOwnerApprovalPage({super.key});

  @override
  CourtOwnerApprovalPageState createState() => CourtOwnerApprovalPageState();
}

class CourtOwnerApprovalPageState extends State<CourtOwnerApprovalPage> {
  final UserStore userStore = UserStore(repository: UserRepository(Api()));
  List<UserModel> filteredCourtOwners = [];

  @override
  void initState() {
    super.initState();
    _fetchCourtOwners();
  }

  Future<void> _fetchCourtOwners() async {
    await userStore.getUsers();
    setState(() {
      filteredCourtOwners =
          userStore.state.value.where((user) => user.role == 2).toList();
    });
  }

  void _filterCourtOwners(String query) {
    final results = userStore.state.value.where((user) {
      final userName = user.name.toLowerCase();
      final input = query.toLowerCase();
      return userName.contains(input) && user.role == 2;
    }).toList();

    setState(() {
      filteredCourtOwners = results;
    });
  }

  void approveOwner(int id) async {
    // ignore: unused_local_variable
    UserModel? owner =
        userStore.state.value.firstWhere((user) => user.id == id);
    // TODO: Aprovar usuário
    // UserModel updatedOwner = owner.copyWith(is_approved: true);
    // await userStore.updateUser(updatedOwner);
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Aprovar Proprietários',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: AppColors.darkOrange,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchField(
              hintText: 'Pesquisar proprietários',
              onChanged: _filterCourtOwners,
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<List<UserModel>>(
              valueListenable: userStore.state,
              builder: (context, users, _) {
                return ListView.builder(
                  itemCount: filteredCourtOwners.length,
                  itemBuilder: (context, index) {
                    final owner = filteredCourtOwners[index];
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => EditProfilePage(owner)));
                      },
                      child: Card(
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (owner.is_approved)
                                Text(
                                  'Aprovado',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              else
                                Text(
                                  'Aguardando aprovação',
                                  style: TextStyle(
                                    color: Colors.amber,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              Text(
                                owner.name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text('Documento: ${owner.document}'),
                              SizedBox(height: 5),
                              Text('Telefone: ${owner.cellphone}'),
                              SizedBox(height: 10),
                              if (!owner.is_approved)
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.green,
                                  ),
                                  onPressed: () => approveOwner(owner.id),
                                  child: Text('Aprovar',
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255))),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
