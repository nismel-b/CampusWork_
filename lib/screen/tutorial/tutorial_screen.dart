import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:campuswork/model/user.dart';
import 'package:campuswork/widgets/app_logo.dart';
import 'package:campuswork/services/tutorial_service.dart';

/// Écran de tutoriel adapté selon le rôle de l'utilisateur
class TutorialScreen extends StatefulWidget {
  final UserRole userRole;

  const TutorialScreen({
    super.key,
    required this.userRole,
  });

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late List<TutorialPage> _pages;

  @override
  void initState() {
    super.initState();
    _pages = _getTutorialPages(widget.userRole);
  }

  List<TutorialPage> _getTutorialPages(UserRole role) {
    switch (role) {
      case UserRole.student:
        return [
          TutorialPage(
            title: 'Bienvenue Étudiant !',
            description: 'Découvrez comment utiliser CampusWork pour gérer vos projets universitaires et collaborer avec vos camarades.',
            icon: Icons.school,
            color: const Color(0xFF4A90E2),
            features: [
              'Créer et partager vos projets',
              'Rejoindre des groupes de travail',
              'Participer aux sondages',
              'Collaborer avec d\'autres étudiants',
            ],
          ),
          TutorialPage(
            title: 'Gérez vos Projets',
            description: 'Créez, modifiez et partagez vos projets universitaires. Ajoutez des descriptions, des ressources et suivez votre progression.',
            icon: Icons.folder_open,
            color: const Color(0xFF10B981),
            features: [
              'Créer des projets détaillés',
              'Ajouter des ressources et liens',
              'Suivre l\'état d\'avancement',
              'Recevoir des évaluations',
            ],
          ),
          TutorialPage(
            title: 'Rejoignez des Groupes',
            description: 'Trouvez et rejoignez des groupes de travail pour collaborer sur des projets communs et échanger des idées.',
            icon: Icons.group,
            color: const Color(0xFF8B5CF6),
            features: [
              'Parcourir les groupes ouverts',
              'Rejoindre des groupes par cours',
              'Collaborer en temps réel',
              'Partager des ressources',
            ],
          ),
          TutorialPage(
            title: 'Participez aux Sondages',
            description: 'Répondez aux sondages de vos professeurs et donnez votre avis sur les cours et les projets.',
            icon: Icons.poll,
            color: const Color(0xFFF59E0B),
            features: [
              'Répondre aux sondages',
              'Donner votre feedback',
              'Voir les résultats',
              'Améliorer les cours',
            ],
          ),
        ];

      case UserRole.lecturer:
        return [
          TutorialPage(
            title: 'Bienvenue Enseignant !',
            description: 'Découvrez comment utiliser CampusWork pour gérer vos cours, évaluer les projets et interagir avec vos étudiants.',
            icon: Icons.school,
            color: const Color(0xFF4A90E2),
            features: [
              'Gérer vos cours et projets',
              'Créer et gérer des groupes',
              'Évaluer les projets étudiants',
              'Créer des sondages',
            ],
          ),
          TutorialPage(
            title: 'Évaluez les Projets',
            description: 'Consultez, évaluez et commentez les projets de vos étudiants. Donnez des notes et des feedbacks constructifs.',
            icon: Icons.grade,
            color: const Color(0xFF10B981),
            features: [
              'Consulter tous les projets',
              'Attribuer des notes',
              'Laisser des commentaires',
              'Suivre les progressions',
            ],
          ),
          TutorialPage(
            title: 'Gérez les Groupes',
            description: 'Créez des groupes de travail pour vos étudiants et gérez les collaborations sur les projets.',
            icon: Icons.group,
            color: const Color(0xFF8B5CF6),
            features: [
              'Créer des groupes par cours',
              'Assigner des projets',
              'Gérer les membres',
              'Suivre les collaborations',
            ],
          ),
          TutorialPage(
            title: 'Créez des Sondages',
            description: 'Créez des sondages pour recueillir les avis de vos étudiants et améliorer vos cours.',
            icon: Icons.poll,
            color: const Color(0xFFF59E0B),
            features: [
              'Créer des sondages personnalisés',
              'Questions oui/non ou choix multiples',
              'Analyser les résultats',
              'Améliorer vos cours',
            ],
          ),
        ];

      case UserRole.admin:
        return [
          TutorialPage(
            title: 'Bienvenue Administrateur !',
            description: 'Découvrez comment administrer CampusWork, gérer les utilisateurs et superviser l\'ensemble de la plateforme.',
            icon: Icons.admin_panel_settings,
            color: const Color(0xFF4A90E2),
            features: [
              'Gérer tous les utilisateurs',
              'Superviser les projets',
              'Administrer les groupes',
              'Accéder aux statistiques',
            ],
          ),
          TutorialPage(
            title: 'Gestion des Utilisateurs',
            description: 'Approuvez ou rejetez les demandes d\'inscription et gérez les comptes utilisateurs.',
            icon: Icons.people,
            color: const Color(0xFF10B981),
            features: [
              'Approuver les inscriptions',
              'Gérer les rôles',
              'Créer des comptes',
              'Modérer les utilisateurs',
            ],
          ),
          TutorialPage(
            title: 'Supervision Globale',
            description: 'Supervisez tous les projets, groupes et activités sur la plateforme.',
            icon: Icons.dashboard,
            color: const Color(0xFF8B5CF6),
            features: [
              'Vue d\'ensemble système',
              'Statistiques détaillées',
              'Modération des contenus',
              'Gestion des données',
            ],
          ),
          TutorialPage(
            title: 'Outils Administrateur',
            description: 'Utilisez les outils avancés pour maintenir et optimiser la plateforme.',
            icon: Icons.build,
            color: const Color(0xFFF59E0B),
            features: [
              'Test de synchronisation',
              'Détection de similarité',
              'Gestion des sondages',
              'Maintenance système',
            ],
          ),
        ];
    }
  }

  Future<void> _markTutorialAsCompleted() async {
    await TutorialService.markTutorialCompleted(widget.userRole);
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeTutorial();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipTutorial() {
    _completeTutorial();
  }

  Future<void> _completeTutorial() async {
    await _markTutorialAsCompleted();
    if (mounted) {
      // Naviguer vers le dashboard approprié
      switch (widget.userRole) {
        case UserRole.student:
          context.go('/student-dashboard');
          break;
        case UserRole.lecturer:
          context.go('/lecturer-dashboard');
          break;
        case UserRole.admin:
          context.go('/admin-dashboard');
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _pages[_currentPage].color.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header avec logo et bouton skip
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppLogo.small(),
                    TextButton(
                      onPressed: _skipTutorial,
                      child: Text(
                        'Passer',
                        style: TextStyle(
                          color: _pages[_currentPage].color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Indicateur de progression
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: List.generate(
                    _pages.length,
                    (index) => Expanded(
                      child: Container(
                        height: 4,
                        margin: EdgeInsets.only(
                          right: index < _pages.length - 1 ? 8 : 0,
                        ),
                        decoration: BoxDecoration(
                          color: index <= _currentPage
                              ? _pages[_currentPage].color
                              : _pages[_currentPage].color.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Contenu des pages
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _buildTutorialPage(_pages[index]);
                  },
                ),
              ),

              // Boutons de navigation
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Bouton précédent
                    if (_currentPage > 0)
                      OutlinedButton(
                        onPressed: _previousPage,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _pages[_currentPage].color,
                          side: BorderSide(color: _pages[_currentPage].color),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: const Text('Précédent'),
                      )
                    else
                      const SizedBox(width: 100),

                    // Bouton suivant/terminer
                    ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _pages[_currentPage].color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        _currentPage == _pages.length - 1
                            ? 'Commencer'
                            : 'Suivant',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTutorialPage(TutorialPage page) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icône principale
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: page.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              page.icon,
              size: 40,
              color: page.color,
            ),
          ),

          const SizedBox(height: 24),

          // Titre
          Flexible(
            child: Text(
              page.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1A1D29),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const SizedBox(height: 12),

          // Description
          Flexible(
            child: Text(
              page.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF6B7280),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const SizedBox(height: 20),

          // Liste des fonctionnalités
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: page.features.take(3).map((feature) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: page.color.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                        child: Icon(
                          Icons.check,
                          size: 12,
                          color: page.color,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          feature,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF1A1D29),
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

/// Modèle pour une page de tutoriel
class TutorialPage {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final List<String> features;

  const TutorialPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.features,
  });
}