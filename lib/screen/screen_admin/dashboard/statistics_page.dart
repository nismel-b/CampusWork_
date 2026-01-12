import 'package:flutter/material.dart';
import 'package:campuswork/model/user.dart';

class StatisticsPage extends StatelessWidget {
  final User currentUser;

  const StatisticsPage({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistiques détaillées'),
      ),
      body: const Center(
        child: Text(
          'Page de statistiques détaillées\n(À implémenter)',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}