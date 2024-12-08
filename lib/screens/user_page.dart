import 'package:flutter/material.dart';
import 'package:flutter_application_1/repositories/user_repository.dart';
import 'package:flutter_application_1/screens/stores/user_store.dart';
import 'package:flutter_application_1/models/user_model.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<StatefulWidget> createState() => _UserListState();
}

class _UserListState extends State<UserListPage> {
  final UserStore store = UserStore(repository: UserRepository());

  @override
  void initState() {
    super.initState();
    store.getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Usuários"),
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
        trailing: user.is_approved
            ? const Icon(Icons.check_circle, color: Colors.green)
            : const Icon(Icons.block, color: Colors.red),
        onTap: () {
          _showUserDetails(user);
        },
      ),
    );
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
