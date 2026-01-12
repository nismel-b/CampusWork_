import 'package:flutter/material.dart';
import 'package:campuswork/services/profile_settings_service.dart';

class ThemeProvider extends ChangeNotifier {
  static final ThemeProvider _instance = ThemeProvider._internal();
  factory ThemeProvider() => _instance;
  ThemeProvider._internal();

  ProfileSettingsService get _settingsService => ProfileSettingsService();
  
  ThemeMode _themeMode = ThemeMode.system;
  AppLanguage _language = AppLanguage.french;

  ThemeMode get themeMode => _themeMode;
  AppLanguage get language => _language;

  Future<void> init() async {
    await _settingsService.init();
    final settings = _settingsService.getCurrentSettings();
    
    // Convert AppTheme to ThemeMode
    switch (settings.theme) {
      case AppTheme.light:
        _themeMode = ThemeMode.light;
        break;
      case AppTheme.dark:
        _themeMode = ThemeMode.dark;
        break;
      case AppTheme.system:
        _themeMode = ThemeMode.system;
        break;
    }
    
    _language = settings.language;
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    
    _themeMode = mode;
    
    // Convert ThemeMode to AppTheme
    AppTheme appTheme;
    switch (mode) {
      case ThemeMode.light:
        appTheme = AppTheme.light;
        break;
      case ThemeMode.dark:
        appTheme = AppTheme.dark;
        break;
      case ThemeMode.system:
        appTheme = AppTheme.system;
        break;
    }
    
    await _settingsService.updateTheme(appTheme);
    notifyListeners();
  }

  Future<void> setLanguage(AppLanguage newLanguage) async {
    if (_language == newLanguage) return;
    
    _language = newLanguage;
    await _settingsService.updateLanguage(newLanguage);
    notifyListeners();
  }

  String getLanguageDisplayName(AppLanguage language) {
    switch (language) {
      case AppLanguage.french:
        return 'Français';
      case AppLanguage.english:
        return 'English';
    }
  }

  String getThemeDisplayName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Clair';
      case ThemeMode.dark:
        return 'Sombre';
      case ThemeMode.system:
        return 'Système';
    }
  }
}