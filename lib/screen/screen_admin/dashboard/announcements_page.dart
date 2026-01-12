import 'package:flutter/material.dart';
import 'package:campuswork/model/user.dart';

class AnnouncementsPage extends StatelessWidget {
  final User currentUser;

  const AnnouncementsPage({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Annonces'),
      ),
      body: const Center(
        child: Text(
          'Page de gestion des annonces\n(À implémenter)',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}