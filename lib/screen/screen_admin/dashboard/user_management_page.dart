import 'package:flutter/material.dart';
import 'package:campuswork/model/user.dart';

class UserManagementPage extends StatelessWidget {
  final User currentUser;

  const UserManagementPage({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des utilisateurs'),
      ),
      body: const Center(
        child: Text(
          'Page de gestion des utilisateurs\n(À implémenter)',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}