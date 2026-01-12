import 'package:flutter/material.dart';
import 'package:campuswork/model/user.dart';

class ModerationPage extends StatelessWidget {
  final User currentUser;

  const ModerationPage({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modération'),
      ),
      body: const Center(
        child: Text(
          'Page de modération\n(À implémenter)',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}