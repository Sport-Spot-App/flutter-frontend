import 'package:flutter/material.dart';
import 'package:sport_spot/api/api.dart';
import 'package:sport_spot/common/constants/app_colors.dart';
import 'package:sport_spot/common/widgets/search_field.dart';
import 'package:sport_spot/models/user_model.dart';
import 'package:sport_spot/repositories/user_repository.dart';
import 'package:sport_spot/stores/user_store.dart';

class AdmUsersScreen extends StatefulWidget {
  const AdmUsersScreen({super.key});

  @override
  State<AdmUsersScreen> createState() => _AdmUsersScreenState();
}

class _AdmUsersScreenState extends State<AdmUsersScreen> {
  final UserStore userStore = UserStore(repository: UserRepository(Api()));
  List<UserModel> filteredUsers = [];
  int? selectedRole;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    await userStore.getUsers();
    if (mounted) {
      setState(() {
        filteredUsers = userStore.state.value;
      });
    }
  }

  void _filterUsers(String query) {
    final results = userStore.state.value.where((user) {
      final userName = user.name.toLowerCase();
      final input = query.toLowerCase();
      return userName.contains(input) && (selectedRole == null || user.role == selectedRole);
    }).toList();

    if (mounted) {
      setState(() {
        filteredUsers = results;
      });
    }
  }

  void _filterByRole(int? role) {
    setState(() {
      selectedRole = role;
      _filterUsers('');
    });
  }

  String _getRoleName(int role) {
    switch (role) {
      case 1:
        return 'Administrador';
      case 2:
        return 'Proprietário';
      case 3:
        return 'Atleta';
      default:
        return 'Usuário';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                    hintText: 'Pesquisar usuários',
                    onChanged: _filterUsers,
                  ),
                ),
                // Role Icons Bar
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      IconWithLabel(
                        icon: Icons.person,
                        label: 'Todos',
                        isSelected: selectedRole == null,
                        onTap: () => _filterByRole(null),
                      ),
                      IconWithLabel(
                        icon: Icons.admin_panel_settings,
                        label: 'Admin',
                        isSelected: selectedRole == 1,
                        onTap: () => _filterByRole(1),
                      ),
                      IconWithLabel(
                        icon: Icons.sports,
                        label: 'Proprietário',
                        isSelected: selectedRole == 2,
                        onTap: () => _filterByRole(2),
                      ),
                      IconWithLabel(
                        icon: Icons.sports_handball,
                        label: 'Atleta',
                        isSelected: selectedRole == 3,
                        onTap: () => _filterByRole(3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<List<UserModel>>(
              valueListenable: userStore.state,
              builder: (context, users, _) {
                return ListView.builder(
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user = filteredUsers[index];
                    return InkWell(
                      onTap: () => _showUserOptions(context, user),
                      child: Card(
                        color: user.status ? Colors.white : Colors.grey[300],
                        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                               if (user.role == 2)
                                Container(
                                  decoration: BoxDecoration(
                                    color: user.is_approved ? Colors.green : Colors.amber,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  child: Text(
                                    user.is_approved ? 'Aprovado' : 'Aguardando aprovação',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                              if (!user.status)
                                Text(
                                  "Desativado",
                                  style: TextStyle(
                                    color: const Color.fromARGB(255, 248, 50, 0),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              Text(
                                user.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _getRoleName(user.role),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.charcoalBlue,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text('Documento: ${user.document}'),
                              const SizedBox(height: 5),
                              Text('Telefone: ${user.cellphone}'),
                              const SizedBox(height: 10),
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

  void _showUserOptions(BuildContext context, UserModel user) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (user.role == 2)
            ListTile(
              leading: Icon(user.is_approved ? Icons.close : Icons.check),
              title: Text(user.is_approved ? 'Desaprovar Proprietário' : 'Aprovar Proprietário'),
              onTap: () {
                Navigator.pop(context);
                _toggleApproval(user);
              },
            ),
            ListTile(
              leading: const Icon(Icons.block),
              title: Text(user.status ? 'Desativar Usuário' : 'Ativar Usuário'),
              onTap: () {
                Navigator.pop(context);
                _toggleStatus(user);
              },
            ),
             if (user.role != 1)
            ListTile(
              leading: const Icon(Icons.admin_panel_settings),
              title: const Text('Tornar Administrador'),
              onTap: () {
                Navigator.pop(context);
                _becomeAdm(user);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Excluir Usuário'),
              onTap: () {
                Navigator.pop(context);
                _deleteUser(user.id);
              },
            ),
          ],
        );
      },
    ).whenComplete(() => _fetchUsers()); // Ensure the screen is updated
  }

  Future<void> _toggleApproval(UserModel user) async {
    await userStore.approveUser(user);
    _fetchUsers();
  }

  Future<void> _toggleStatus(UserModel user) async {
    await userStore.updateUser(user.copyWith(status: !user.status));
    _fetchUsers();
  }

  Future<void> _deleteUser(int userId) async {
    await userStore.deleteUser(userId);
    _fetchUsers();
  }

  Future<void> _becomeAdm(UserModel user) async {
    await userStore.updateUser(user.copyWith(role: 1));
    _fetchUsers();
  }
}

class IconWithLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const IconWithLabel({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? AppColors.darkOrange : Colors.grey),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(color: isSelected ? AppColors.darkOrange : Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

