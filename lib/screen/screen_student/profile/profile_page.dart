import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:campuswork/auth/auth_service.dart';
import 'package:campuswork/model/user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin {
  late User _user;
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();
  late TabController _tabController;
  
  // Controllers pour l'édition des informations de base
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _githubController = TextEditingController();
  final _linkedinController = TextEditingController();
  
  // Controllers pour la description
  final _descriptionController = TextEditingController();
  final _skillsController = TextEditingController();
  final _passionsController = TextEditingController();
  final _qualitiesController = TextEditingController();
  final _experienceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _user = AuthService().currentUser!;
    _tabController = TabController(length: 2, vsync: this);
    _initializeControllers();
  }

  void _initializeControllers() {
    _firstNameController.text = _user.firstName;
    _lastNameController.text = _user.lastName;
    _emailController.text = _user.email;
    _phoneController.text = _user.phonenumber;
    
    // Pour les champs spécifiques aux étudiants, on utilise des valeurs par défaut
    _githubController.text = '';
    _linkedinController.text = '';
    
    // Initialiser les champs de description (simulés pour l'instant)
    _descriptionController.text = 'Étudiant passionné par le développement logiciel et les nouvelles technologies.';
    _skillsController.text = 'Flutter, Dart, Java, Python, JavaScript, React, Node.js, MySQL, Git';
    _passionsController.text = 'Développement mobile, Intelligence artificielle, Open source, Gaming';
    _qualitiesController.text = 'Créatif, Rigoureux, Travail en équipe, Résolution de problèmes, Adaptabilité';
    _experienceController.text = 'Stage développeur junior chez TechCorp (3 mois)\nProjet freelance application mobile (2022)\nContributeur open source sur GitHub';
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _githubController.dispose();
    _linkedinController.dispose();
    _descriptionController.dispose();
    _skillsController.dispose();
    _passionsController.dispose();
    _qualitiesController.dispose();
    _experienceController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await AuthService().updateUser(
      userId: _user.userId,
      firstname: _firstNameController.text.trim(),
      lastname: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      phonenumber: _phoneController.text.trim(),
    );

    if (success) {
      setState(() {
        _isEditing = false;
        _user = AuthService().currentUser!;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil mis à jour avec succès'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur lors de la mise à jour'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Profil'),
        actions: [
          if (_isEditing) ...[
            TextButton(
              onPressed: () {
                setState(() => _isEditing = false);
                _initializeControllers();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: _saveProfile,
              child: const Text('Sauvegarder'),
            ),
          ] else
            IconButton(
              onPressed: () => setState(() => _isEditing = true),
              icon: const Icon(Icons.edit),
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Informations', icon: Icon(Icons.person)),
            Tab(text: 'Description', icon: Icon(Icons.description)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildInformationsTab(),
          _buildDescriptionTab(),
        ],
      ),
    );
  }

  Widget _buildInformationsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Avatar et nom
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(
                      _user.firstName.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (!_isEditing) ...[
                    Text(
                      '${_user.firstName} ${_user.lastName}',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _user.email,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Informations personnelles
            _buildSectionCard(
              title: 'Informations personnelles',
              children: [
                if (_isEditing) ...[
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _firstNameController,
                          decoration: const InputDecoration(
                            labelText: 'Prénom',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) => value?.isEmpty == true ? 'Requis' : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _lastNameController,
                          decoration: const InputDecoration(
                            labelText: 'Nom',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) => value?.isEmpty == true ? 'Requis' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value?.isEmpty == true) return 'Requis';
                      if (!value!.contains('@')) return 'Email invalide';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Téléphone',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ] else ...[
                  _buildInfoRow('Prénom', _user.firstName),
                  _buildInfoRow('Nom', _user.lastName),
                  _buildInfoRow('Email', _user.email),
                  _buildInfoRow('Téléphone', _user.phonenumber.isNotEmpty ? _user.phonenumber : 'Non renseigné'),
                ],
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Informations académiques
            _buildSectionCard(
              title: 'Informations académiques',
              children: [
                _buildInfoRow('Rôle', _user.userRole.toString().split('.').last),
                _buildInfoRow('Statut', 'Étudiant actif'),
                _buildInfoRow('Année académique', '2023-2024'),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Liens sociaux
            _buildSectionCard(
              title: 'Liens sociaux',
              children: [
                if (_isEditing) ...[
                  TextFormField(
                    controller: _githubController,
                    decoration: const InputDecoration(
                      labelText: 'GitHub',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.code),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _linkedinController,
                    decoration: const InputDecoration(
                      labelText: 'LinkedIn',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.work),
                    ),
                  ),
                ] else ...[
                  _buildInfoRow('GitHub', _githubController.text.isNotEmpty ? _githubController.text : 'Non renseigné'),
                  _buildInfoRow('LinkedIn', _linkedinController.text.isNotEmpty ? _linkedinController.text : 'Non renseigné'),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildDescriptionCard(
            title: 'Description personnelle',
            controller: _descriptionController,
            icon: Icons.person_outline,
            hint: 'Décrivez-vous en quelques mots...',
          ),
          
          const SizedBox(height: 16),
          
          _buildDescriptionCard(
            title: 'Compétences techniques',
            controller: _skillsController,
            icon: Icons.code,
            hint: 'Listez vos compétences techniques (langages, frameworks, outils...)',
          ),
          
          const SizedBox(height: 16),
          
          _buildDescriptionCard(
            title: 'Passions et centres d\'intérêt',
            controller: _passionsController,
            icon: Icons.favorite_outline,
            hint: 'Quels sont vos centres d\'intérêt et passions ?',
          ),
          
          const SizedBox(height: 16),
          
          _buildDescriptionCard(
            title: 'Qualités personnelles',
            controller: _qualitiesController,
            icon: Icons.star_outline,
            hint: 'Décrivez vos principales qualités...',
          ),
          
          const SizedBox(height: 16),
          
          _buildDescriptionCard(
            title: 'Expérience professionnelle',
            controller: _experienceController,
            icon: Icons.work_outline,
            hint: 'Décrivez votre expérience professionnelle (stages, projets, emplois...)',
            maxLines: 5,
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionCard({
    required String title,
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    int maxLines = 3,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_isEditing)
              TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: hint,
                  border: const OutlineInputBorder(),
                ),
                maxLines: maxLines,
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Text(
                  controller.text.isNotEmpty ? controller.text : 'Non renseigné',
                  style: TextStyle(
                    color: controller.text.isNotEmpty ? null : Colors.grey[600],
                    fontStyle: controller.text.isNotEmpty ? null : FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}