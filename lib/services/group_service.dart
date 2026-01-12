import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:campuswork/model/group.dart';
import 'package:campuswork/services/data_sync_service.dart';

class GroupService {
  static final GroupService _instance = GroupService._internal();
  factory GroupService() => _instance;
  GroupService._internal();

  static const _groupsKey = 'groups';
  List<Group> _groups = [];
  final DataSyncService _syncService = DataSyncService();

  Future<void> init() async {
    await _loadGroups();
  }

  Future<void> _loadGroups() async {
    try {
      // Charger d'abord les données globales
      final globalData = await _syncService.getGlobalData('groups');
      if (globalData.isNotEmpty) {
        _groups = globalData.map((json) => Group.fromMap(json)).toList();
        debugPrint('✅ Loaded ${_groups.length} groups from global data');
        return;
      }

      // Fallback vers les données locales si pas de données globales
      final prefs = await SharedPreferences.getInstance();
      final groupsData = prefs.getString(_groupsKey);
      if (groupsData != null) {
        final List<dynamic> groupsList = jsonDecode(groupsData);
        _groups = groupsList.map((json) => Group.fromMap(json)).toList();
        
        // Migrer vers les données globales
        await _syncService.saveGlobalData('groups', _groups.map((g) => g.toMap()).toList());
        debugPrint('✅ Migrated ${_groups.length} groups to global data');
      }
    } catch (e) {
      debugPrint('❌ Failed to load groups: $e');
      _groups = [];
    }
  }

  Future<void> _saveGroups() async {
    try {
      // Sauvegarder dans les données globales
      await _syncService.saveGlobalData('groups', _groups.map((g) => g.toMap()).toList());
      
      // Aussi sauvegarder localement pour la compatibilité
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_groupsKey, jsonEncode(_groups.map((g) => g.toMap()).toList()));
      
      debugPrint('✅ Saved ${_groups.length} groups to global and local storage');
    } catch (e) {
      debugPrint('❌ Failed to save groups: $e');
    }
  }

  /// Recharger les groupes depuis les données globales
  Future<void> refreshGroups() async {
    try {
      final globalData = await _syncService.getGlobalData('groups');
      _groups = globalData.map((json) => Group.fromMap(json)).toList();
      debugPrint('🔄 Refreshed ${_groups.length} groups from global data');
    } catch (e) {
      debugPrint('❌ Failed to refresh groups: $e');
    }
  }

  // Créer un groupe
  Future<bool> createGroup(Group group) async {
    try {
      final newGroup = group.copyWith(
        groupId: const Uuid().v4(),
        createdAt: DateTime.now(),
      );
      
      // Recharger les données les plus récentes avant d'ajouter
      await refreshGroups();
      
      _groups.add(newGroup);
      await _saveGroups();
      
      debugPrint('✅ Created group: ${newGroup.name} (ID: ${newGroup.groupId})');
      return true;
    } catch (e) {
      debugPrint('❌ Failed to create group: $e');
      return false;
    }
  }

  // Obtenir tous les groupes (avec rafraîchissement automatique)
  Future<List<Group>> getAllGroupsAsync() async {
    await refreshGroups();
    return List.unmodifiable(_groups);
  }

  // Obtenir tous les groupes (synchrone, pour compatibilité)
  List<Group> getAllGroups() => List.unmodifiable(_groups);

  // Obtenir les groupes créés par un utilisateur
  Future<List<Group>> getGroupsByCreatorAsync(String userId) async {
    await refreshGroups();
    return _groups.where((g) => g.createdBy == userId).toList();
  }

  List<Group> getGroupsByCreator(String userId) =>
      _groups.where((g) => g.createdBy == userId).toList();

  // Obtenir les groupes dont un utilisateur est membre
  Future<List<Group>> getGroupsByMemberAsync(String userId) async {
    await refreshGroups();
    return _groups.where((g) => g.isMember(userId)).toList();
  }

  List<Group> getGroupsByMember(String userId) =>
      _groups.where((g) => g.isMember(userId)).toList();

  // Obtenir les groupes par cours
  Future<List<Group>> getGroupsByCourseAsync(String courseName) async {
    await refreshGroups();
    return _groups.where((g) => g.courseName == courseName).toList();
  }

  List<Group> getGroupsByCourse(String courseName) =>
      _groups.where((g) => g.courseName == courseName).toList();

  // Obtenir un groupe par ID
  Future<Group?> getGroupByIdAsync(String groupId) async {
    await refreshGroups();
    try {
      return _groups.firstWhere((g) => g.groupId == groupId);
    } catch (e) {
      return null;
    }
  }

  Group? getGroupById(String groupId) {
    try {
      return _groups.firstWhere((g) => g.groupId == groupId);
    } catch (e) {
      return null;
    }
  }

  // Ajouter un membre à un groupe
  Future<bool> addMemberToGroup(String groupId, String userId) async {
    try {
      // Recharger les données les plus récentes
      await refreshGroups();
      
      final index = _groups.indexWhere((g) => g.groupId == groupId);
      if (index == -1) return false;

      final group = _groups[index];
      if (group.isFull || group.isMember(userId)) return false;

      final updatedMembers = List<String>.from(group.members)..add(userId);
      _groups[index] = group.copyWith(
        members: updatedMembers,
        updatedAt: DateTime.now(),
      );

      await _saveGroups();
      debugPrint('✅ Added member $userId to group ${group.name}');
      return true;
    } catch (e) {
      debugPrint('❌ Failed to add member to group: $e');
      return false;
    }
  }

  // Retirer un membre d'un groupe
  Future<bool> removeMemberFromGroup(String groupId, String userId) async {
    try {
      await refreshGroups();
      
      final index = _groups.indexWhere((g) => g.groupId == groupId);
      if (index == -1) return false;

      final group = _groups[index];
      if (!group.isMember(userId)) return false;

      final updatedMembers = List<String>.from(group.members)..remove(userId);
      _groups[index] = group.copyWith(
        members: updatedMembers,
        updatedAt: DateTime.now(),
      );

      await _saveGroups();
      debugPrint('✅ Removed member $userId from group ${group.name}');
      return true;
    } catch (e) {
      debugPrint('❌ Failed to remove member from group: $e');
      return false;
    }
  }

  // Ajouter un projet à un groupe
  Future<bool> addProjectToGroup(String groupId, String projectId) async {
    try {
      await refreshGroups();
      
      final index = _groups.indexWhere((g) => g.groupId == groupId);
      if (index == -1) return false;

      final group = _groups[index];
      if (group.projects.contains(projectId)) return false;

      final updatedProjects = List<String>.from(group.projects)..add(projectId);
      _groups[index] = group.copyWith(
        projects: updatedProjects,
        updatedAt: DateTime.now(),
      );

      await _saveGroups();
      debugPrint('✅ Added project $projectId to group ${group.name}');
      return true;
    } catch (e) {
      debugPrint('❌ Failed to add project to group: $e');
      return false;
    }
  }

  // Retirer un projet d'un groupe
  Future<bool> removeProjectFromGroup(String groupId, String projectId) async {
    try {
      await refreshGroups();
      
      final index = _groups.indexWhere((g) => g.groupId == groupId);
      if (index == -1) return false;

      final group = _groups[index];
      if (!group.projects.contains(projectId)) return false;

      final updatedProjects = List<String>.from(group.projects)..remove(projectId);
      _groups[index] = group.copyWith(
        projects: updatedProjects,
        updatedAt: DateTime.now(),
      );

      await _saveGroups();
      debugPrint('✅ Removed project $projectId from group ${group.name}');
      return true;
    } catch (e) {
      debugPrint('❌ Failed to remove project from group: $e');
      return false;
    }
  }

  // Mettre à jour un groupe
  Future<bool> updateGroup(Group group) async {
    try {
      await refreshGroups();
      
      final index = _groups.indexWhere((g) => g.groupId == group.groupId);
      if (index == -1) return false;

      _groups[index] = group.copyWith(updatedAt: DateTime.now());
      await _saveGroups();
      
      debugPrint('✅ Updated group: ${group.name}');
      return true;
    } catch (e) {
      debugPrint('❌ Failed to update group: $e');
      return false;
    }
  }

  // Supprimer un groupe
  Future<bool> deleteGroup(String groupId) async {
    try {
      await refreshGroups();
      
      final groupName = _groups.firstWhere((g) => g.groupId == groupId, orElse: () => Group(
        name: 'Unknown',
        description: '',
        createdBy: '',
        type: GroupType.project,
        maxMembers: 0,
        members: [],
        projects: [],
        isOpen: false,
        createdAt: DateTime.now(),
      )).name;
      
      _groups.removeWhere((g) => g.groupId == groupId);
      await _saveGroups();
      
      debugPrint('✅ Deleted group: $groupName');
      return true;
    } catch (e) {
      debugPrint('❌ Failed to delete group: $e');
      return false;
    }
  }

  // Rechercher des groupes
  Future<List<Group>> searchGroupsAsync(String query) async {
    await refreshGroups();
    if (query.isEmpty) return getAllGroups();
    
    return _groups.where((group) =>
      group.name.toLowerCase().contains(query.toLowerCase()) ||
      group.description.toLowerCase().contains(query.toLowerCase()) ||
      (group.courseName?.toLowerCase().contains(query.toLowerCase()) ?? false)
    ).toList();
  }

  List<Group> searchGroups(String query) {
    if (query.isEmpty) return getAllGroups();
    
    return _groups.where((group) =>
      group.name.toLowerCase().contains(query.toLowerCase()) ||
      group.description.toLowerCase().contains(query.toLowerCase()) ||
      (group.courseName?.toLowerCase().contains(query.toLowerCase()) ?? false)
    ).toList();
  }

  // Obtenir les groupes ouverts (que les étudiants peuvent rejoindre)
  Future<List<Group>> getOpenGroupsAsync() async {
    await refreshGroups();
    return _groups.where((g) => g.isOpen && !g.isFull).toList();
  }

  List<Group> getOpenGroups() =>
      _groups.where((g) => g.isOpen && !g.isFull).toList();

  // Obtenir les statistiques des groupes
  Future<Map<String, int>> getGroupStatsAsync() async {
    await refreshGroups();
    return {
      'total': _groups.length,
      'project': _groups.where((g) => g.type == GroupType.project).length,
      'study': _groups.where((g) => g.type == GroupType.study).length,
      'collaboration': _groups.where((g) => g.type == GroupType.collaboration).length,
      'open': _groups.where((g) => g.isOpen).length,
      'full': _groups.where((g) => g.isFull).length,
    };
  }

  Map<String, int> getGroupStats() {
    return {
      'total': _groups.length,
      'project': _groups.where((g) => g.type == GroupType.project).length,
      'study': _groups.where((g) => g.type == GroupType.study).length,
      'collaboration': _groups.where((g) => g.type == GroupType.collaboration).length,
      'open': _groups.where((g) => g.isOpen).length,
      'full': _groups.where((g) => g.isFull).length,
    };
  }
}