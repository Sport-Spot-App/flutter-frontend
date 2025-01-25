import 'package:flutter/material.dart';
import 'package:sport_spot/api/api.dart';
import 'package:sport_spot/common/constants/app_colors.dart';
import 'package:sport_spot/models/user_model.dart';
import 'package:sport_spot/repositories/user_repository.dart';
import 'package:sport_spot/stores/user_store.dart';

class CourtOwnerApprovalPage extends StatefulWidget {
  const CourtOwnerApprovalPage({super.key});

  @override
  CourtOwnerApprovalPageState createState() => CourtOwnerApprovalPageState();
}

class CourtOwnerApprovalPageState extends State<CourtOwnerApprovalPage> {
  final UserStore userStore = UserStore(repository: UserRepository(Api()));

  @override
  void initState() {
    super.initState();
    _fetchCourtOwners();
  }

  Future<void> _fetchCourtOwners() async {
    await userStore.getUsers();
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
      body: ValueListenableBuilder<List<UserModel>>(
        valueListenable: userStore.state,
        builder: (context, users, _) {
          List<UserModel> courtOwners =
              users.where((user) => user.role == 2).toList();
          return ListView.builder(
            itemCount: courtOwners.length,
            itemBuilder: (context, index) {
              final owner = courtOwners[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset('assets/images/user.png', width: 50),
                      Text(owner.name),
                      Text(owner.document),
                      owner.is_approved
                          ? Icon(Icons.check, color: Colors.green)
                          : ElevatedButton(
                              onPressed: () => approveOwner(owner.id),
                              child: Text('Aprovar'),
                            ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
