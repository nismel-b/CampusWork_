import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:campuswork/auth/auth_service.dart';
import 'package:campuswork/services/profile_settings_service.dart';
import 'package:campuswork/providers/theme_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final ProfileSettingsService _settingsService = ProfileSettingsService();
  late ProfileSettings _settings;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);
    try {
      _settings = _settingsService.getCurrentSettings();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Paramètres')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Paramètres'),
          ),
          body: ListView(
            children: [
              // Section Notifications
              _buildSectionHeader('Notifications'),
              SwitchListTile(
                title: const Text('Notifications push'),
                subtitle: const Text('Recevoir des notifications sur l\'appareil'),
                value: _settings.notificationsEnabled,
                onChanged: (value) async {
                  final success = await _settingsService.updateNotificationSettings(
                    notificationsEnabled: value,
                  );
                  if (success) {
                    await _loadSettings();
                  }
                },
              ),
              SwitchListTile(
                title: const Text('Notifications par email'),
                subtitle: const Text('Recevoir des notifications par email'),
                value: _settings.emailNotifications,
                onChanged: (value) async {
                  final success = await _settingsService.updateNotificationSettings(
                    emailNotifications: value,
                  );
                  if (success) {
                    await _loadSettings();
                  }
                },
              ),
              
              const Divider(),
              
              // Section Apparence
              _buildSectionHeader('Apparence'),
              ListTile(
                title: const Text('Thème'),
                subtitle: Text(themeProvider.getThemeDisplayName(themeProvider.themeMode)),
                leading: const Icon(Icons.palette),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _showThemeDialog(themeProvider),
              ),
              ListTile(
                title: const Text('Langue'),
                subtitle: Text(themeProvider.getLanguageDisplayName(_settings.language)),
                leading: const Icon(Icons.language),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _showLanguageDialog(themeProvider),
              ),
              
              const Divider(),
              
              // Section Notifications avancées
              _buildSectionHeader('Notifications avancées'),
              SwitchListTile(
                title: const Text('Mises à jour de projets'),
                subtitle: const Text('Notifications pour les changements de projets'),
                value: _settings.projectUpdates,
                onChanged: (value) async {
                  final success = await _settingsService.updateNotificationSettings(
                    projectUpdates: value,
                  );
                  if (success) {
                    await _loadSettings();
                  }
                },
              ),
              SwitchListTile(
                title: const Text('Invitations de groupe'),
                subtitle: const Text('Notifications pour les invitations'),
                value: _settings.groupInvitations,
                onChanged: (value) async {
                  final success = await _settingsService.updateNotificationSettings(
                    groupInvitations: value,
                  );
                  if (success) {
                    await _loadSettings();
                  }
                },
              ),
              SwitchListTile(
                title: const Text('Réponses aux commentaires'),
                subtitle: const Text('Notifications pour les réponses'),
                value: _settings.commentReplies,
                onChanged: (value) async {
                  final success = await _settingsService.updateNotificationSettings(
                    commentReplies: value,
                  );
                  if (success) {
                    await _loadSettings();
                  }
                },
              ),
              
              const Divider(),
              
              // Section Confidentialité
              _buildSectionHeader('Confidentialité'),
              SwitchListTile(
                title: const Text('Mode privé'),
                subtitle: const Text('Masquer votre profil aux autres utilisateurs'),
                value: _settings.privacyMode,
                onChanged: (value) async {
                  final success = await _settingsService.updatePrivacySettings(
                    privacyMode: value,
                  );
                  if (success) {
                    await _loadSettings();
                  }
                },
              ),
              SwitchListTile(
                title: const Text('Afficher l\'email'),
                subtitle: const Text('Permettre aux autres de voir votre email'),
                value: _settings.showEmail,
                onChanged: (value) async {
                  final success = await _settingsService.updatePrivacySettings(
                    showEmail: value,
                  );
                  if (success) {
                    await _loadSettings();
                  }
                },
              ),
              SwitchListTile(
                title: const Text('Autoriser la collaboration'),
                subtitle: const Text('Permettre aux autres de vous inviter'),
                value: _settings.allowCollaboration,
                onChanged: (value) async {
                  final success = await _settingsService.updatePrivacySettings(
                    allowCollaboration: value,
                  );
                  if (success) {
                    await _loadSettings();
                  }
                },
              ),
              
              const Divider(),
              
              // Section Compte
              _buildSectionHeader('Compte'),
              ListTile(
                title: const Text('Changer le mot de passe'),
                leading: const Icon(Icons.lock),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  _showChangePasswordDialog();
                },
              ),
              ListTile(
                title: const Text('Supprimer le compte'),
                leading: const Icon(Icons.delete, color: Colors.red),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  _showDeleteAccountDialog();
                },
              ),
              
              const Divider(),
              
              // Section À propos
              _buildSectionHeader('À propos'),
              ListTile(
                title: const Text('Version de l\'application'),
                subtitle: const Text('1.0.0'),
                leading: const Icon(Icons.info),
              ),
              ListTile(
                title: const Text('Conditions d\'utilisation'),
                leading: const Icon(Icons.description),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // TODO: Ouvrir les conditions d'utilisation
                },
              ),
              ListTile(
                title: const Text('Politique de confidentialité'),
                leading: const Icon(Icons.privacy_tip),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // TODO: Ouvrir la politique de confidentialité
                },
              ),
              
              const SizedBox(height: 32),
              
              // Bouton de déconnexion
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: _logout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Se déconnecter'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _showThemeDialog(ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choisir le thème'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: const Text('Clair'),
              subtitle: const Text('Thème clair'),
              value: ThemeMode.light,
              groupValue: themeProvider.themeMode,
              onChanged: (value) async {
                if (value != null) {
                  await themeProvider.setThemeMode(value);
                  await _loadSettings();
                  if (mounted) Navigator.pop(context);
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Sombre'),
              subtitle: const Text('Thème sombre'),
              value: ThemeMode.dark,
              groupValue: themeProvider.themeMode,
              onChanged: (value) async {
                if (value != null) {
                  await themeProvider.setThemeMode(value);
                  await _loadSettings();
                  if (mounted) Navigator.pop(context);
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Système'),
              subtitle: const Text('Suivre les paramètres du système'),
              value: ThemeMode.system,
              groupValue: themeProvider.themeMode,
              onChanged: (value) async {
                if (value != null) {
                  await themeProvider.setThemeMode(value);
                  await _loadSettings();
                  if (mounted) Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choisir la langue'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<AppLanguage>(
              title: const Text('Français'),
              value: AppLanguage.french,
              groupValue: _settings.language,
              onChanged: (value) async {
                if (value != null) {
                  await themeProvider.setLanguage(value);
                  await _loadSettings();
                  if (mounted) Navigator.pop(context);
                }
              },
            ),
            RadioListTile<AppLanguage>(
              title: const Text('English'),
              value: AppLanguage.english,
              groupValue: _settings.language,
              onChanged: (value) async {
                if (value != null) {
                  await themeProvider.setLanguage(value);
                  await _loadSettings();
                  if (mounted) Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordDialog() {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Changer le mot de passe'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: oldPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Ancien mot de passe',
                ),
                obscureText: true,
                validator: (value) => value?.isEmpty == true ? 'Requis' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: newPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Nouveau mot de passe',
                ),
                obscureText: true,
                validator: (value) {
                  if (value?.isEmpty == true) return 'Requis';
                  if (value!.length < 6) return 'Au moins 6 caractères';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirmer le mot de passe',
                ),
                obscureText: true,
                validator: (value) {
                  if (value?.isEmpty == true) return 'Requis';
                  if (value != newPasswordController.text) {
                    return 'Les mots de passe ne correspondent pas';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final success = await AuthService().changePassword(
                  userId: AuthService().currentUser!.userId,
                  oldPassword: oldPasswordController.text,
                  newPassword: newPasswordController.text,
                );
                
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(success 
                        ? 'Mot de passe changé avec succès'
                        : 'Erreur lors du changement de mot de passe'),
                      backgroundColor: success ? Colors.green : Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Changer'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le compte'),
        content: const Text(
          'Êtes-vous sûr de vouloir supprimer votre compte ? '
          'Cette action est irréversible et toutes vos données seront perdues.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              // TODO: Implémenter la suppression du compte
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fonctionnalité non encore implémentée'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Se déconnecter'),
        content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              await AuthService().logout();
              if (mounted) {
                context.go('/');
              }
            },
            child: const Text('Se déconnecter'),
          ),
        ],
      ),
    );
  }
}