import 'package:shared_preferences/shared_preferences.dart';
import 'package:campuswork/model/user.dart';

/// Service pour gérer l'état des tutoriels
class TutorialService {
  static const String _tutorialPrefix = 'tutorial_completed_';

  /// Vérifier si le tutoriel a été complété pour un rôle donné
  static Future<bool> isTutorialCompleted(UserRole role) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('$_tutorialPrefix${role.name}') ?? false;
  }

  /// Marquer le tutoriel comme complété pour un rôle donné
  static Future<void> markTutorialCompleted(UserRole role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_tutorialPrefix${role.name}', true);
  }

  /// Réinitialiser le tutoriel pour un rôle donné (pour les tests)
  static Future<void> resetTutorial(UserRole role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_tutorialPrefix${role.name}');
  }

  /// Réinitialiser tous les tutoriels (pour les tests)
  static Future<void> resetAllTutorials() async {
    final prefs = await SharedPreferences.getInstance();
    for (final role in UserRole.values) {
      await prefs.remove('$_tutorialPrefix${role.name}');
    }
  }

  /// Vérifier si l'utilisateur doit voir le tutoriel
  static Future<bool> shouldShowTutorial(UserRole role) async {
    return !(await isTutorialCompleted(role));
  }
}