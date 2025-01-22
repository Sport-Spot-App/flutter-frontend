import 'package:flutter/material.dart';
import 'package:sport_spot/api/api.dart';
import 'package:sport_spot/common/widgets/navigation_bar.dart';
import 'package:sport_spot/repositories/user_repository.dart';
import 'package:sport_spot/stores/user_store.dart';
import 'package:sport_spot/models/user_model.dart';
import 'package:sport_spot/screens/user/edit_user_page.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<StatefulWidget> createState() => _UserListState();
}

class _UserListState extends State<UserListPage> {
  final UserStore store = UserStore(repository: UserRepository(Api()));

  @override
  void initState() {
    super.initState();
    store.getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Usuários"),
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: AnimatedBuilder(
        animation: Listenable.merge([
          store.isLoading,
          store.erro,
          store.state,
        ]),
        builder: (context, child) {
          if (store.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (store.erro.value.isNotEmpty) {
            return Center(child: Text(store.erro.value));
          }
          if (store.state.value.isEmpty) {
            return const Center(
              child: Text('Nenhum item na lista'),
            );
          } else {
            return ListView.separated(
              separatorBuilder: (context, index) => const Divider(),
              padding: const EdgeInsets.all(16),
              itemCount: store.state.value.length,
              itemBuilder: (context, index) {
                final user = store.state.value[index];
                return _buildUserCard(user);
              },
            );
          }
        },
      ),
      bottomNavigationBar: const CustomNavigationBar(
        currentIndex: 3,
      ),
    );
  }

  Widget _buildUserCard(UserModel user) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: user.photo != null
              ? NetworkImage(user.photo!)
              : const AssetImage('assets/images/default_user.png')
                  as ImageProvider,
        ),
        title: Text(
          user.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Email: ${user.email}"),
            Text("Documento: ${user.document}"),
            Text("Celular: ${user.cellphone}"),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            user.is_approved
                ? const Icon(Icons.check_circle, color: Colors.green)
                : const Icon(Icons.block, color: Colors.red),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditUserPage(
                      user: user,
                      userStore: store,
                    ),
                  ),
                ).then((value) {
                  if (value == true) {
                    store.getUsers(); // Atualiza a lista após edição
                  }
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                await _deleteUser(user.id);
              },
            ),
          ],
        ),
        onTap: () {
          _showUserDetails(user);
        },
      ),
    );
  }

  Future<void> _deleteUser(int userId) async {
    try {
      await store.deleteUser(userId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Usuário excluído com sucesso")),
      );
      store.getUsers(); // Atualiza a lista após a exclusão
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao excluir usuário")),
      );
    }
  }

  void _showUserDetails(UserModel user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Detalhes de ${user.name}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("ID: ${user.id}"),
              Text("Email: ${user.email}"),
              Text("Documento: ${user.document}"),
              Text("Celular: ${user.cellphone}"),
              Text("Role: ${user.role}"),
              Text("Status: ${user.status}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Fechar"),
            ),
          ],
        );
      },
    );
  }
}
