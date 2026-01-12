import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

/// Service de synchronisation des données globales
/// Permet de partager les données entre tous les utilisateurs de l'application
class DataSyncService {
  static final DataSyncService _instance = DataSyncService._internal();
  factory DataSyncService() => _instance;
  DataSyncService._internal();

  // Clés pour les données globales
  static const String _globalGroupsKey = 'global_groups';
  static const String _globalProjectsKey = 'global_projects';
  static const String _globalUsersKey = 'global_users';
  static const String _globalNotificationsKey = 'global_notifications';
  static const String _globalPostsKey = 'global_posts';
  static const String _globalCommentsKey = 'global_comments';
  static const String _globalInteractionsKey = 'global_interactions';
  static const String _globalCollaborationRequestsKey = 'global_collaboration_requests';
  static const String _lastSyncKey = 'last_sync_timestamp';

  /// Obtenir les données globales pour une clé donnée
  Future<List<Map<String, dynamic>>> getGlobalData(String dataType) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _getGlobalKey(dataType);
      final data = prefs.getString(key);
      
      if (data != null) {
        final List<dynamic> jsonList = jsonDecode(data);
        return jsonList.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      debugPrint('❌ Error getting global data for $dataType: $e');
      return [];
    }
  }

  /// Sauvegarder les données globales pour une clé donnée
  Future<bool> saveGlobalData(String dataType, List<Map<String, dynamic>> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _getGlobalKey(dataType);
      await prefs.setString(key, jsonEncode(data));
      await _updateLastSyncTime();
      
      debugPrint('✅ Global data saved for $dataType: ${data.length} items');
      return true;
    } catch (e) {
      debugPrint('❌ Error saving global data for $dataType: $e');
      return false;
    }
  }

  /// Ajouter un élément aux données globales
  Future<bool> addToGlobalData(String dataType, Map<String, dynamic> item) async {
    try {
      final currentData = await getGlobalData(dataType);
      currentData.add(item);
      return await saveGlobalData(dataType, currentData);
    } catch (e) {
      debugPrint('❌ Error adding to global data for $dataType: $e');
      return false;
    }
  }

  /// Mettre à jour un élément dans les données globales
  Future<bool> updateInGlobalData(String dataType, String itemId, Map<String, dynamic> updatedItem, String idField) async {
    try {
      final currentData = await getGlobalData(dataType);
      final index = currentData.indexWhere((item) => item[idField] == itemId);
      
      if (index != -1) {
        currentData[index] = updatedItem;
        return await saveGlobalData(dataType, currentData);
      }
      return false;
    } catch (e) {
      debugPrint('❌ Error updating global data for $dataType: $e');
      return false;
    }
  }

  /// Supprimer un élément des données globales
  Future<bool> removeFromGlobalData(String dataType, String itemId, String idField) async {
    try {
      final currentData = await getGlobalData(dataType);
      currentData.removeWhere((item) => item[idField] == itemId);
      return await saveGlobalData(dataType, currentData);
    } catch (e) {
      debugPrint('❌ Error removing from global data for $dataType: $e');
      return false;
    }
  }

  /// Obtenir la clé globale pour un type de données
  String _getGlobalKey(String dataType) {
    switch (dataType) {
      case 'groups':
        return _globalGroupsKey;
      case 'projects':
        return _globalProjectsKey;
      case 'users':
        return _globalUsersKey;
      case 'notifications':
        return _globalNotificationsKey;
      case 'posts':
        return _globalPostsKey;
      case 'comments':
        return _globalCommentsKey;
      case 'interactions':
        return _globalInteractionsKey;
      case 'collaboration_requests':
        return _globalCollaborationRequestsKey;
      default:
        return 'global_$dataType';
    }
  }

  /// Mettre à jour le timestamp de la dernière synchronisation
  Future<void> _updateLastSyncTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_lastSyncKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      debugPrint('❌ Error updating last sync time: $e');
    }
  }

  /// Obtenir le timestamp de la dernière synchronisation
  Future<DateTime?> getLastSyncTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt(_lastSyncKey);
      return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
    } catch (e) {
      debugPrint('❌ Error getting last sync time: $e');
      return null;
    }
  }

  /// Forcer la synchronisation de toutes les données
  Future<void> forceSyncAll() async {
    debugPrint('🔄 Force syncing all data...');
    await _updateLastSyncTime();
    debugPrint('✅ Force sync completed');
  }

  /// Nettoyer les anciennes données (optionnel)
  Future<void> cleanOldData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      
      // Supprimer les anciennes clés non-globales si nécessaire
      for (final key in keys) {
        if (key.startsWith('groups') && key != _globalGroupsKey) {
          await prefs.remove(key);
        }
        if (key.startsWith('projects') && key != _globalProjectsKey) {
          await prefs.remove(key);
        }
        // Ajouter d'autres nettoyages si nécessaire
      }
      
      debugPrint('✅ Old data cleaned');
    } catch (e) {
      debugPrint('❌ Error cleaning old data: $e');
    }
  }

  /// Obtenir les statistiques de synchronisation
  Future<Map<String, dynamic>> getSyncStats() async {
    final lastSync = await getLastSyncTime();
    final groupsCount = (await getGlobalData('groups')).length;
    final projectsCount = (await getGlobalData('projects')).length;
    final usersCount = (await getGlobalData('users')).length;
    
    return {
      'lastSync': lastSync?.toIso8601String(),
      'groupsCount': groupsCount,
      'projectsCount': projectsCount,
      'usersCount': usersCount,
    };
  }
}