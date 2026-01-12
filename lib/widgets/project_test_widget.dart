import 'package:flutter/material.dart';
import 'package:campuswork/model/user.dart';

/// Widget tutoriel pour apprendre à utiliser l'application
class AppTutorialWidget extends StatefulWidget {
  final User currentUser;

  const AppTutorialWidget({super.key, required this.currentUser});

  @override
  State<AppTutorialWidget> createState() => _AppTutorialWidgetState();
}

class _AppTutorialWidgetState extends State<AppTutorialWidget> {
  int _currentStep = 0;
  final PageController _pageController = PageController();

  final List<TutorialStep> _tutorialSteps = [
    TutorialStep(
      title: '🎓 Bienvenue sur CampusWork',
      description: 'Votre plateforme académique pour gérer vos projets, collaborer avec vos collègues et suivre vos cours.',
      icon: Icons.school,
      color: Color(0xFF4A90E2),
      content: 'CampusWork vous permet de créer des projets, rejoindre des groupes, participer à des sondages et bien plus encore.',
    ),
    TutorialStep(
      title: '📁 Gestion des Projets',
      description: 'Créez, partagez et gérez vos projets académiques facilement.',
      icon: Icons.folder,
      color: Color(0xFF10B981),
      content: '• Créez des projets avec descriptions détaillées\n• Ajoutez des ressources et des tags\n• Partagez avec vos collègues\n• Suivez l\'avancement de vos projets',
    ),
    TutorialStep(
      title: '👥 Groupes de Travail',
      description: 'Rejoignez ou créez des groupes pour collaborer sur vos projets.',
      icon: Icons.group,
      color: Color(0xFF8B5CF6),
      content: '• Créez des groupes par cours ou projet\n• Invitez des membres\n• Partagez des ressources\n• Organisez votre travail en équipe',
    ),
    TutorialStep(
      title: '📊 Sondages et Évaluations',
      description: 'Participez aux sondages et consultez vos évaluations.',
      icon: Icons.poll,
      color: Color(0xFFF59E0B),
      content: '• Répondez aux sondages des professeurs\n• Consultez vos notes et commentaires\n• Suivez votre progression académique\n• Recevez des feedbacks constructifs',
    ),
    TutorialStep(
      title: '🔔 Notifications et Messages',
      description: 'Restez informé des dernières actualités et messages.',
      icon: Icons.notifications,
      color: Color(0xFFEF4444),
      content: '• Recevez des notifications importantes\n• Consultez les messages de vos professeurs\n• Suivez les actualités de vos cours\n• Ne manquez aucune information importante',
    ),
    TutorialStep(
      title: '⚙️ Personnalisation',
      description: 'Personnalisez votre profil et vos préférences.',
      icon: Icons.settings,
      color: Color(0xFF6B7280),
      content: '• Modifiez vos informations personnelles\n• Configurez vos préférences\n• Gérez votre confidentialité\n• Personnalisez votre expérience',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _tutorialSteps.length - 1) {
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToStep(int step) {
    setState(() => _currentStep = step);
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _tutorialSteps[_currentStep].color,
                  _tutorialSteps[_currentStep].color.withOpacity(0.8),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.help_outline,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tutoriel d\'Utilisation',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Apprenez à utiliser CampusWork efficacement',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Progress Indicator
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Étape ${_currentStep + 1} sur ${_tutorialSteps.length}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${((_currentStep + 1) / _tutorialSteps.length * 100).round()}%',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: _tutorialSteps[_currentStep].color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: (_currentStep + 1) / _tutorialSteps.length,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _tutorialSteps[_currentStep].color,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _currentStep = index),
              itemCount: _tutorialSteps.length,
              itemBuilder: (context, index) {
                final step = _tutorialSteps[index];
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Icon
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: step.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          step.icon,
                          size: 48,
                          color: step.color,
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Title
                      Text(
                        step.title,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1D29),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Description
                      Text(
                        step.description,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: const Color(0xFF6B7280),
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Content
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE8EDF2)),
                          ),
                          child: SingleChildScrollView(
                            child: Text(
                              step.content,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: const Color(0xFF374151),
                                height: 1.6,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Navigation
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Step Indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _tutorialSteps.length,
                    (index) => GestureDetector(
                      onTap: () => _goToStep(index),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index == _currentStep
                              ? _tutorialSteps[_currentStep].color
                              : Colors.grey[300],
                        ),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Navigation Buttons
                Row(
                  children: [
                    if (_currentStep > 0)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _previousStep,
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Précédent'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _tutorialSteps[_currentStep].color,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    
                    if (_currentStep > 0) const SizedBox(width: 12),
                    
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _currentStep < _tutorialSteps.length - 1
                            ? _nextStep
                            : () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Row(
                                      children: [
                                        Icon(Icons.check_circle, color: Colors.white),
                                        SizedBox(width: 12),
                                        Text('Tutoriel terminé ! Vous êtes prêt à utiliser CampusWork.'),
                                      ],
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              },
                        icon: Icon(_currentStep < _tutorialSteps.length - 1
                            ? Icons.arrow_forward
                            : Icons.check),
                        label: Text(_currentStep < _tutorialSteps.length - 1
                            ? 'Suivant'
                            : 'Terminer'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _tutorialSteps[_currentStep].color,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TutorialStep {
  final String title;
  final String description;
  final String content;
  final IconData icon;
  final Color color;

  TutorialStep({
    required this.title,
    required this.description,
    required this.content,
    required this.icon,
    required this.color,
  });
}